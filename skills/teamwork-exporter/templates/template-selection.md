# Template Selection Logic

Decision algorithm for choosing the appropriate task template when exporting findings.

## Selection Algorithm

```python
def select_export_template(finding):
    # Security vulnerabilities and bugs → Bug Report
    if finding.type in ['security', 'vulnerability', 'bug', 'error']:
        return 'bug-report'

    # Completed work needing validation → QA Handoff
    if finding.type == 'completed' or 'needs testing' in finding.description:
        return 'qa-handoff'

    # Large refactors, architectural changes → Big Task
    if finding.effort == 'high' or finding.files_affected > 5:
        return 'big-task-epic'

    # Default: straightforward fixes → Little Task
    return 'little-task'
```

## Template Mapping by Finding Type

- **Security vulnerabilities, bugs** → Bug Report template
- **Performance improvements** → Little Task template
- **Major refactors, architectural changes** → Big Task/Epic template
- **Completed work needing validation** → QA Handoff template
- **Default** → Little Task template
