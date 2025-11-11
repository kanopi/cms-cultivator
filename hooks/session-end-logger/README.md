# Claude Code Hooks

This directory contains hook scripts that extend Claude Code functionality as part of the CMS Cultivator plugin.

## SessionEnd Logger Hook

**File:** `session-end-logger.sh`
**Configuration:** `hooks.json`

Automatically logs comprehensive session statistics to a CSV file when a Claude Code session ends.

### ✅ Automatic Activation

This hook is **automatically activated** when you enable the CMS Cultivator plugin. No additional configuration needed!

### What It Tracks

The hook analyzes the session transcript and logs 21 fields per session:

- **Session metadata**: Timestamp, session ID, project name, summary, end reason
- **Duration**: Wall-clock time from session start to end (in seconds)
- **Message counts**: User messages vs assistant messages
- **Token usage**: Input, output, cache read, and cache write tokens
- **Cost estimation**: Calculated cost based on Claude Sonnet 4.5 pricing
- **Tool usage**: Top 5 tools used with counts (e.g., "Bash:10; WebFetch:8")
- **API timing**: Total API time, tool call count, and average call time
- **Git context**: Current branch
- **Environment**: Claude Code version, permission mode

### Output Format

Data is appended to: `~/.claude/session-logs/sessions.csv`

**CSV Columns:**
```
timestamp, session_id, project, summary, end_reason, duration_seconds,
user_messages, assistant_messages, input_tokens, output_tokens,
cache_read_tokens, cache_write_tokens, total_tokens, total_cost,
tool_calls, api_time_seconds, avg_call_time_ms, tools_used,
git_branch, claude_version, permission_mode
```

This format is perfect for:
- Importing into Excel, Google Sheets, or data analysis tools
- Creating dashboards and visualizations
- Tracking usage trends over time
- Analyzing costs and efficiency patterns

### 🔄 Google Sheets Integration (Optional)

**Automatically sync your session data to Google Sheets!**

The hook can automatically upload each session to a Google Sheet, giving you:
- ✅ Real-time cloud backup of your session data
- ✅ Easy sharing with team members
- ✅ Built-in charting and pivot tables
- ✅ Access from any device

#### Prerequisites

1. Python 3 installed on your system
2. pip (Python package manager)
3. Google Cloud account (free tier works fine)

#### Setup Steps

**1. Install Required Python Packages**

```bash
pip3 install gspread oauth2client
```

**2. Create Google Cloud Service Account**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use existing)
3. Go to **APIs & Services** → **Library** → Search "Google Sheets API" → **Enable**
4. Go to **APIs & Services** → **Credentials** → **Create Credentials** → **Service Account**
5. Name it "claude-code-logger" → **Create and Continue** → **Done**
6. Click on the service account → **Keys** tab → **Add Key** → **Create new key** → **JSON** → **Create**
7. Save the downloaded JSON file (e.g., `~/.claude/service-account-key.json`)

**Important:** Keep this credentials file private!

**3. Create and Share Google Sheet**

1. Go to [Google Sheets](https://sheets.google.com/) and create a new blank spreadsheet
2. Name it "Claude Code Sessions"
3. Click **Share** button
4. In the service account JSON file, find the `client_email` field
5. Paste that email in the share dialog and give it **Editor** access
6. Uncheck "Notify people" → Click **Share**

**4. Configure the Integration**

Run the interactive setup:

```bash
python3 hooks/session-end-logger/sync-to-google-sheets.py --setup
```

You'll be prompted for:
- Service account JSON file path (e.g., `~/.claude/service-account-key.json`)
- Google Sheet URL
- Worksheet name (default: `Sheet1`)

**5. Test the Connection**

```bash
python3 hooks/session-end-logger/sync-to-google-sheets.py --test
```

You should see: `✅ Successfully connected to: Claude Code Sessions`

Once configured, data syncs automatically after each session!

### How It Works

The hook is defined in `hooks/hooks.json` within the plugin:

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-end-logger.sh",
            "description": "Log session statistics to CSV and optionally sync to Google Sheets"
          }
        ]
      }
    ]
  }
}
```

When you enable the CMS Cultivator plugin, this hook is automatically registered and runs at the end of every Claude Code session.

### Manual Installation (Without Plugin)

If you want to use this hook separately from the plugin:

1. **Copy hook files to your project:**
   ```bash
   mkdir -p .claude/hooks
   cp hooks/session-end-logger.sh .claude/hooks/
   cp hooks/sync-to-google-sheets.py .claude/hooks/
   chmod +x .claude/hooks/session-end-logger.sh .claude/hooks/sync-to-google-sheets.py
   ```

2. **Add to `~/.claude/settings.json`:**
   ```json
   {
     "hooks": {
       "SessionEnd": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-logger.sh"
             }
           ]
         }
       ]
     }
   }
   ```

3. **Restart Claude Code**

### Example Output

**Console output when session ends:**
```
📊 Session logged to: /Users/username/.claude/session-logs/sessions.csv
   Duration: 1326s | Messages: 90 | Tokens: 16216 | Cost: $1.5850
```

**CSV data (sample row):**
```csv
2025-11-10 17:23:55,fc155d6e-e6bd-44e0-ba2b-4010cbab5f87,cms-cultivator,"Feature Implementation",clear,1326,39,51,188,16028,2326714,172314,2515244,1.5850,30,31,1043,"Bash:10; WebFetch:8; TodoWrite:6; Read:4; Edit:3",main,2.0.36,default
```

### Viewing and Analyzing Data

**View in terminal:**
```bash
# View entire CSV
cat ~/.claude/session-logs/sessions.csv

# View with column formatting
column -t -s, ~/.claude/session-logs/sessions.csv | less -S

# Show only specific columns (e.g., timestamp, project, cost)
cut -d, -f1,3,14 ~/.claude/session-logs/sessions.csv

# Filter by project
grep "cms-cultivator" ~/.claude/session-logs/sessions.csv

# Calculate total cost
awk -F, 'NR>1 {sum+=$14} END {print "Total: $"sum}' ~/.claude/session-logs/sessions.csv
```

**Import into spreadsheet:**
- Excel: File → Open → Select `sessions.csv`
- Google Sheets: File → Import → Upload file
- Numbers: File → Open → Select `sessions.csv`

**Analyze with Python/pandas:**
```python
import pandas as pd

# Load CSV
df = pd.read_csv('~/.claude/session-logs/sessions.csv')

# Calculate total cost
print(f"Total cost: ${df['total_cost'].sum():.2f}")

# Average session duration
print(f"Avg duration: {df['duration_seconds'].mean() / 60:.1f} minutes")

# Most used tools
print(df['tools_used'].value_counts().head())

# Cost by project
print(df.groupby('project')['total_cost'].sum())
```

### Cost Tracking

The hook calculates estimated costs based on Claude Sonnet 4.5 pricing (as of January 2025):

- Input tokens: $3.00 per million tokens
- Output tokens: $15.00 per million tokens
- Cache write: $3.75 per million tokens
- Cache read: $0.30 per million tokens

**Note:** If you're using a different model, update the pricing in the script at lines 109-113.

### Troubleshooting

**Hook not running?**
- Check that `~/.claude/settings.json` has the correct configuration
- Verify the script is executable: `ls -l .claude/hooks/session-end-logger.sh`
- Check for errors in `~/.claude/debug/` directory

**Missing jq?**
The script requires `jq` for JSON parsing. Install it:
```bash
# macOS
brew install jq

# Linux (Ubuntu/Debian)
apt-get install jq
```

**Permission errors?**
Ensure the log directory exists and is writable:
```bash
mkdir -p ~/.claude/session-logs
chmod 755 ~/.claude/session-logs
```

### Customization

You can modify the script to:
- Change the log file location (line 23)
- Add custom metrics or calculations
- Format output differently
- Send data to external logging services
- Trigger notifications for long sessions or high costs

### Session End Reasons

The `reason` field indicates why the session ended:

- `clear` - User ran `/clear` command
- `logout` - User logged out
- `prompt_input_exit` - User exited during a prompt
- `other` - Other exit scenarios

### Additional Information

For more about Claude Code hooks, see:
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Hooks Reference](https://code.claude.com/docs/en/hooks.md)
