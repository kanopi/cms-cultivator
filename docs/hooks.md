# Session Analytics Hook

CMS Cultivator includes an automatic **SessionEnd Hook** that tracks your Claude Code usage, providing valuable insights into your development workflow.

## Overview

The SessionEnd hook automatically runs when any Claude Code session ends, logging comprehensive statistics to help you:

- 📊 **Track Usage** - Monitor session duration, messages, and tool usage
- 💰 **Manage Costs** - Track token usage and estimated costs
- 🎯 **Improve Efficiency** - Identify patterns and optimize your workflow
- 👥 **Team Insights** - Share data with your team via Google Sheets

## Automatic Activation

✅ **No configuration needed!** The hook is automatically enabled when you install and enable the CMS Cultivator plugin.

## What It Tracks

Each session logs **21 data points** to a CSV file:

| Category | Data Points |
|----------|------------|
| **Session Info** | Timestamp, Session ID, Project name, Summary, End reason |
| **Duration** | Wall-clock time from start to end (seconds) |
| **Activity** | User messages, Assistant messages |
| **Tokens** | Input, Output, Cache read, Cache write, Total |
| **Cost** | Estimated cost (USD) based on Claude Sonnet 4.5 pricing |
| **Tools** | Tool calls count, API time, Average call time, Top 5 tools used |
| **Context** | Git branch, Claude Code version, Permission mode |

## Data Storage

### Local CSV File

All sessions are saved to: `~/.claude/session-logs/sessions.csv`

```csv
timestamp,session_id,project,summary,end_reason,duration_seconds,
user_messages,assistant_messages,input_tokens,output_tokens,
cache_read_tokens,cache_write_tokens,total_tokens,total_cost,
tool_calls,api_time_seconds,avg_call_time_ms,tools_used,
git_branch,claude_version,permission_mode
```

**Example row:**
```csv
2025-11-10 17:23:55,fc155d6e-e6bd,cms-cultivator,"Feature Implementation",clear,1326,39,51,188,16028,2326714,172314,2515244,1.5850,30,31,1043,"Bash:10; WebFetch:8; TodoWrite:6; Read:4",main,2.0.36,default
```

## Viewing Your Data

### In Terminal

```bash
# View all sessions
cat ~/.claude/session-logs/sessions.csv

# View with formatting
column -t -s, ~/.claude/session-logs/sessions.csv | less -S

# Calculate total cost
awk -F, 'NR>1 {sum+=$14} END {print "Total: $"sum}' ~/.claude/session-logs/sessions.csv

# Filter by project
grep "cms-cultivator" ~/.claude/session-logs/sessions.csv
```

### In Spreadsheet

Import the CSV into:
- **Excel**: File → Open → Select `sessions.csv`
- **Google Sheets**: File → Import → Upload file
- **Numbers**: File → Open → Select `sessions.csv`

### With Python/pandas

```python
import pandas as pd

# Load data
df = pd.read_csv('~/.claude/session-logs/sessions.csv')

# Total cost across all sessions
print(f"Total cost: ${df['total_cost'].sum():.2f}")

# Average session duration (minutes)
print(f"Avg duration: {df['duration_seconds'].mean() / 60:.1f} min")

# Cost by project
print(df.groupby('project')['total_cost'].sum())

# Most used tools
from collections import Counter
all_tools = []
for tools in df['tools_used'].dropna():
    all_tools.extend([t.split(':')[0] for t in tools.split('; ')])
print(Counter(all_tools).most_common(10))
```

## Google Sheets Integration (Optional)

### Why Use Google Sheets?

- ☁️ **Cloud backup** - Your data is safe in the cloud
- 👥 **Team sharing** - Share insights with your team
- 📊 **Easy visualization** - Built-in charts and pivot tables
- 📱 **Access anywhere** - View on any device
- 🔄 **Real-time sync** - Data updates automatically

### Setup Guide

**Complete setup instructions:** [`hooks/session-end-logger/README.md`](https://github.com/kanopi/cms-cultivator/blob/main/hooks/session-end-logger/README.md)

**Quick start:**

1. **Install requirements:**
   ```bash
   pip3 install gspread oauth2client
   ```

2. **Configure:**
   ```bash
   python3 ~/.config/claude/plugins/cms-cultivator/hooks/session-end-logger/sync-to-google-sheets.py --setup
   ```

3. **Test connection:**
   ```bash
   python3 ~/.config/claude/plugins/cms-cultivator/hooks/session-end-logger/sync-to-google-sheets.py --test
   ```

Once configured, every session automatically syncs to your Google Sheet!

### Google Sheets Features

Create powerful dashboards with:

- **Summary stats**: `=SUM(N:N)` for total cost
- **Charts**: Insert → Chart to visualize trends
- **Pivot tables**: Analyze by project, date, or user
- **Conditional formatting**: Highlight high-cost sessions
- **Team visibility**: Share the sheet with your team

## Use Cases

### 1. Cost Management

Track Claude Code costs across projects:

```bash
# Total cost this month
awk -F, 'NR>1 && $1 ~ /2025-11/ {sum+=$14} END {print "November: $"sum}' \
  ~/.claude/session-logs/sessions.csv

# Cost by project
awk -F, 'NR>1 {cost[$3]+=$14} END {for(p in cost) print p": $"cost[p]}' \
  ~/.claude/session-logs/sessions.csv
```

### 2. Efficiency Analysis

Identify patterns to optimize workflow:

```python
import pandas as pd

df = pd.read_csv('~/.claude/session-logs/sessions.csv')

# Average tokens per message
df['tokens_per_message'] = df['total_tokens'] / (df['user_messages'] + df['assistant_messages'])
print(f"Avg tokens/message: {df['tokens_per_message'].mean():.0f}")

# Most efficient sessions (least cost per message)
df['cost_per_message'] = df['total_cost'] / (df['user_messages'] + df['assistant_messages'])
print("\nMost efficient sessions:")
print(df.nsmallest(5, 'cost_per_message')[['project', 'summary', 'cost_per_message']])
```

### 3. Tool Usage Analysis

See which commands and tools you use most:

```python
from collections import Counter

# Parse tools_used column
all_tools = []
for tools_str in df['tools_used'].dropna():
    for tool in tools_str.split('; '):
        tool_name = tool.split(':')[0]
        count = int(tool.split(':')[1])
        all_tools.extend([tool_name] * count)

# Top 10 tools
print("Top 10 tools:")
for tool, count in Counter(all_tools).most_common(10):
    print(f"  {tool}: {count}")
```

### 4. Team Insights

With Google Sheets integration, track team-wide usage:

- Which projects consume the most resources?
- Who are the most active Claude Code users?
- What time of day has highest usage?
- Which tools does the team prefer?

## Console Output

When a session ends, you'll see:

```
📊 Session logged to: /Users/username/.claude/session-logs/sessions.csv
   Duration: 1326s | Messages: 90 | Tokens: 16216 | Cost: $1.5850
```

With Google Sheets enabled:
```
📊 Session logged to: /Users/username/.claude/session-logs/sessions.csv
   Duration: 1326s | Messages: 90 | Tokens: 16216 | Cost: $1.5850
✅ Synced 1 session to Google Sheets
```

## Privacy & Security

### What's Logged

- ✅ Session metadata (timestamps, IDs)
- ✅ Usage statistics (tokens, costs, tools)
- ✅ Session summary (from first transcript entry)
- ❌ **Not logged:** Actual conversation content, code snippets, or sensitive data

### Data Location

- **Local CSV**: `~/.claude/session-logs/sessions.csv` (your machine only)
- **Google Sheets**: Only if you explicitly configure it

### Security Best Practices

If using Google Sheets:

1. **Protect credentials**: Keep service account keys private
2. **Set permissions**: Only share sheets with trusted team members
3. **Use dedicated account**: Create a service account specifically for this purpose
4. **Rotate keys**: Regularly update service account keys

## Disabling the Hook

The hook is part of the plugin and runs automatically. To disable:

**Option 1: Disable Google Sheets sync only**
```bash
python3 ~/.config/claude/plugins/cms-cultivator/hooks/session-end-logger/sync-to-google-sheets.py --disable
```

**Option 2: Disable the entire plugin**
```bash
claude plugins disable cms-cultivator
```

## Troubleshooting

### No CSV file created

- Check the plugin is enabled: `claude plugins list`
- Verify hook permissions: `ls -l ~/.config/claude/plugins/cms-cultivator/hooks/`
- Look for errors in: `~/.claude/debug/`

### Google Sheets sync not working

```bash
# Test connection
python3 ~/.config/claude/plugins/cms-cultivator/hooks/session-end-logger/sync-to-google-sheets.py --test

# Re-run setup
python3 ~/.config/claude/plugins/cms-cultivator/hooks/session-end-logger/sync-to-google-sheets.py --setup
```

### jq command not found

The hook requires `jq` for JSON parsing:

```bash
# macOS
brew install jq

# Linux (Ubuntu/Debian)
apt-get install jq
```

## Technical Details

### Hook Configuration

Defined in `hooks/hooks.json`:

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

### Cost Calculation

Based on Claude Sonnet 4.5 pricing (January 2025):

- Input tokens: $3.00 per million
- Output tokens: $15.00 per million
- Cache write: $3.75 per million
- Cache read: $0.30 per million

**Note:** Prices subject to change. Update in the hook script if needed.

### Environment Variables

- `CLAUDE_PLUGIN_ROOT`: Plugin installation directory
- `CLAUDE_PROJECT_DIR`: Current project directory

## Additional Resources

- [Hook README](https://github.com/kanopi/cms-cultivator/blob/main/hooks/session-end-logger/README.md)
- [Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks)

## Questions or Issues?

- Check the [troubleshooting section](#troubleshooting)
- Review [hooks/session-end-logger/README.md](https://github.com/kanopi/cms-cultivator/blob/main/hooks/session-end-logger/README.md)
- Open an issue on [GitHub](https://github.com/kanopi/cms-cultivator/issues)
