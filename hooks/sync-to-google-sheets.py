#!/usr/bin/env python3
"""
Sync Claude Code session data to Google Sheets
Requires: pip install gspread oauth2client
"""

import csv
import json
import os
import sys
from datetime import datetime
from pathlib import Path

# Configuration file path
CONFIG_FILE = Path.home() / ".claude" / "google-sheets-config.json"


def load_config():
    """Load Google Sheets configuration."""
    if not CONFIG_FILE.exists():
        print(f"❌ Configuration not found: {CONFIG_FILE}", file=sys.stderr)
        print("   Run setup: python3 .claude/hooks/sync-to-google-sheets.py --setup", file=sys.stderr)
        return None

    with open(CONFIG_FILE) as f:
        return json.load(f)


def setup_config():
    """Interactive setup for Google Sheets integration."""
    print("=== Google Sheets Integration Setup ===\n")
    print("This will configure the hook to sync session data to Google Sheets.\n")

    print("Prerequisites:")
    print("1. Install required packages: pip install gspread oauth2client")
    print("2. Create a Google Cloud project and enable Google Sheets API")
    print("3. Create service account credentials (JSON key file)")
    print("4. Share your Google Sheet with the service account email\n")

    print("Follow the guide: https://docs.gspread.org/en/latest/oauth2.html#for-bots-using-service-account\n")

    creds_path = input("Enter path to service account JSON file: ").strip()
    creds_path = os.path.expanduser(creds_path)

    if not os.path.exists(creds_path):
        print(f"❌ File not found: {creds_path}")
        sys.exit(1)

    sheet_url = input("Enter Google Sheet URL: ").strip()

    # Extract sheet ID from URL
    if "/d/" in sheet_url:
        sheet_id = sheet_url.split("/d/")[1].split("/")[0]
    else:
        sheet_id = sheet_url

    worksheet_name = input("Enter worksheet name (default: Sheet1): ").strip() or "Sheet1"

    config = {
        "credentials_path": creds_path,
        "sheet_id": sheet_id,
        "worksheet_name": worksheet_name,
        "enabled": True
    }

    # Save configuration
    CONFIG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)

    print(f"\n✅ Configuration saved to: {CONFIG_FILE}")
    print("\nTest the integration:")
    print("  python3 .claude/hooks/sync-to-google-sheets.py --test")


def sync_to_google_sheets(csv_path):
    """Sync CSV data to Google Sheets."""
    config = load_config()
    if not config or not config.get("enabled"):
        return False

    try:
        import gspread
        from oauth2client.service_account import ServiceAccountCredentials
    except ImportError:
        print("❌ Required packages not installed:", file=sys.stderr)
        print("   pip install gspread oauth2client", file=sys.stderr)
        return False

    try:
        # Authenticate with Google
        scope = [
            'https://spreadsheets.google.com/feeds',
            'https://www.googleapis.com/auth/drive'
        ]

        creds = ServiceAccountCredentials.from_json_keyfile_name(
            config["credentials_path"], scope
        )
        client = gspread.authorize(creds)

        # Open the sheet
        sheet = client.open_by_key(config["sheet_id"])
        worksheet = sheet.worksheet(config["worksheet_name"])

        # Read CSV file
        with open(csv_path, 'r') as f:
            reader = csv.reader(f)
            rows = list(reader)

        if not rows:
            return False

        # Check if sheet is empty or needs header
        existing_data = worksheet.get_all_values()

        if not existing_data:
            # Sheet is empty, add all data including header
            worksheet.update('A1', rows)
            print(f"✅ Synced {len(rows)-1} sessions to Google Sheets", file=sys.stderr)
        else:
            # Sheet has data, only append new rows
            # Get the last row from CSV (most recent session)
            new_row = rows[-1]

            # Append to the end of the sheet
            worksheet.append_row(new_row)
            print(f"✅ Synced 1 session to Google Sheets", file=sys.stderr)

        return True

    except Exception as e:
        print(f"❌ Google Sheets sync failed: {e}", file=sys.stderr)
        return False


def test_connection():
    """Test Google Sheets connection."""
    config = load_config()
    if not config:
        sys.exit(1)

    try:
        import gspread
        from oauth2client.service_account import ServiceAccountCredentials
    except ImportError:
        print("❌ Required packages not installed:")
        print("   pip install gspread oauth2client")
        sys.exit(1)

    print("Testing connection to Google Sheets...")

    try:
        scope = [
            'https://spreadsheets.google.com/feeds',
            'https://www.googleapis.com/auth/drive'
        ]

        creds = ServiceAccountCredentials.from_json_keyfile_name(
            config["credentials_path"], scope
        )
        client = gspread.authorize(creds)

        sheet = client.open_by_key(config["sheet_id"])
        worksheet = sheet.worksheet(config["worksheet_name"])

        print(f"✅ Successfully connected to: {sheet.title}")
        print(f"   Worksheet: {worksheet.title}")
        print(f"   Rows: {worksheet.row_count}")
        print(f"   Columns: {worksheet.col_count}")

    except Exception as e:
        print(f"❌ Connection failed: {e}")
        sys.exit(1)


def main():
    """Main entry point."""
    if len(sys.argv) > 1:
        if sys.argv[1] == "--setup":
            setup_config()
            sys.exit(0)
        elif sys.argv[1] == "--test":
            test_connection()
            sys.exit(0)
        elif sys.argv[1] == "--disable":
            config = load_config()
            if config:
                config["enabled"] = False
                with open(CONFIG_FILE, 'w') as f:
                    json.dump(config, f, indent=2)
                print("✅ Google Sheets sync disabled")
            sys.exit(0)
        elif sys.argv[1] == "--enable":
            config = load_config()
            if config:
                config["enabled"] = True
                with open(CONFIG_FILE, 'w') as f:
                    json.dump(config, f, indent=2)
                print("✅ Google Sheets sync enabled")
            sys.exit(0)
        else:
            # Assume it's a CSV file path
            csv_path = sys.argv[1]
            if os.path.exists(csv_path):
                success = sync_to_google_sheets(csv_path)
                sys.exit(0 if success else 1)

    print("Usage:")
    print("  python3 sync-to-google-sheets.py --setup     # Initial setup")
    print("  python3 sync-to-google-sheets.py --test      # Test connection")
    print("  python3 sync-to-google-sheets.py --enable    # Enable sync")
    print("  python3 sync-to-google-sheets.py --disable   # Disable sync")
    print("  python3 sync-to-google-sheets.py <csv_file>  # Sync CSV to Google Sheets")


if __name__ == "__main__":
    main()
