#!/usr/bin/env python3

import csv
import subprocess
import sys
from pathlib import Path

CSV_PATH = Path("~/repo/template_repo/box_relocation/box_relocation_files.csv").expanduser()
BASH_SCRIPT = Path("~/repo/template_repo/box_relocation/symlink_executor_bash.sh").expanduser()

if not CSV_PATH.is_file():
    print(f"ERROR: CSV file does not exist: {CSV_PATH}", file=sys.stderr)
    sys.exit(1)

if not BASH_SCRIPT.is_file():
    print(f"ERROR: Bash script does not exist: {BASH_SCRIPT}", file=sys.stderr)
    sys.exit(1)

with CSV_PATH.open(newline="") as f:
    reader = csv.DictReader(f)

    required_columns = {"local_file", "box_file"}
    if not required_columns.issubset(reader.fieldnames or []):
        print(
            f"ERROR: CSV must contain columns: {', '.join(sorted(required_columns))}",
            file=sys.stderr,
        )
        print(f"Found columns: {reader.fieldnames}", file=sys.stderr)
        sys.exit(1)

    for row_num, row in enumerate(reader, start=2):
        local_file = row["local_file"].strip()
        box_file = row["box_file"].strip()

        if not local_file or not box_file:
            print(f"SKIP row {row_num}: missing local_file or box_file")
            continue

        print(f"\nRow {row_num}:")
        print(f"  Local: {local_file}")
        print(f"  Box:   {box_file}")

        try:
            subprocess.run(
                [str(BASH_SCRIPT), local_file, box_file],
                check=True,
            )
        except subprocess.CalledProcessError:
            print(f"SKIP row {row_num}: no matching local file found, skipping.")
            continue

print("\nDone.")