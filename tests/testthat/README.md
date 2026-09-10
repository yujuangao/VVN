# vvnthemes Test Report — Hurricane Project

**Date:** 2026-09-10
**Package:** vvnthemes v0.0.1
**Context:** Hurricane Helene satellite data story (VVN Insights)
**R version:** 4.4.x

## Summary

| Metric | Value |
|--------|-------|
| Tests run | 20 |
| Passed | 20 |
| Failed | 0 |
| Pass rate | 100% |

## Test Results

| # | Test | Status | Notes |
|---|------|--------|-------|
| 1 | Package loads | PASS | v 0.0.1 |
| 2 | `set_vvn_defaults()` / `undo_vvn_defaults()` | PASS | Global theme set and reverted |
| 3 | `theme_vvn()` | PASS | Output: `03_theme_vvn.png` |
| 4 | `theme_vvn_map()` | PASS | Output: `04_theme_vvn_map.png` |
| 5 | `theme_vvn(grid = ...)` variants | PASS | Tested y, x, both, none |
| 6 | `vvn_colors()` | PASS | maroon=#861F41, orange=#E5751F, navy=#1B5299 |
| 7 | Categorical palettes | PASS | 10 palettes (vt, vt_secondary, brand, main, accessible, wcag, monet, sunflower, academic, natural) |
| 8 | Sequential/diverging palettes | PASS | 6 palettes (maroon_seq, orange_seq, navy_seq, gray_seq, hokie_stone_seq, diverging) |
| 9 | `view_vvn_palette()` | PASS | Output: `09_palette_vt.png`, `09_palette_maroon_seq.png` |
| 10 | `scale_fill_vvn()` — bar chart | PASS | Hurricane NDVI bar chart: `10_bar_hurricane.png` |
| 11 | `scale_color_vvn()` — line chart | PASS | Satellite observations line chart: `11_line_hurricane.png` |
| 12 | `scale_fill_vvn_c()` — continuous heatmap | PASS | NDVI difference heatmap: `12_heatmap_ndvi.png` |
| 13 | Plot utilities (scatter_grid, legend_bottom, remove_ticks, remove_axis, remove_legend) | PASS | Output: `13_utils.png` |
| 14 | `vvn_note()` | PASS | Caption annotation added |
| 15 | `vvn_save()` — multi-format export | PASS | PNG + PDF: `15_save_test.png`, `15_save_test.pdf` |
| 16 | `vvn_table()` — GT table | PASS | Sensor comparison table: `16_table.png` |
| 17 | `vvn_accessibility_check()` | PASS | WCAG AA check on VT palette (3/6 pass 4.5:1 threshold) |
| 18 | Alias functions | PASS | 7 aliases confirmed (vvn_remove_ticks, vvn_remove_axis, vvn_remove_legend, vvn_legend_bottom, vvn_scatter_grid, scale_colour_vvn, scale_colour_vvn_c) |
| 19 | Composite hurricane chart | PASS | Full workflow with `set_vvn_defaults()`: `19_composite_hurricane.png` |
| 20 | Hurricane assets check | PASS | 3/3 interactive maps found in `../assets/` |

## Output Files

All generated in `tests/testthat/outputs/`:

| File | Description |
|------|-------------|
| `03_theme_vvn.png` | Basic scatter plot with `theme_vvn()` |
| `04_theme_vvn_map.png` | Scatter plot with `theme_vvn_map()` (no axes) |
| `09_palette_vt.png` | VT brand palette swatch |
| `09_palette_maroon_seq.png` | Maroon sequential palette swatch |
| `10_bar_hurricane.png` | NDVI pre/post storm grouped bar chart |
| `11_line_hurricane.png` | Monthly satellite observations line chart |
| `12_heatmap_ndvi.png` | NDVI difference heatmap (diverging scale) |
| `13_utils.png` | Plot utilities demo (removed axes/ticks/legend) |
| `15_save_test.png` | Multi-format export test (PNG) |
| `15_save_test.pdf` | Multi-format export test (PDF) |
| `16_table.png` | GT table with VVN styling (sensor comparison) |
| `19_composite_hurricane.png` | Full hurricane scene count chart (4 groups) |

## Hurricane Assets Verified

Interactive maps in `VVN Insights/Hurricane/assets/`:

- `01_treatment_counterfactual_map.html` — Treatment & counterfactual site locations
- `02_greenness_map.html` — Sentinel-2 NDVI canopy greenness change
- `03_helene_track.html` — Hurricane Helene storm track with Saffir-Simpson markers

## Functions Tested

### Themes (3)
`theme_vvn()`, `theme_vvn_map()`, `theme_vvn(grid=...)`

### Color System (4)
`vvn_colors()`, `vvn_palette()`, `view_vvn_palette()`, `vvn_accessibility_check()`

### Scales (4)
`scale_fill_vvn()`, `scale_color_vvn()`, `scale_fill_vvn_c()`, `scale_colour_vvn()` (alias)

### Chart Helpers (7)
`vvn_title()`, `vvn_source()`, `vvn_note()`, `remove_ticks()`, `remove_axis()`, `scatter_grid()`, `legend_bottom()`

### Other (4)
`set_vvn_defaults()`, `undo_vvn_defaults()`, `vvn_save()`, `vvn_table()`

## VVN Story Test (`create_vvn_story`)

Generated a complete VVN Insights data story using hurricane data in `hurricane_helene_test/`:

| Test | Status |
|------|--------|
| `create_vvn_story()` scaffold | PASS — project created with index.qmd, styles.scss, _quarto.yml, scripts/analysis.R, **assets/** |
| `subtitle` parameter injection | PASS — `VVN_SUBTITLE` replaced in index.qmd |
| `scripts/analysis.R` — 1 static figure | PASS — `figures/01_ndvi_comparison.png` |
| Interactive maps via `.map-card` iframe | PASS — 2 maps from `assets/` (storm track + treatment sites) |
| Static figure via `knitr::include_graphics()` | PASS — NDVI bar chart rendered inline |
| VVN CSS classes in output | PASS — 43 `.vvn-*` class references (header, rubric, tag, stats-row, finding-statement, map-card, map-caption, vvn-source, about-research, byline, subtitle) |
| `quarto render index.qmd` | PASS — self-contained HTML (5.6 MB) |

**Output:** `hurricane_helene_test/hurricane_helene_story.html` — matches VVN Insights demo format (Pew-style).

### Template Structure (matches pew demo)

```
.vvn-header → .vvn-rubric → .vvn-topics/.vvn-tag → title → .vvn-subtitle → .vvn-byline
↓
.vvn-stats-row → .vvn-stat (big gold numbers)
↓
<details class="about-research"> (collapsible)
↓
## Finding {.finding} → .finding-statement → figure OR .map-card iframe
↓
## Conclusion
```

### Two Ways to Include Visuals

1. **Static PNG figures:** `knitr::include_graphics("figures/01_name.png")` — generated by `scripts/analysis.R`
2. **Interactive HTML maps:** `.map-card` + `<iframe src="assets/map.html">` — pre-built or saved via `htmlwidgets::saveWidget()`

## How to Reproduce

```r
# From the vvnthemes/tests/testthat/ directory:
setwd("vvnthemes/tests/testthat")
source("test_vvnthemes.R")
```

## Accessibility Note

`vvn_accessibility_check()` on the `"vt"` palette reports 3/6 colors fail WCAG AA 4.5:1 contrast against white:
- `#508590` (Sustainable Teal) — 4.12:1
- `#75787B` (Hokie Stone) — 4.44:1
- `#D7D2CB` (Land Grant Grey) — 1.5:1

Use `vvn_palette("wcag")` or `vvn_palette("accessible")` for guaranteed contrast compliance.
