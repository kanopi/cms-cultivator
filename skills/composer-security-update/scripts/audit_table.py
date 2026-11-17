#!/usr/bin/env python3
"""Turn `composer audit --format=json` into a reviewable table.

Reads the audit JSON on stdin and, when a composer.lock path is supplied,
joins each advisory against the version actually installed. Composer's own
table output wraps badly in a terminal and drops the installed version, which
is the one column needed to decide whether an update is even possible.

Usage:
    ddev composer audit --format=json --locked | python3 audit_table.py composer.lock
    ddev composer audit --format=json --locked | python3 audit_table.py  # no versions

Options:
    --format markdown|tsv|packages   markdown (default) for the report,
                                     packages for a space-separated list to
                                     hand straight to `composer update`.

Exit status is always 0: a found advisory is the expected case here, not an
error, and a non-zero exit would abort a shell pipeline mid-workflow.
"""

import argparse
import json
import sys

SEVERITY_ORDER = {"critical": 0, "high": 1, "medium": 2, "low": 3, "": 4}


def load_installed(lock_path):
    """Map package name to installed version from a composer.lock."""
    if not lock_path:
        return {}
    try:
        with open(lock_path, encoding="utf-8") as handle:
            lock = json.load(handle)
    except (OSError, ValueError) as error:
        print(f"warning: could not read {lock_path}: {error}", file=sys.stderr)
        return {}
    installed = {}
    for section in ("packages", "packages-dev"):
        for package in lock.get(section) or []:
            installed[package["name"]] = package.get("version", "")
    return installed


def collect(audit, installed):
    rows = []
    for package, advisories in (audit.get("advisories") or {}).items():
        # Composer emits a list per package, or a dict keyed by advisory id
        # depending on version; normalise both to a list.
        if isinstance(advisories, dict):
            advisories = list(advisories.values())
        for advisory in advisories:
            rows.append(
                {
                    "package": package,
                    "installed": installed.get(package, "?"),
                    "severity": (advisory.get("severity") or "").lower(),
                    "cve": advisory.get("cve") or advisory.get("advisoryId") or "",
                    "affected": advisory.get("affectedVersions") or "",
                    "title": advisory.get("title") or "",
                    "link": advisory.get("link") or "",
                }
            )
    rows.sort(key=lambda row: (SEVERITY_ORDER.get(row["severity"], 4), row["package"]))
    return rows


def render_markdown(rows, abandoned):
    if not rows:
        print("No advisories reported for the locked dependencies.")
    else:
        print("| Package | Installed | Severity | CVE | Affected | Advisory |")
        print("| --- | --- | --- | --- | --- | --- |")
        for row in rows:
            title = row["title"].replace("|", "\\|")
            print(
                f"| {row['package']} | {row['installed']} | {row['severity'] or '-'} "
                f"| {row['cve'] or '-'} | `{row['affected']}` | {title} |"
            )
    if abandoned:
        print()
        print("Abandoned packages (not a vulnerability, but worth reporting):")
        for package, replacement in sorted(abandoned.items()):
            suffix = f" — use {replacement}" if replacement else ""
            print(f"- {package}{suffix}")


def render_tsv(rows):
    for row in rows:
        print(
            "\t".join(
                [
                    row["package"],
                    row["installed"],
                    row["severity"],
                    row["cve"],
                    row["affected"],
                    row["title"],
                ]
            )
        )


def render_packages(rows):
    seen = []
    for row in rows:
        if row["package"] not in seen:
            seen.append(row["package"])
    print(" ".join(seen))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lock", nargs="?", help="path to composer.lock")
    parser.add_argument(
        "--format", default="markdown", choices=("markdown", "tsv", "packages")
    )
    args = parser.parse_args()

    raw = sys.stdin.read().strip()
    if not raw:
        print("No audit JSON on stdin.", file=sys.stderr)
        return 0
    try:
        audit = json.loads(raw)
    except ValueError as error:
        print(f"Could not parse audit JSON: {error}", file=sys.stderr)
        print(raw[:500], file=sys.stderr)
        return 0

    rows = collect(audit, load_installed(args.lock))
    abandoned = audit.get("abandoned") or {}

    if args.format == "markdown":
        render_markdown(rows, abandoned)
    elif args.format == "tsv":
        render_tsv(rows)
    else:
        render_packages(rows)
    return 0


if __name__ == "__main__":
    sys.exit(main())
