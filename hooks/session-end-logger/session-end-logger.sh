#!/bin/bash

# SessionEnd Hook - Log session statistics and usage metrics to CSV
# This hook parses the transcript file and extracts comprehensive session data

# Read JSON input from stdin
input=$(cat)

# Extract fields from JSON input
session_id=$(echo "$input" | jq -r '.session_id')
transcript_path=$(echo "$input" | jq -r '.transcript_path')
reason=$(echo "$input" | jq -r '.reason')
cwd=$(echo "$input" | jq -r '.cwd')
permission_mode=$(echo "$input" | jq -r '.permission_mode')

# Expand tilde in transcript path
transcript_path="${transcript_path/#\~/$HOME}"

# CSV file location
log_dir="$HOME/.claude/session-logs"
mkdir -p "$log_dir"
csv_file="$log_dir/sessions.csv"

# Check if transcript exists
if [ ! -f "$transcript_path" ]; then
    echo "ERROR: Transcript file not found at $transcript_path" >&2
    exit 0
fi

# Parse transcript file and extract data
summary=$(head -n 1 "$transcript_path" | jq -r '.summary // "No summary"' | sed 's/,/ /g' | sed 's/"//g')
end_datetime=$(date '+%Y-%m-%d %H:%M:%S')

# Get timestamps for duration calculation
first_timestamp=$(jq -r 'select(.timestamp != null) | .timestamp' "$transcript_path" | head -n 1)
last_timestamp=$(jq -r 'select(.timestamp != null) | .timestamp' "$transcript_path" | tail -n 1)

duration_seconds=0
if [ -n "$first_timestamp" ] && [ -n "$last_timestamp" ]; then
    start_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${first_timestamp:0:19}" +%s 2>/dev/null)
    end_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "${last_timestamp:0:19}" +%s 2>/dev/null)
    if [ -n "$start_epoch" ] && [ -n "$end_epoch" ]; then
        duration_seconds=$((end_epoch - start_epoch))
    fi
fi

# Count messages
user_messages=$(jq -s '[.[] | select(.type == "user" and .message.role == "user")] | length' "$transcript_path")
assistant_messages=$(jq -s '[.[] | select(.type == "assistant")] | length' "$transcript_path")

# Calculate token usage
input_tokens=$(jq -s '[.[] | select(.message.usage != null) | .message.usage.input_tokens] | add // 0' "$transcript_path")
output_tokens=$(jq -s '[.[] | select(.message.usage != null) | .message.usage.output_tokens] | add // 0' "$transcript_path")
cache_read=$(jq -s '[.[] | select(.message.usage != null) | .message.usage.cache_read_input_tokens] | add // 0' "$transcript_path")
cache_write=$(jq -s '[.[] | select(.message.usage != null) | .message.usage.cache_creation_input_tokens] | add // 0' "$transcript_path")
total_tokens=$((input_tokens + output_tokens + cache_read + cache_write))

# Calculate cost (Claude Sonnet 4.5 pricing)
input_cost=$(echo "scale=4; $input_tokens * 3 / 1000000" | bc)
output_cost=$(echo "scale=4; $output_tokens * 15 / 1000000" | bc)
cache_read_cost=$(echo "scale=4; $cache_read * 0.30 / 1000000" | bc)
cache_write_cost=$(echo "scale=4; $cache_write * 3.75 / 1000000" | bc)
total_cost=$(echo "scale=4; $input_cost + $output_cost + $cache_read_cost + $cache_write_cost" | bc)

# Tool usage - get top 5 tools as comma-separated list
tool_list=$(jq -s '[.[] | select(.message.content != null and (.message.content | type == "array")) | .message.content[] | select(.type == "tool_use") | .name] | group_by(.) | map({tool: .[0], count: length}) | sort_by(-.count) | .[0:5] | map("\(.tool):\(.count)") | join("; ")' "$transcript_path" | sed 's/"//g')

# API timing statistics
total_api_time=$(jq -s '[.[] | select(.toolUseResult != null and (.toolUseResult | type == "object") and .toolUseResult.durationMs != null) | .toolUseResult.durationMs] | add // 0' "$transcript_path")
tool_call_count=$(jq -s '[.[] | select(.toolUseResult != null and (.toolUseResult | type == "object"))] | length' "$transcript_path")
avg_api_time=0
if [ $tool_call_count -gt 0 ]; then
    avg_api_time=$((total_api_time / tool_call_count))
fi
api_time_seconds=$((total_api_time / 1000))

# Git context
git_branch=$(jq -r 'select(.gitBranch != null) | .gitBranch' "$transcript_path" | head -n 1)
version=$(jq -r 'select(.version != null) | .version' "$transcript_path" | head -n 1)

# Project name from working directory
project_name=$(basename "$cwd")

# Create CSV header if file doesn't exist
if [ ! -f "$csv_file" ]; then
    echo "timestamp,session_id,project,summary,end_reason,duration_seconds,user_messages,assistant_messages,input_tokens,output_tokens,cache_read_tokens,cache_write_tokens,total_tokens,total_cost,tool_calls,api_time_seconds,avg_call_time_ms,tools_used,git_branch,claude_version,permission_mode" > "$csv_file"
fi

# Append session data as CSV row
echo "$end_datetime,$session_id,$project_name,\"$summary\",$reason,$duration_seconds,$user_messages,$assistant_messages,$input_tokens,$output_tokens,$cache_read,$cache_write,$total_tokens,$total_cost,$tool_call_count,$api_time_seconds,$avg_api_time,\"$tool_list\",$git_branch,$version,$permission_mode" >> "$csv_file"

# Sync to Google Sheets (if configured)
# Use CLAUDE_PLUGIN_ROOT if available (when called from plugin), otherwise fall back to CLAUDE_PROJECT_DIR
if [ -n "$CLAUDE_PLUGIN_ROOT" ]; then
    sync_script="$CLAUDE_PLUGIN_ROOT/hooks/session-end-logger/sync-to-google-sheets.py"
else
    sync_script="$CLAUDE_PROJECT_DIR/.claude/hooks/session-end-logger/sync-to-google-sheets.py"
fi

if [ -f "$sync_script" ]; then
    python3 "$sync_script" "$csv_file" 2>&1 | grep -E "^(✅|❌)" >&2 || true
fi

# Output summary to stderr so it's visible in Claude Code
{
    echo ""
    echo "📊 Session logged to: $csv_file"
    echo "   Duration: ${duration_seconds}s | Messages: $((user_messages + assistant_messages)) | Tokens: $((input_tokens + output_tokens)) | Cost: \$$total_cost"
    echo ""
} >&2

exit 0
