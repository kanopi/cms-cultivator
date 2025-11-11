# Google Sheets Integration Setup

This guide will help you automatically sync Claude Code session data to Google Sheets.

## Overview

Once configured, the SessionEnd hook will:
1. Save session data to local CSV (`~/.claude/session-logs/sessions.csv`)
2. Automatically sync the data to your Google Sheet
3. Keep a running log of all sessions in the cloud

## Prerequisites

1. **Python 3** installed on your system
2. **pip** (Python package manager)
3. **Google Cloud account** (free tier works fine)

## Step 1: Install Required Python Packages

```bash
pip3 install gspread oauth2client
```

Or if you use a virtual environment:
```bash
python3 -m venv ~/.claude/venv
source ~/.claude/venv/bin/activate
pip install gspread oauth2client
```

## Step 2: Create Google Cloud Service Account

### 2.1 Create a Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use existing one)
3. Name it something like "Claude Code Logger"

### 2.2 Enable Google Sheets API

1. In your project, go to **APIs & Services** → **Library**
2. Search for "Google Sheets API"
3. Click **Enable**

### 2.3 Create Service Account

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **Service Account**
3. Name it "claude-code-logger" (or any name you prefer)
4. Click **Create and Continue**
5. Skip the optional steps (click **Continue** → **Done**)

### 2.4 Create Service Account Key

1. Click on the service account you just created
2. Go to the **Keys** tab
3. Click **Add Key** → **Create new key**
4. Choose **JSON** format
5. Click **Create**
6. Save the downloaded JSON file securely (e.g., `~/.claude/service-account-key.json`)

**Important:** This file contains credentials. Keep it private!

## Step 3: Create and Share Google Sheet

### 3.1 Create a New Google Sheet

1. Go to [Google Sheets](https://sheets.google.com/)
2. Create a new blank spreadsheet
3. Name it "Claude Code Sessions" (or any name you prefer)
4. Copy the URL from your browser

### 3.2 Share Sheet with Service Account

1. Click the **Share** button in your Google Sheet
2. In the service account JSON file, find the `client_email` field
   - It looks like: `claude-code-logger@your-project.iam.gserviceaccount.com`
3. Paste this email address in the "Share with people and groups" field
4. Give it **Editor** access
5. Uncheck "Notify people" (it's a bot, not a person)
6. Click **Share**

## Step 4: Configure the Integration

Run the setup script:

```bash
cd /Users/thejimbirch/Projects/cms-cultivator
python3 .claude/hooks/sync-to-google-sheets.py --setup
```

You'll be prompted for:

1. **Service account JSON file path**
   - Example: `~/.claude/service-account-key.json`

2. **Google Sheet URL**
   - Paste the URL from Step 3.1
   - Example: `https://docs.google.com/spreadsheets/d/1AbC...XyZ/edit`

3. **Worksheet name** (optional)
   - Default: `Sheet1`
   - This is the tab name within your spreadsheet

Configuration will be saved to: `~/.claude/google-sheets-config.json`

## Step 5: Test the Connection

```bash
python3 .claude/hooks/sync-to-google-sheets.py --test
```

You should see:
```
✅ Successfully connected to: Claude Code Sessions
   Worksheet: Sheet1
   Rows: 1000
   Columns: 26
```

## Step 6: Test with a Session

The hook will automatically sync on session end, but you can test manually:

```bash
python3 .claude/hooks/sync-to-google-sheets.py ~/.claude/session-logs/sessions.csv
```

Expected output:
```
✅ Synced 1 session to Google Sheets
```

Check your Google Sheet - you should see the session data!

## Usage

Once configured, the integration runs automatically:

1. End a Claude Code session (type `/clear` or close Claude Code)
2. Session data is saved to CSV
3. Data is automatically synced to Google Sheets
4. You'll see: `✅ Synced 1 session to Google Sheets`

## Management Commands

### Disable Sync (keep local CSV only)
```bash
python3 .claude/hooks/sync-to-google-sheets.py --disable
```

### Re-enable Sync
```bash
python3 .claude/hooks/sync-to-google-sheets.py --enable
```

### Manually Sync a CSV File
```bash
python3 .claude/hooks/sync-to-google-sheets.py path/to/file.csv
```

## Google Sheets Features

Once your data is in Google Sheets, you can:

### Create Dashboards

1. **Summary Stats**: Use formulas like `=SUM(N:N)` for total cost
2. **Charts**: Insert → Chart to visualize usage over time
3. **Pivot Tables**: Data → Pivot table to analyze by project
4. **Conditional Formatting**: Highlight high-cost sessions

### Example Formulas

**Total cost across all sessions:**
```
=SUM(N2:N)
```

**Average session duration (in minutes):**
```
=AVERAGE(F2:F)/60
```

**Most active project:**
```
=INDEX(C2:C, MODE(MATCH(C2:C, C2:C, 0)))
```

**Cost per project:**
```
=SUMIF(C:C, "cms-cultivator", N:N)
```

### Share with Team

1. Click **Share** in Google Sheets
2. Add team member emails
3. Set permission level (Viewer, Commenter, or Editor)
4. They can view usage across all team members' sessions

## Troubleshooting

### "Required packages not installed"

Install Python packages:
```bash
pip3 install gspread oauth2client
```

### "Configuration not found"

Run setup first:
```bash
python3 .claude/hooks/sync-to-google-sheets.py --setup
```

### "Connection failed: Permission denied"

1. Verify you shared the sheet with the service account email
2. Check the email in your JSON key file (`client_email` field)
3. Make sure you gave **Editor** access

### "Connection failed: Invalid credentials"

1. Download a fresh service account key from Google Cloud Console
2. Make sure the path in config points to the correct JSON file
3. Run setup again with the new key

### Hook Not Running

1. Verify hook is configured in `~/.claude/settings.json`
2. Check the script is executable: `chmod +x .claude/hooks/session-end-logger.sh`
3. Check the sync script exists: `ls -l .claude/hooks/sync-to-google-sheets.py`
4. Test manually: `echo '{"session_id":"test","transcript_path":"~/.claude/projects/..."}' | .claude/hooks/session-end-logger.sh`

### "python3: command not found"

Install Python 3:
- macOS: `brew install python3`
- Linux: `apt-get install python3` or `yum install python3`

## Security Considerations

### Protect Your Credentials

The service account key gives access to your Google Sheets:

1. **Never commit to git**: Add to `.gitignore`:
   ```
   ~/.claude/service-account-key.json
   ~/.claude/google-sheets-config.json
   ```

2. **Set proper permissions**:
   ```bash
   chmod 600 ~/.claude/service-account-key.json
   chmod 600 ~/.claude/google-sheets-config.json
   ```

3. **Rotate keys regularly**: Create new keys and delete old ones in Google Cloud Console

### Limit Service Account Access

1. Only share specific sheets with the service account
2. Don't give it access to your entire Google Drive
3. Use a dedicated Google Cloud project for this purpose

## Advanced Configuration

### Use Different Sheets for Different Projects

Edit `~/.claude/google-sheets-config.json` to use environment variables:

```json
{
  "credentials_path": "~/.claude/service-account-key.json",
  "sheet_id": "1AbC...XyZ",
  "worksheet_name": "Sheet1",
  "enabled": true
}
```

### Sync Multiple Machines

1. Set up the same service account on all machines
2. They'll all write to the same Google Sheet
3. Add a `machine_name` column to track which machine logged each session

### Backup Google Sheets Data

Google Sheets has built-in version history, but you can also:

1. **Export to CSV**: File → Download → CSV
2. **Scheduled exports**: Use Google Apps Script to auto-export
3. **Keep local CSV**: The hook always saves locally first

## Alternatives

If you don't want to use Google Sheets, consider:

1. **Airtable**: Similar API, great for databases
2. **Notion**: Use their API to sync to a Notion database
3. **PostgreSQL/MySQL**: Direct database integration
4. **S3/Cloud Storage**: Upload CSV to cloud storage
5. **Local only**: Just use the CSV file

## Additional Resources

- [gspread Documentation](https://docs.gspread.org/)
- [Google Sheets API Documentation](https://developers.google.com/sheets/api)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Service Account Guide](https://cloud.google.com/iam/docs/service-accounts)

## Need Help?

If you run into issues:

1. Check the error message carefully
2. Verify all steps were completed
3. Test the connection: `python3 .claude/hooks/sync-to-google-sheets.py --test`
4. Check file permissions and paths
5. Review the troubleshooting section above
