#!/usr/bin/env python3
"""Validate Kanopi Delivery Record files against the bundled spec.

Resolves the schema version from each record's ``predicate_type``, validates the
YAML front-matter against ``spec/delivery-record/v<n>/schema.json``, and applies
the threshold rule (a ``fail`` check needs a ``## Waiver`` heading; an ``n/a``
check needs a one-line justification near the top of the body) as soft warnings.

Usage:
    delivery_record_verify.py [PATH ...] [--strict] [--json]

With no PATH, auto-detects ``docs/delivery-records/*.md`` under the current
working directory.

Exit codes:
    0  all records valid (warnings allowed unless --strict)
    1  one or more records failed hard validation (or a warning under --strict)
    2  usage / environment error (e.g. missing dependency, unreadable spec)
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import re
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
SPEC_ROOT = os.path.join(REPO_ROOT, "spec", "delivery-record")

PREDICATE_RE = re.compile(
    r"^https://kanopi\.github\.io/cms-cultivator/spec/delivery-record/(v\d+)/?$"
)

# ANSI-free status glyphs so output is stable in CI logs.
OK = "✓"      # ✓
BAD = "✗"     # ✗
WARN = "⚠"    # ⚠


def _fail(message: str, code: int = 2) -> "NoReturn":  # type: ignore[name-defined]
    print(f"error: {message}", file=sys.stderr)
    sys.exit(code)


def _require_deps():
    try:
        import yaml  # noqa: F401
        import jsonschema  # noqa: F401
    except ImportError as exc:  # pragma: no cover - environment dependent
        _fail(
            f"missing Python dependency: {exc.name}. "
            "Install with: pip install pyyaml jsonschema"
        )


def split_front_matter(text: str):
    """Return (front_matter_str, body_str) or (None, text) if absent."""
    if not text.startswith("---"):
        return None, text
    # Match the opening fence and the next fence on its own line.
    m = re.match(r"^---\s*\n(.*?)\n---\s*(?:\n(.*))?$", text, re.DOTALL)
    if not m:
        return None, text
    return m.group(1), (m.group(2) or "")


def resolve_schema_dir(predicate_type: str):
    m = PREDICATE_RE.match(predicate_type or "")
    if not m:
        return None
    return os.path.join(SPEC_ROOT, m.group(1))


def leaf_statuses(checks):
    """Yield lower-cased string leaf values found anywhere in the checks tree."""
    if isinstance(checks, dict):
        for value in checks.values():
            yield from leaf_statuses(value)
    elif isinstance(checks, list):
        for value in checks:
            yield from leaf_statuses(value)
    elif isinstance(checks, str):
        yield checks.strip().lower()


def verify_file(path: str, strict: bool):
    """Return a result dict: {path, ok, errors[], warnings[]}."""
    import yaml
    from jsonschema import Draft202012Validator

    result = {"path": path, "ok": False, "errors": [], "warnings": []}

    try:
        with open(path, "r", encoding="utf-8") as fh:
            text = fh.read()
    except OSError as exc:
        result["errors"].append(f"cannot read file: {exc}")
        return result

    front_matter, body = split_front_matter(text)
    if front_matter is None:
        result["errors"].append("no YAML front-matter found — not a Delivery Record")
        return result

    try:
        data = yaml.safe_load(front_matter)
    except yaml.YAMLError as exc:
        result["errors"].append(f"invalid YAML front-matter: {exc}")
        return result

    if not isinstance(data, dict):
        result["errors"].append("front-matter is not a mapping")
        return result

    predicate = data.get("predicate_type")
    schema_dir = resolve_schema_dir(predicate)
    if schema_dir is None:
        result["errors"].append(
            f"predicate_type missing or malformed: {predicate!r} — not a Delivery Record"
        )
        return result

    schema_path = os.path.join(schema_dir, "schema.json")
    if not os.path.isfile(schema_path):
        result["errors"].append(f"no schema found for predicate_type at {schema_path}")
        return result

    with open(schema_path, "r", encoding="utf-8") as fh:
        schema = json.load(fh)

    validator = Draft202012Validator(schema)
    for err in sorted(validator.iter_errors(data), key=lambda e: list(e.path)):
        loc = "/".join(str(p) for p in err.path) or "(root)"
        result["errors"].append(f"{loc}: {err.message}")

    # Threshold rule (soft warnings).
    statuses = list(leaf_statuses(data.get("checks", {})))
    head = "\n".join(body.strip().splitlines()[:5]).lower()

    if "fail" in statuses and not re.search(r"^\s*#{1,6}\s+waiver\b", body, re.IGNORECASE | re.MULTILINE):
        result["warnings"].append(
            "a check is `fail` but the body has no `## Waiver` heading"
        )
    if "n/a" in statuses and ("n/a" not in head and "not applicable" not in head):
        result["warnings"].append(
            "a check is `n/a` but no justification appears within the first 5 lines of the body"
        )

    hard_ok = not result["errors"]
    result["ok"] = hard_ok and (not result["warnings"] or not strict)
    return result


def main(argv=None):
    parser = argparse.ArgumentParser(description="Validate Kanopi Delivery Records.")
    parser.add_argument("paths", nargs="*", help="record files (default: docs/delivery-records/*.md)")
    parser.add_argument("--strict", action="store_true", help="treat soft warnings as failures")
    parser.add_argument("--json", action="store_true", help="emit machine-readable JSON")
    args = parser.parse_args(argv)

    _require_deps()

    paths = args.paths
    if not paths:
        paths = sorted(glob.glob(os.path.join("docs", "delivery-records", "*.md")))
        if not paths:
            print("No records found (docs/delivery-records/*.md). Pass a path explicitly.")
            return 0

    results = [verify_file(p, args.strict) for p in paths]

    if args.json:
        print(json.dumps(results, indent=2))
    else:
        for r in results:
            mark = OK if r["ok"] else BAD
            print(f"{mark} {r['path']}")
            for e in r["errors"]:
                print(f"  {BAD} {e}")
            for w in r["warnings"]:
                print(f"  {WARN} {w}")

    passing = sum(1 for r in results if r["ok"])
    failing = len(results) - passing
    print(f"\n{len(results)} records · {passing} passing · {failing} failing")

    return 0 if failing == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
