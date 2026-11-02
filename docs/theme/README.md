# Palette swatches

The SVG strips here render the palette table in
[theme.md](../theme.md#colors).
`generate-swatches.py` builds them from
`modules/theme-base/src/carbon-dark.yaml` and `carbon-light.yaml`.

After a palette change, regenerate the strips:

```bash
docs/theme/generate-swatches.py
```

The script replaces every SVG in this directory and prints the markdown
table.
If you add or remove a palette, paste the table into `theme.md`.
