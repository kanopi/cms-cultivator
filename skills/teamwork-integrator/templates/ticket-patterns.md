# Ticket Number Patterns

## Supported Formats

The skill recognizes these ticket number patterns:

- `PROJ-123` - Standard format (PROJECT-NUMBER)
- `SITE-456` - Any uppercase prefix + dash + number
- `ABC-789` - 2-4 letter prefix supported
- `#123` - Hash + number (less specific, ask for clarification)

## Pattern Matching Examples

**Automatically detected:**
```
"Check the status of SITE-456"
"I'm working on PROJ-123"
"What's in WEB-789?"
"Is BLOG-012 ready for QA?"
```

**Needs clarification:**
```
"Check ticket 123" → Ask: "Which project? (e.g., PROJ-123)"
"Status of #456" → Ask: "Which project prefix? (e.g., SITE-456)"
```
