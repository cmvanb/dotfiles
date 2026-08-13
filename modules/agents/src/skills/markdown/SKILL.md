---
name: markdown
description: Apply style and formatting rules when writing markdown documents.
---

# Markdown Skill

## Formatting

- Always insert a blank line before:
    - Headings
    - Paragraphs
    - Lists
    - Code blocks
    - Diagrams
- Within a paragraph, break lines at clause/sentence boundaries.
- Wrap prose at 76 characters: break at the semantic boundary if it fits, otherwise at the nearest word boundary under 76.

## Line breaks

- A newline inside a paragraph renders as a space, so wrapping prose is safe.
- To force a visible line break, end the line with two trailing spaces.
- Stacked short lines that are not a list need forced breaks: metadata headers, key/value blocks, addresses.

## Callouts

- Use GitHub-style alerts for callouts.
- Syntax: a blockquote whose first line is `[!TYPE]`.
- Pick the type by intent:
    - `NOTE` for extra context
    - `TIP` for optional advice
    - `IMPORTANT` for information essential to success
    - `WARNING` for a likely problem
    - `CAUTION` for a risk of irreversible harm

```markdown
> [!NOTE]
> Supporting detail the reader should not skip.

> [!WARNING]
> A risk that needs the reader's attention before they proceed.
```

## Content

- Don't announce item counts.
- Don't add parentheticals after list items.
