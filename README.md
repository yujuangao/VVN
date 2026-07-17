# vvnthemes <img src="man/figures/logo.png" align="right" height="139" alt=""/>

<!-- badges: start -->
[![R-CMD-check](https://github.com/yujuangao/VVN/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yujuangao/VVN/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<!-- badges: end -->

**Websites:** [R Library Docs](https://yujuangao.github.io/VVN/) · [Style Guide](https://yujuangao.github.io/VVN/guide/)

---

This repository hosts the **vvnthemes** R package for the **Visualizing Virginia Numbers (VVN)** project at Virginia Tech. VVN transforms complex public datasets — broadband, housing, workforce, healthcare, and economic data — into clear, accessible visualizations covering all 133 Virginia localities. `vvnthemes` gives every VVN team member a shared toolkit to produce consistent, VT-branded, publication-ready charts, maps, tables, dashboards, and reports without rebuilding brand styles from scratch.

## About vvnthemes

`vvnthemes` is the design system for all VVN projects. It provides everything needed to produce consistent, publication-ready outputs — so every chart, map, table, dashboard, and report your team creates follows the same visual standard automatically.

| Feature | What it provides |
|---------|-----------------|
| 🎨 **VT Brand Colors** | VT Maroon, Burnt Orange, and Navy applied globally with `set_vvn_defaults()`. Discrete and continuous palettes for every chart type. |
| 📊 **ggplot2 Themes & Scales** | Three themes for charts, maps, and minimal layouts. Categorical and continuous color scales with automatic VT palette mapping. |
| 🗺️ **Interactive Maps** | One-function Leaflet county choropleth maps with VT branded fill, maroon hover highlight, tooltips, and a styled legend. |
| 📋 **Styled Tables** | Branded `gt` tables with maroon headers, alternating rows, source notes, and p-value color coding. |
| 🖥️ **Shiny UI Components** | Branded filters, sliders, buttons, and KPI cards for Shiny dashboards — all styled to VT brand guidelines. |
| 🚀 **Project Scaffolding** | One-command setup for a complete Shiny dashboard or Quarto narrative report, ready to run immediately. |

---

**The library includes 9 modules:**

| Module | Functions | What it does |
|--------|-----------|--------------|
| **Color System** | `vvn_colors()`, `vvn_palette()`, `view_vvn_palette()` | VT brand hex values and named palettes (sequential, diverging, accessible) |
| **ggplot2 Scales** | `scale_color_vvn()`, `scale_fill_vvn()`, `scale_*_vvn_c()` | Drop-in discrete and continuous color/fill scales |
| **ggplot2 Theme** | `theme_vvn()`, `theme_vvn_map()`, `theme_vvn_minimal()` | VT-branded chart themes; map and infographic variants |
| **Chart Helpers** | `vvn_title()`, `vvn_source()`, `vvn_save()`, `set_vvn_defaults()` | Add titles/source lines, export multi-format figures, set global defaults |
| **GT Tables** | `vvn_table()`, `vvn_table_pvalues()` | Style `gt` tables with VT maroon headers and footnotes |
| **Leaflet Maps** | `vvn_map_style()` | VT-branded choropleth maps with color scale, legend, and tooltips |
| **Shiny UI** | `vvn_filter()`, `vvn_slider()`, `vvn_button()`, `vvn_kpi_card()` | Branded Shiny widgets: dropdowns, sliders, action buttons, KPI metric cards |
| **Story Template** | `create_vvn_story()`, `check_vvn_story()` | Scaffold a Quarto data story project with VVN CSS, folder structure, and front matter |
| **Dashboard Template** | `create_vvn_dashboard()` | Scaffold a full Shiny dashboard with sidebar filters, KPI row, charts, map, and data table |

All outputs follow **VT Brand Guidelines** (Maroon `#861F41`, Orange `#E5751F`, Navy `#1B5299`) and meet **WCAG 2.1 AA** accessibility requirements.

---

## Installation

**Recommended — no extra packages needed in R 4.4+:**

```r
pak::pkg_install("yujuangao/VVN")
```

**Alternatives:**

```r
# Option B
install.packages("remotes")
remotes::install_github("yujuangao/VVN")

# Option C
install.packages("devtools")
devtools::install_github("yujuangao/VVN")
```

Then load in any script:

```r
library(vvnthemes)
set_vvn_defaults()   # applies VT Maroon theme + geom colors globally
```

> **Note for developers working on the package locally:** always install with
> `R CMD build` + `R CMD INSTALL` rather than `devtools::install()` to avoid
> a corrupt help database (`lazy-load database … is corrupt`).
>
> ```bash
> cd /path/to/VVN
> R CMD build vvnthemes --no-build-vignettes
> R CMD INSTALL vvnthemes_0.0.1.tar.gz
> rm vvnthemes_0.0.1.tar.gz
> ```

> **Namespace note:** if `urbnthemes` is also loaded, use the `vvn_`-prefixed
> aliases (`vvn_remove_legend()`, `vvn_remove_ticks()`, etc.) to avoid
> conflicts with functions of the same name in that package.

---

## Quick Start

### 1 · Scaffold a Data Story

```r
library(vvnthemes)

create_vvn_story("childcare_cost",
                  title  = "Childcare Cost in Rural Virginia",
                  author = "VVN Research Team")
```

Creates:

```
childcare_cost/
├── index.qmd        ← Edit this to write your story
├── _quarto.yml
├── styles.scss      ← VT brand CSS/SCSS
├── data/
│   ├── raw/
│   └── processed/
├── figures/
├── scripts/
└── README.md
```

Then render:

```r
quarto::quarto_render("index.qmd")
# → index.html  (self-contained, ready to publish)
```

---

### 2 · Scaffold a Shiny Dashboard

```r
create_vvn_dashboard("housing_dashboard",
                      title = "Virginia Housing Affordability Dashboard")
```

Creates a full `app.R` with:

- Maroon navbar (`bslib::page_navbar`)
- Filter sidebar (dropdowns, sliders, apply button)
- KPI cards row
- Trend line chart + bar chart + histogram
- County map tab (Leaflet placeholder)
- GT data table tab

Run it:

```r
shiny::runApp("housing_dashboard")
```

---

### 3 · ggplot2 Theme & Scales

```r
library(ggplot2)

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point(size = 2.5) +
  theme_vvn() +
  scale_color_vvn() +
  labs(title    = "Engine Displacement vs. Highway MPG",
       subtitle = "Visualizing Virginia Numbers · VT Brand Theme",
       caption  = "Source: EPA fuel economy data")
```

Available themes:

| Function            | Use case                          |
|---------------------|-----------------------------------|
| `theme_vvn()`       | Standard charts (bar, line, scatter) |
| `theme_vvn_map()`   | Choropleth / `geom_sf()` maps     |
| `theme_vvn_minimal()` | Infographic / no-axis charts    |

Available scales:

```r
scale_color_vvn()          # discrete, "main" palette (10 colors)
scale_fill_vvn("brand")    # discrete, brand palette (maroon/orange/navy)
scale_color_vvn_c("maroon_seq")   # continuous, sequential
scale_fill_vvn_c("diverging")     # continuous, diverging
```

---

### 4 · Color Palettes

```r
vvn_colors()                        # all named brand colors
vvn_colors("maroon", "orange")      # specific colors

vvn_palette("main")                 # 10-color categorical
vvn_palette("maroon_seq", n = 8)    # 8-step sequential
vvn_palette("diverging", n = 11)    # 11-step diverging
vvn_palette("accessible")           # colorblind-friendly (Okabe-Ito)
```

---

### 5 · GT Table Styling

```r
library(gt)

my_data |>
  gt() |>
  vvn_table(
    title       = "Summary Statistics by County",
    subtitle    = "2018–2022 · VVN Research",
    source_note = "Source: American Community Survey 5-Year Estimates"
  )
```

---

### 6 · Leaflet Map

```r
library(leaflet)

leaflet(va_counties) |>
  vvn_map_style(
    data      = va_counties,
    value_col = "median_income",
    title     = "Median Income ($)"
  )
```

---

### 7 · Shiny UI Components

```r
library(shiny)

# Filter dropdown
vvn_filter("region", "Region",
           choices = c("All", "Urban", "Suburban", "Rural"))

# Slider
vvn_slider("year", "Year", min = 2015, max = 2023, value = c(2015, 2023))

# Button
vvn_button("apply", "Apply Filters", style = "primary")

# KPI card
vvn_kpi_card("134", "Total Counties",
              trend = "up", trend_text = "+5 vs last year")
```

---

### 8 · Accessibility Check

```r
vvn_accessibility_check(vvn_palette("brand"))
# ■ VVN Accessibility Check · AA
# ✔ #861F41  10.5:1  PASS
# ! #E5751F  3.8:1   FAIL (need ≥4.5:1)
# ✔ #1B5299  8.3:1   PASS
# ℹ 1 color(s) fail WCAG AA. Consider vvn_palette('accessible').
```

---

### 9 · Export

```r
p <- ggplot(mpg, aes(displ, hwy)) + geom_point() + theme_vvn()

# Single format
vvn_save(p, "figures/mpg_plot.png")

# Multiple formats at once
vvn_save(p, "figures/mpg_plot", formats = c("png", "pdf", "svg"))
```

---

## Package Structure

```
vvnthemes/
├── DESCRIPTION
├── NAMESPACE
├── R/
│   ├── colors.R              # vvn_colors(), vvn_palette()
│   ├── scales.R              # scale_color_vvn(), scale_fill_vvn()
│   ├── theme_vvn.R           # theme_vvn(), theme_vvn_map(), theme_vvn_minimal()
│   ├── vvn_table.R           # vvn_table(), vvn_table_pvalues()
│   ├── vvn_map.R             # vvn_map_style()
│   ├── vvn_filter.R          # vvn_filter(), vvn_slider(), vvn_button(), vvn_kpi_card()
│   ├── vvn_save.R            # vvn_save()
│   ├── vvn_accessibility.R   # vvn_accessibility_check()
│   ├── create_vvn_story.R    # create_vvn_story(), check_vvn_story()
│   ├── create_vvn_dashboard.R# create_vvn_dashboard()
│   └── zzz.R                 # Package docs & startup message
├── inst/
│   ├── templates/
│   │   ├── story/
│   │   │   ├── index.qmd     # Quarto data story template
│   │   │   ├── _quarto.yml
│   │   │   └── styles.scss   # Full VVN SCSS theme
│   │   └── dashboard/
│   │       ├── app.R         # Complete Shiny dashboard template
│   │       └── R/
│   │           └── data_prep.R
│   └── www/
│       └── vvn.css           # Compiled VVN CSS (for Shiny)
└── man/                      # Auto-generated by roxygen2
```

---

## Brand Reference

| Token       | Hex       | Usage                         |
|-------------|-----------|-------------------------------|
| VT Maroon   | `#861F41` | Titles, headers, primary CTAs |
| VT Orange   | `#E5751F` | Accents, callouts, highlights |
| Navy        | `#1B5299` | Secondary data series         |
| Charcoal    | `#3D3D3D` | Body text                     |
| Light Gray  | `#F7F7F7` | Page/row backgrounds          |

---

## Contributing

Issues and pull requests welcome at <https://github.com/yujuangao/VVN>.

---

*Visualizing Virginia Numbers · Virginia Tech*
