
import re, sqlite3, json, os
from typing import List, Dict, Tuple, Any, Optional


# Tokens that may legitimately follow a table reference and must never be taken as its
# alias. Without this guard, "FROM airports WHERE ..." would register WHERE as an alias.
_NON_ALIAS_TOKENS = {
    "as", "on", "using", "where", "join", "inner", "left", "right", "full", "outer",
    "cross", "natural", "group", "order", "having", "limit", "union", "intersect",
    "except",
}


def _mask_string_literals(text: str) -> str:
    """Blank out the body of single-quoted literals, preserving length and offsets.

    Needed so that a dot inside a literal is not mistaken for a table qualifier:
    in ``name = 'Barack H. Obama'`` the ``H.`` would otherwise be read as an alias.
    """
    return re.sub(r"'[^']*'", lambda m: "'" + "x" * (len(m.group(0)) - 2) + "'", text)


def extract_where_atoms(sql: str) -> Dict[str, List[str]]:
    """Very simple WHERE atom splitter per table.
    Returns: mapping table_name -> list of atom strings for that table.
    This is heuristic; adequate for Spider-style queries in provided data.
    """
    import re
    from typing import Dict, List

    # Normalize spaces and remove schema prefix 'target.'
    s = re.sub(r'\s+', ' ', sql)
    s = s.replace('target.', '')

    # Build alias -> table-name map from FROM / JOIN clauses.
    # The optional AS keyword is skipped so that "FROM t AS a" maps a (not AS) to t.
    alias_map: Dict[str, str] = {}
    for m_tbl in re.finditer(
        r'\b(from|join)\s+([A-Za-z_][\w\.]*)\s+(?:as\s+)?([A-Za-z_][\w]*)',
        s,
        flags=re.IGNORECASE,
    ):
        table = m_tbl.group(2).split('.')[-1]  # strip any schema
        alias = m_tbl.group(3)
        if alias.lower() in _NON_ALIAS_TOKENS:
            continue
        alias_map[alias] = table

    # Capture WHERE clause
    m = re.search(r' where (.+?)( group by| order by| limit|;$)', s, flags=re.IGNORECASE)
    atoms: Dict[str, List[str]] = {}
    if not m:
        return atoms

    where_clause = m.group(1)
    # Split on AND / OR keeping terms
    terms = re.split(r'\s+(?:and|or)\s+', where_clause, flags=re.IGNORECASE)

    # Associate term to a table: use alias→table mapping when possible.
    # The prefix is searched on a literal-masked copy so that dots inside quoted values
    # are not mistaken for qualifiers; the atom itself is kept verbatim.
    for t in terms:
        q = t.strip().strip('()')
        m2 = re.search(r'([A-Za-z_][\w]*)\.', _mask_string_literals(q))
        if m2:
            prefix = m2.group(1)           # alias or table
            tbl = alias_map.get(prefix, prefix)
        else:
            # fallback: unknown table
            tbl = '__unknown__'
        atoms.setdefault(tbl, []).append(q)

    return atoms

def strip_schema(sql: str) -> str:
    return sql.replace('target.', '')

def referenced_tables(sql: str) -> set[str]:
    s = re.sub(r'\s+', ' ', sql, flags=re.IGNORECASE).replace('target.', '')
    names = []
    for m in re.finditer(r'(?:from|join)\s+([A-Za-z_][\w\.]*)\b', s, flags=re.IGNORECASE):
        names.append(m.group(1).split('.')[-1])
    return set(names)


def translate_to_sqlite(sql: str) -> str:
    s = strip_schema(sql)
    # TRY_CAST(x AS TYPE) -> CAST(x AS TYPE)
    s = re.sub(r'TRY_CAST\s*\(', 'CAST(', s, flags=re.IGNORECASE)
    # TRUE/FALSE -> 1/0
    s = re.sub(r'\bTRUE\b', '1', s, flags=re.IGNORECASE)
    s = re.sub(r'\bFALSE\b', '0', s, flags=re.IGNORECASE)
    return s

def exec_sqlite_query(tables: Dict[str, List[Dict[str, Any]]], sql: str) -> List[Dict[str, Any]]:
    """Execute SQL over the provided in-memory tables using sqlite3. 
    Limitations: SQLite SQL dialect; may not support every query.
    """
    conn = sqlite3.connect(':memory:')
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    # Create tables
    for name, rows in tables.items():
        if not rows:
            # allow e.g. SELECT COUNT(*) FROM table
            cur.execute(f'CREATE TABLE {name}(__dummy TEXT)')
        else:
            cols = list(rows[0].keys())
            # TEXT COLLATE NOCASE => "foo" = "FOO" = "Foo"
            schema = ', '.join([f'{c} TEXT COLLATE NOCASE' for c in cols])
            cur.execute(f'CREATE TABLE {name}({schema})')

            # insert rows *without* lowercasing
            for r in rows:
                values = [None if r.get(c, None) is None else str(r.get(c, None)) for c in cols]
                cur.execute(
                    f'INSERT INTO {name} VALUES ({",".join(["?"]*len(cols))})',
                    values
                )

    # Execute SQL (still run through translate_to_sqlite for TRY_CAST, TRUE/FALSE, etc.)
    s = translate_to_sqlite(sql)
    try:
        try:
            cur.execute(s)
            out = [dict(row) for row in cur.fetchall()]
            return out
        except sqlite3.OperationalError as e:
            # Most likely: LLM produced inconsistent columns vs. SQL;
            # treat this as "no answer" instead of crashing the whole run.
            # You might also want to log `e` somewhere if debugging.
            return []
    finally:
        conn.close()

