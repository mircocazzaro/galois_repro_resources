#!/usr/bin/env python3
"""Operator-level audit of how py-galois executes multi-table joins.

For every query of a GaloisA run this script recovers, from the run logs, the rows
that each LLM-facing scan materialized, then replays the deterministic relational
step exactly as `py_galois.sql_utils.exec_sqlite_query` does, except that SQLite
errors are surfaced instead of being swallowed. Each query is then classified by
the first stage at which it loses its result:

  rows          the join executed and returned tuples
  empty_scan    at least one scanned relation came back empty, so the join has no
                input; note that py-galois then creates a placeholder table with a
                single __dummy column, which makes the subsequent SQL fail
  sql_error     the deterministic SQL step raised an error that production code
                converts into an empty result set
  disjoint_keys the SQL executed cleanly but the join keys of the independently
                scanned relations do not intersect

Read-only: it never writes into a run directory.
"""
from __future__ import annotations

import argparse
import ast
import json
import re
import sqlite3
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "pygalois"))

from py_galois.sql_utils import referenced_tables, strip_schema, translate_to_sqlite  # noqa: E402

SCAN_RE = re.compile(r"(TableScan|KeyScan)\[([^\]]+)\]\s+strategy=(\S+)\s+pushed=(.*?)\s+rows=(\d+)")


def _extract_list(text: str, start: int):
    """Return the Python literal list that starts at `start`, and the index after it."""
    depth, i, in_str, quote, esc = 0, start, False, "", False
    while i < len(text):
        c = text[i]
        if in_str:
            if esc:
                esc = False
            elif c == "\\":
                esc = True
            elif c == quote:
                in_str = False
        else:
            if c in "\"'":
                in_str, quote = True, c
            elif c == "[":
                depth += 1
            elif c == "]":
                depth -= 1
                if depth == 0:
                    return text[start:i + 1], i + 1
        i += 1
    return None, len(text)


def parse_log(path: Path):
    """Recover the SQL, the per-table plan and the per-table scanned rows from a run log."""
    txt = path.read_text(encoding="utf-8", errors="replace")
    m = re.search(r"^SQL:\s*(.+)$", txt, re.M)
    sql = m.group(1).strip() if m else None

    plan = {}
    for m in re.finditer(r"^\s+-\s+(\S+):\s+strategy=(\S+),\s+pushed=(.*?),\s+physical=(\S+),", txt, re.M):
        plan[m.group(1)] = {"strategy": m.group(2), "pushed": m.group(3), "physical": m.group(4)}

    rows_by_table = {}
    for m in SCAN_RE.finditer(txt):
        table = m.group(2)
        j = txt.find("fetched_rows=", m.end())
        if j == -1:
            continue
        lit, _ = _extract_list(txt, j + len("fetched_rows="))
        if lit is None:
            continue
        try:
            rows_by_table[table] = ast.literal_eval(lit)
        except (ValueError, SyntaxError):
            rows_by_table[table] = None  # unparseable
    return sql, plan, rows_by_table


def replay(rows_by_table, sql):
    """Replay the deterministic step, surfacing SQLite errors instead of hiding them."""
    refs = referenced_tables(sql)
    subset = {t: rows_by_table.get(t) for t in refs}
    missing = [t for t, v in subset.items() if v is None]
    empty = [t for t, v in subset.items() if v is not None and len(v) == 0]

    conn = sqlite3.connect(":memory:")
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    try:
        for name, rows in subset.items():
            if not rows:
                cur.execute(f"CREATE TABLE {name}(__dummy TEXT)")
            else:
                cols = list(rows[0].keys())
                schema = ", ".join(f"{c} TEXT COLLATE NOCASE" for c in cols)
                cur.execute(f"CREATE TABLE {name}({schema})")
                for r in rows:
                    cur.execute(
                        f"INSERT INTO {name} VALUES ({','.join(['?'] * len(cols))})",
                        [None if r.get(c) is None else str(r.get(c)) for c in cols],
                    )
        try:
            cur.execute(translate_to_sqlite(strip_schema(sql)))
            out = [dict(r) for r in cur.fetchall()]
            return {"n": len(out), "error": None, "empty": empty, "missing": missing}
        except sqlite3.Error as e:
            return {"n": 0, "error": f"{type(e).__name__}: {e}", "empty": empty, "missing": missing}
    finally:
        conn.close()


def key_overlap(rows_by_table, sql):
    """For an equi-join on ON a.x = b.y, report how many key values the two sides share."""
    out = []
    s = strip_schema(re.sub(r"\s+", " ", sql))
    alias = {}
    for m in re.finditer(r"\b(?:from|join)\s+([A-Za-z_]\w*)\s+(?:as\s+)?([A-Za-z_]\w*)", s, re.I):
        alias[m.group(2)] = m.group(1)
    for m in re.finditer(r"\bon\s+([A-Za-z_]\w*)\.(\w+)\s*=\s*([A-Za-z_]\w*)\.(\w+)", s, re.I):
        la, lc, ra, rc = m.groups()
        lt, rt = alias.get(la, la), alias.get(ra, ra)
        lrows, rrows = rows_by_table.get(lt) or [], rows_by_table.get(rt) or []
        lv = {str(r.get(lc)).strip().lower() for r in lrows if r.get(lc) is not None}
        rv = {str(r.get(rc)).strip().lower() for r in rrows if r.get(rc) is not None}
        out.append({
            "cond": f"{lt}.{lc} = {rt}.{rc}",
            "left": len(lv), "right": len(rv), "shared": len(lv & rv),
        })
    return out


def join_only_rows(rows_by_table, sql):
    """Execute the FROM/JOIN part alone, without the residual WHERE, to find out whether
    the result dies at the join or at the selection that follows it. Returns None when the
    join-only query cannot be built or run."""
    s = strip_schema(re.sub(r"\s+", " ", sql)).rstrip(";")
    m = re.search(r"\bfrom\b(.*?)(?:\bwhere\b|\bgroup by\b|\border by\b|\blimit\b|$)", s, re.I)
    if not m:
        return None
    from_clause = m.group(1).strip()
    conn = sqlite3.connect(":memory:")
    cur = conn.cursor()
    try:
        for name in referenced_tables(sql):
            rows = rows_by_table.get(name)
            if not rows:
                return None
            cols = list(rows[0].keys())
            cur.execute(f"CREATE TABLE {name}({', '.join(f'{c} TEXT COLLATE NOCASE' for c in cols)})")
            for r in rows:
                cur.execute(
                    f"INSERT INTO {name} VALUES ({','.join(['?'] * len(cols))})",
                    [None if r.get(c) is None else str(r.get(c)) for c in cols],
                )
        try:
            cur.execute(f"SELECT COUNT(*) FROM {from_clause}")
            return cur.fetchone()[0]
        except sqlite3.Error:
            return None
    finally:
        conn.close()


def classify(res, rows_by_table, sql):
    if res["missing"]:
        return "unparsed_log"
    if res["n"] > 0:
        return "rows"
    if res["empty"]:
        return "empty_scan"
    if res["error"]:
        return "sql_error"
    # No error and no output. For a single-table query this simply means that the
    # scanned rows satisfy no predicate. For a join we separate the two possibilities:
    # the join itself produced nothing, or it produced tuples that the residual
    # selection then discarded.
    if len(referenced_tables(sql)) == 1:
        return "empty_result"
    n = join_only_rows(rows_by_table, sql)
    if n == 0:
        return "join_empty"
    if n and n > 0:
        return "filter_empty"
    return "disjoint_keys"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--run-dir", required=True, type=Path,
                    help="directory containing query*.log, e.g. .../galois_a/run_1/paintings_extended")
    ap.add_argument("--family-size", type=int, default=10)
    ap.add_argument("--label", default="")
    ap.add_argument("--show-examples", type=int, default=2)
    args = ap.parse_args()

    logs = sorted(args.run_dir.glob("query*.log"),
                  key=lambda p: int(re.search(r"\d+", p.stem).group()))
    if not logs:
        raise SystemExit(f"no query*.log in {args.run_dir}")

    per_family = defaultdict(Counter)
    overall = Counter()
    multi_only = Counter()
    examples = defaultdict(list)
    overlaps = []

    for log in logs:
        qn = int(re.search(r"\d+", log.stem).group())
        fam = (qn - 1) // args.family_size + 1
        sql, plan, rows_by_table = parse_log(log)
        if not sql:
            continue
        ntab = len(referenced_tables(sql))
        res = replay(rows_by_table, sql)
        cls = classify(res, rows_by_table, sql)
        per_family[fam][cls] += 1
        overall[cls] += 1
        if ntab > 1:
            multi_only[cls] += 1
            if cls in ("join_empty", "filter_empty", "disjoint_keys", "sql_error", "empty_scan"):
                ov = key_overlap(rows_by_table, sql)
                overlaps.extend(ov)
                if len(examples[cls]) < args.show_examples:
                    examples[cls].append({
                        "query": log.stem, "sql": sql, "ntab": ntab,
                        "plan": plan, "error": res["error"], "empty": res["empty"],
                        "rows_per_table": {t: len(v or []) for t, v in rows_by_table.items()},
                        "overlap": ov,
                    })

    order = ["rows", "join_empty", "filter_empty", "disjoint_keys",
             "sql_error", "empty_scan", "empty_result", "unparsed_log"]
    print(f"\n{'=' * 78}\nAUDIT JOIN MULTI-TABELLA {args.label}\n{'=' * 78}")
    print(f"run: {args.run_dir}\nquery analizzate: {sum(overall.values())}\n")

    print(f"{'famiglia':<10}{'#tab':>5}  " + "".join(f"{c:>15}" for c in order))
    print("-" * 88)
    for fam in sorted(per_family):
        first = args.run_dir / f"query{(fam - 1) * args.family_size + 1}.log"
        sql, _, _ = parse_log(first) if first.exists() else (None, None, None)
        ntab = len(referenced_tables(sql)) if sql else 0
        line = f"q{fam:<9}{ntab:>5}  "
        for c in order:
            line += f"{per_family[fam][c] or '-':>15}"
        print(line)

    print("\nTotale su tutte le query:")
    for c in order:
        if overall[c]:
            print(f"   {c:<15} {overall[c]:>4}")
    print("\nSolo query con piu' di una tabella:")
    tot_multi = sum(multi_only.values())
    for c in order:
        if multi_only[c]:
            print(f"   {c:<15} {multi_only[c]:>4}  ({100 * multi_only[c] / tot_multi:.1f}%)")

    if overlaps:
        shared0 = sum(1 for o in overlaps if o["shared"] == 0)
        print(f"\nCondizioni di join esaminate: {len(overlaps)}; "
              f"con zero valori di chiave in comune: {shared0} "
              f"({100 * shared0 / len(overlaps):.1f}%)")

    for cls, exs in examples.items():
        for e in exs:
            print(f"\n--- esempio [{cls}] {e['query']} ({e['ntab']} tabelle)")
            print(f"    SQL   : {e['sql'][:150]}")
            print(f"    piano : " + "; ".join(
                f"{t}: strategy={c['strategy']}, pushed={c['pushed']}, physical={c['physical']}"
                for t, c in (e["plan"] or {}).items()))
            print(f"    righe materializzate per tabella: {e['rows_per_table']}")
            if e["empty"]:
                print(f"    scansioni vuote: {e['empty']}")
            if e["error"]:
                print(f"    errore SQL (in produzione soppresso): {e['error']}")
            for o in e["overlap"]:
                print(f"    chiavi {o['cond']}: sinistra={o['left']} destra={o['right']} comuni={o['shared']}")


if __name__ == "__main__":
    main()
