#!/usr/bin/env python3
"""Audit how py-galois binds WHERE predicates to tables, and how often that binding fails.

`py_galois.sql_utils.extract_where_atoms` builds an alias-to-table map with the regex

    \\b(from|join)\\s+([A-Za-z_][\\w.]*)\\s+([A-Za-z_][\\w]*)

which captures the token that follows the table name as the alias. When a query writes
`FROM t AS a`, the captured token is the keyword `AS` rather than `a`, so the alias `a`
never enters the map. Every predicate qualified with `a.` is then filed under the key
`'a'`, which is not a table name, and the planner, which iterates over real table names,
finds no predicate to push. The scan therefore runs unfiltered.

This script reports, per dataset and per query, whether each WHERE atom is bound to a
real table or lost, so the blast radius of the defect can be measured exactly.

Read-only.
"""
from __future__ import annotations

import argparse
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "pygalois"))

# Benchmarks live in benchmarks/ in this repository and in data/ in the
# development tree; accept either so the script runs unchanged in both.
DATA_ROOT = ROOT / "benchmarks" if (ROOT / "benchmarks").is_dir() else ROOT / "data"

from py_galois.sql_utils import extract_where_atoms, referenced_tables  # noqa: E402

DATASETS = ["flight-2", "flight-4", "geo", "movies", "presidents", "world",
            "paintings", "paintings_extended", "nobel_prizes"]


def load_queries(ds: str):
    f = next((DATA_ROOT / ds).glob("queries_*.sql"), None)
    if f is None:
        return []
    return [l.strip() for l in f.read_text(encoding="utf-8").splitlines()
            if l.strip() and not l.strip().startswith("--")]


def uses_as_keyword(sql: str) -> bool:
    return bool(re.search(r"\b(?:from|join)\s+[A-Za-z_][\w.]*\s+as\s+[A-Za-z_]\w*", sql, re.I))


def analyse(sql: str):
    """Return (n_atoms, n_bound, n_lost, lost_keys).

    This replicates the planner exactly, including its recovery rule: for a
    single-table query both `build_plans` and `build_all_pushdown_table_plan` merge the
    `__unknown__` bucket into that one table, so unqualified predicates are *not* lost
    there. Anything still filed under a key that is not a real table name is lost,
    because the planner only ever looks up real table names.
    """
    tables = referenced_tables(sql)
    atoms = {k: list(v) for k, v in extract_where_atoms(sql).items()}
    total = sum(len(v) for v in atoms.values())

    if len(tables) == 1 and "__unknown__" in atoms:
        only = next(iter(tables))
        atoms[only] = atoms.get(only, []) + atoms.pop("__unknown__")

    bound = lost = 0
    lost_keys = []
    for key, lst in atoms.items():
        if key in tables:
            bound += len(lst)
        else:
            lost += len(lst)
            lost_keys.append(key)
    return total, bound, lost, lost_keys


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    print(f"{'dataset':<20}{'query':>7}{'con WHERE':>11}{'atomi':>7}"
          f"{'legati':>8}{'persi':>7}{'query con perdita':>19}{'usa AS':>8}")
    print("-" * 88)
    grand = Counter()
    per_ds_lost = defaultdict(list)

    for ds in DATASETS:
        qs = load_queries(ds)
        if not qs:
            continue
        c = Counter()
        for i, sql in enumerate(qs, 1):
            c["queries"] += 1
            n, b, l, keys = analyse(sql)
            if n:
                c["with_where"] += 1
            c["atoms"] += n
            c["bound"] += b
            c["lost"] += l
            if l:
                c["queries_lost"] += 1
                per_ds_lost[ds].append((i, sql, keys, len(referenced_tables(sql))))
            if uses_as_keyword(sql):
                c["uses_as"] += 1
        print(f"{ds:<20}{c['queries']:>7}{c['with_where']:>11}{c['atoms']:>7}"
              f"{c['bound']:>8}{c['lost']:>7}{c['queries_lost']:>19}{c['uses_as']:>8}")
        for k, v in c.items():
            grand[k] += v

    print("-" * 88)
    print(f"{'TOTALE':<20}{grand['queries']:>7}{grand['with_where']:>11}{grand['atoms']:>7}"
          f"{grand['bound']:>8}{grand['lost']:>7}{grand['queries_lost']:>19}{grand['uses_as']:>8}")
    if grand["atoms"]:
        print(f"\npredicati persi: {grand['lost']}/{grand['atoms']} "
              f"({100 * grand['lost'] / grand['atoms']:.1f}%)")
        print(f"query con almeno un predicato perso: {grand['queries_lost']}/{grand['queries']} "
              f"({100 * grand['queries_lost'] / grand['queries']:.1f}%)")

    print("\nDettaglio per dataset colpito:")
    for ds, items in per_ds_lost.items():
        multi = sum(1 for _, _, _, nt in items if nt > 1)
        print(f"\n  {ds}: {len(items)} query, di cui {multi} multi-tabella")
        for i, sql, keys, nt in items[:3]:
            print(f"    query{i} ({nt} tab) chiavi non risolte={keys}")
            print(f"      {sql[:140]}")
        if len(items) > 3:
            print(f"    ... e altre {len(items) - 3}")


if __name__ == "__main__":
    main()
