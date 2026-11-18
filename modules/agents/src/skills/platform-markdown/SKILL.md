---
name: platform-markdown
description: Format markdown for issue, pull request, merge request, review, and comment bodies in ticketing and VCS systems such as GitHub, GitLab, Linear, Azure DevOps, and Forgejo.
---

# Platform Markdown

These systems can render each newline as a line break.
A wrapped paragraph shows as a column of short lines.

## Formatting

- Write each paragraph, list item, and blockquote line on one line.
- Separate paragraphs, lists, headings, tables, and code blocks with a blank line.
- Keep code blocks as they are.

## Check

Before you publish a body, run:

```bash
<skill-dir>/scripts/check-body.sh <file>
```

It prints each wrapped line and exits 1.
Join each reported line onto the line before it.
