# Posted review format

Used whenever a review is posted to the PR host: step 6 posting and delegated mode. Self-reviews
never use it.

## Body

```markdown
## AI Code Review

**Recommendation**
- [ ] Approve
- [x] Request Changes
- [ ] Comment

<verdict line>

### Changes Requested
<Critical and Important findings>

### Suggestions
<Minor findings>

Unverified: <line, when present>
```

## Rules

- Check exactly one Recommendation box; in delegated mode it must match the
  `FINAL_RECOMMENDATION` sentinel. Both come from the one recommendation.
- The GitHub review `event` is always `COMMENT` unless the user explicitly asked otherwise.
  Reviews post as whoever ran the skill, often an automated routine, and an approve or
  request-changes event from that account gates the PR on that person re-reviewing. The
  checkbox, not the event, carries the recommendation.
- Critical and Important findings go under `### Changes Requested`. Minor findings go under
  `### Suggestions`. Omit an empty section; never print an empty heading.
- A finding anchored to a line in the diff posts as an inline comment carrying its full
  template and ```suggestion``` block. In the body, list it as one line: the bold headline
  plus its `File:` value. The body stays scannable when every finding is anchored.
- A finding with no anchor in the diff appears in full in the body under its section.
- A `No issues found` review posts the title, the recommendation, the verdict line, and the
  coverage line. No sections.
- Transcribe findings without rewording. The wrapper adds structure, never new sentences.

## Posting by host

Check the host with `git remote get-url origin`; never assume GitHub.

- **GitHub:** one `gh api repos/{owner}/{repo}/pulls/<n>/reviews` call with
  `event: COMMENT`, `body`, and a `comments` array of `{path, line, body}`.
- **GitLab:** GitLab has no single review call and no review event, so the Recommendation
  checkbox alone carries the verdict. Post the body as one note, then each anchored
  finding as a diff discussion positioned with the MR's `diff_refs`:

  ```bash
  glab mr note <n> --message "$(cat "$BODY_FILE")"
  REFS=$(glab mr view <n> -F json | jq -c .diff_refs)
  glab api --method POST "projects/:id/merge_requests/<n>/discussions" \
    -f body="$(cat "$FINDING_FILE")" \
    -f "position[position_type]=text" \
    -f "position[base_sha]=$(jq -r .base_sha <<<"$REFS")" \
    -f "position[start_sha]=$(jq -r .start_sha <<<"$REFS")" \
    -f "position[head_sha]=$(jq -r .head_sha <<<"$REFS")" \
    -f "position[new_path]=<path>" -f "position[new_line]=<line>"
  ```

  Write each body to a file with a quoted heredoc first. A discussion GitLab rejects
  (the line is outside the diff) moves into the body note instead; never drop it.
- **Bitbucket and other hosts:** no CLI to post with. Hand the user the body, with every
  finding in full, as one fenced block to paste as a PR comment.
