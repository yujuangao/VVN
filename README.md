# vvnthemes

<!-- badges: start -->
[![R-CMD-check](https://github.com/yujuangao/VVN/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yujuangao/VVN/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<!-- badges: end -->

[R Library Docs](https://yujuangao.github.io/VVN/) | [Style Guide](https://yujuangao.github.io/VVN/guide/)

**vvnthemes** is the R design system for [Visualizing Virginia's Numbers (VVN)](https://vvn.vt.edu) at Virginia Tech. Install it once, call `set_vvn_defaults()`, and every chart, table, map, and report you create will follow VT brand standards automatically.

---

## Install

```r
# Recommended
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")
pak::pak("yujuangao/VVN")

# Alternative
remotes::install_github("yujuangao/VVN")
```

## Quick start

```r
library(vvnthemes)
library(ggplot2)

set_vvn_defaults()

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  scale_color_vvn("main") +
  labs(title = "Engine Size vs. Highway MPG") +
  vvn_source("EPA Fuel Economy Data")
```

`set_vvn_defaults()` sets `theme_vvn()` as the global ggplot2 theme and applies VT Maroon geom defaults. Call it once at the top of any script.

---

## What's in the box

| Module | Functions | Purpose |
|--------|-----------|---------|
| **Theme** | `theme_vvn()`, `theme_vvn_map()` | Publication-quality ggplot2 themes |
| **Colors** | `vvn_colors()`, `vvn_palette()`, `view_vvn_palette()` | VT brand palettes (categorical, sequential, diverging, colorblind-safe) |
| **Scales** | `scale_color_vvn()`, `scale_fill_vvn()`, `scale_*_vvn_c()` | Drop-in ggplot2 color/fill scales |
| **Helpers** | `vvn_source()`, `vvn_save()`, `vvn_title()` | Source captions, export, titles |
| **Tables** | `vvn_table()`, `vvn_table_pvalues()` | Styled `gt` tables |
| **Maps** | `vvn_map_style()` | One-function Leaflet choropleth |
| **Shiny** | `vvn_filter()`, `vvn_slider()`, `vvn_button()`, `vvn_kpi_card()`, `vvn_bs_theme()` | Branded UI components |
| **Scaffold** | `create_vvn_story()`, `create_vvn_dashboard()` | Generate full project templates |
| **Validation** | `check_vvn_story()`, `vvn_accessibility_check()` | Story structure checks, WCAG contrast |

---

## Create a data story

```r
library(vvnthemes)

create_vvn_story(
  "childcare_cost",
  title  = "Childcare Cost in Rural Virginia",
  author = "VVN Research Team"
)
```

This generates a ready-to-use project:

```
childcare_cost/
├── index.qmd            ← Write your narrative
├── _quarto.yml           ← Site config (title, TOC, navbar)
├── styles.scss           ← VVN brand styles (do not edit)
├── scripts/analysis.R    ← Build all charts here
├── figures/              ← Auto-numbered PNGs from analysis.R
└── data/
    ├── raw/              ← Original source files
    └── processed/        ← Cleaned data for analysis
```

**Workflow:**

1. Open `scripts/analysis.R` — uncomment chart blocks, fill in your data, source it
2. Open `index.qmd` — replace `[placeholders]` with your narrative
3. Render: `quarto::quarto_render("index.qmd")`

The template includes a VVN article header, stats row, finding sections with numbered headlines, and an "About This Research" accordion — all styled and ready to fill in.

---

## Create a dashboard

```r
create_vvn_dashboard(
  "housing_dashboard",
  title = "Virginia Housing Affordability Dashboard"
)
```

Then run: `shiny::runApp("housing_dashboard")`

---

## Common patterns

**Colors and palettes**

```r
vvn_colors("maroon")                 # "#861F41"
vvn_palette("main")                  # 10-color categorical
vvn_palette("accessible")            # Okabe-Ito colorblind-safe
vvn_palette("maroon_seq", n = 8)     # 8-step sequential
vvn_palette("vt_div", n = 11)        # 11-step diverging
```

**Themes**

```r
theme_vvn()                          # All charts (near-black titles, no axis lines, bottom legend)
theme_vvn(grid = "none")             # No gridlines
theme_vvn(grid = "both")             # X + Y gridlines (scatter plots)
theme_vvn_map()                      # Choropleth maps (no axes, muted background)
```

**Tables**

```r
my_df |> gt::gt() |>
  vvn_table(title = "Summary by County",
            source_note = "Source: ACS 2022")
```

**Maps**

```r
leaflet::leaflet(va_counties) |>
  vvn_map_style(data = va_counties, value_col = "rate",
                title = "Poverty Rate (%)")
```

**Export**

```r
vvn_save(p, "figures/plot.png")
vvn_save(p, "figures/plot", formats = c("png", "pdf", "svg"))
```

**Accessibility**

```r
vvn_accessibility_check(vvn_palette("main"))                   # 3:1 graphic threshold
vvn_accessibility_check(vvn_palette("main"), use = "text")     # 4.5:1 text threshold
```

---

## Brand colors

| Color | Hex | Use |
|-------|-----|-----|
| VT Maroon | `#861F41` | Titles, headers, fills |
| VT Orange | `#E5751F` | Accents, highlights |
| Navy | `#1B5299` | Secondary data series |
| Charcoal | `#3D3D3D` | Body text |
| Light Gray | `#F7F7F7` | Backgrounds |

---

## Help

- Bug reports and feature requests: [GitHub Issues](https://github.com/yujuangao/VVN/issues)
- Questions: [vvn@vt.edu](mailto:vvn@vt.edu)

---

*Visualizing Virginia's Numbers · Virginia Tech*
