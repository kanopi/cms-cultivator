# Posted review format

Used whenever a review is posted to GitHub: step 6 posting and delegated mode. Self-reviews
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
