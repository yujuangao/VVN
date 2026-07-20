# vvnthemes <img src="man/figures/logo.png" align="right" height="139" alt="vvnthemes logo"/>

<!-- badges: start -->
[![R-CMD-check](https://github.com/yujuangao/VVN/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yujuangao/VVN/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<!-- badges: end -->

**Websites:** [R Library Docs](https://yujuangao.github.io/VVN/) · [Style Guide](https://yujuangao.github.io/VVN/guide/)

---

## What is Visualizing Virginia's Numbers?

**Visualizing Virginia's Numbers (VVN)** is a Virginia Tech initiative that transforms complex public data into clear, accessible visualizations for all 133 Virginia localities — covering broadband, housing, workforce, healthcare, and economic trends.

`vvnthemes` is the official design system for all VVN projects. It gives every team member a shared toolkit to produce consistent, VT-branded, publication-ready charts, maps, tables, dashboards, and narrative reports — without rebuilding brand styles from scratch.

All outputs follow **VT Brand Guidelines** (Maroon `#861F41`, Orange `#E5751F`, Navy `#1B5299`) and meet **WCAG 2.1 AA** accessibility requirements.

---

## What the package includes

`vvnthemes` is organized into **9 modules**:

| Module | Functions | What it does |
|--------|-----------|--------------|
| **Color System** | `vvn_colors()`, `vvn_palette()`, `view_vvn_palette()` | VT brand hex values and named palettes — sequential, diverging, accessible, and artistic |
| **ggplot2 Scales** | `scale_color_vvn()`, `scale_fill_vvn()`, `scale_*_vvn_c()` | Drop-in discrete and continuous color/fill scales |
| **ggplot2 Theme** | `theme_vvn()`, `theme_vvn_map()`, `theme_vvn_minimal()` | VT-branded chart themes; map and infographic variants |
| **Chart Helpers** | `vvn_title()`, `vvn_source()`, `vvn_save()`, `set_vvn_defaults()` | Add titles/source lines, export multi-format figures, set global defaults |
| **GT Tables** | `vvn_table()`, `vvn_table_pvalues()` | Style `gt` tables with VT maroon headers and source footnotes |
| **Leaflet Maps** | `vvn_map_style()` | One-function VT-branded county choropleth with fill scale, tooltip, and legend |
| **Shiny UI** | `vvn_filter()`, `vvn_slider()`, `vvn_button()`, `vvn_kpi_card()`, `vvn_bs_theme()` | Branded Shiny widgets: dropdowns, sliders, action buttons, KPI metric cards, Bootstrap theme |
| **Story Template** | `create_vvn_story()`, `check_vvn_story()` | Scaffold a Quarto data narrative project with VVN CSS, folder structure, and front matter |
| **Dashboard Template** | `create_vvn_dashboard()` | Scaffold a full Shiny dashboard with sidebar, KPI row, chart tabs, map, and data table |

---

## Before you start — set up your environment

> **Create a `master.R` setup file in your project root and run it once before starting any VVN project.** This ensures all required packages are installed before you begin.

```r
# master.R
# Run this file ONCE before starting any VVN project.
# ─────────────────────────────────────────────────────

# 1. Install the fast package installer (if you haven't already)
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")

# 2. Install vvnthemes from GitHub
pak::pak("yujuangao/VVN")

# 3. Install core data packages
pak::pak(c(
  "ggplot2",   # charts
  "dplyr",     # data manipulation
  "tidyr",     # data reshaping
  "readr"      # CSV import
))

# 4. Install dashboard packages (needed for create_vvn_dashboard)
pak::pak(c(
  "shiny",     # web app framework
  "bslib",     # Bootstrap 5 themes
  "bsicons"    # Bootstrap icons
))

# 5. Install optional packages (uncomment what you need)
# pak::pak("gt")               # styled summary tables
# pak::pak(c("leaflet", "sf")) # interactive county maps
# pak::pak("DT")               # interactive data tables
# pak::pak("mapshot2")         # save Leaflet maps as PNG

# ── Verify ───────────────────────────────────────────
library(vvnthemes)
set_vvn_defaults()
message("vvnthemes is ready. Let's visualize Virginia!")
```

---

## How to install vvnthemes

```r
# Option A — pak (recommended, fastest)
install.packages("pak")
pak::pak("yujuangao/VVN")

# Option B — remotes
install.packages("remotes")
remotes::install_github("yujuangao/VVN")
```

Then load it in any script:

```r
library(vvnthemes)
set_vvn_defaults()   # applies VT brand theme + geom colors globally
```

---

## Workflow

### Option 1 · Quarto Data Story (narrative report)

Use this when you have a single finding to communicate as a scrollable, publishable report.

**Step 1 — Scaffold**

```r
library(vvnthemes)

create_vvn_story(
  "childcare_cost",
  title  = "Childcare Cost in Rural Virginia",
  author = "VVN Research Team"
)
```

Creates:

```
childcare_cost/
├── index.qmd          ← Write your narrative here
├── _quarto.yml        ← Site config (title, navbar, footer)
├── styles.scss        ← VT brand CSS — do not edit
├── scripts/
│   └── analysis.R     ← Build all charts here; source this first
├── figures/           ← Auto-numbered PNGs saved by analysis.R
│   ├── 01_trend.png
│   └── 02_map.png
└── data/
    ├── raw/           ← Original source files — do not edit
    └── processed/     ← Cleaned files used in analysis.R
```

**Step 2 — Build charts in `scripts/analysis.R`**

```r
# In scripts/analysis.R
library(vvnthemes)
library(ggplot2)

set_vvn_defaults()

df <- readr::read_csv("data/processed/childcare.csv")

p <- ggplot(df, aes(x = year, y = cost, color = region)) +
  geom_line(linewidth = 1.2) +
  scale_color_vvn("main") +
  labs(
    title    = "Annual Childcare Cost by Region",
    subtitle = "Virginia, 2015–2023",
    x = NULL, y = "Cost ($)"
  ) +
  vvn_source("Virginia Department of Social Services")

vvn_save(p, "figures/01_childcare_trend.png")
```

**Step 3 — Write your story in `index.qmd`**

```r
# Render to HTML
quarto::quarto_render("index.qmd")
```

---

### Option 2 · Interactive Shiny Dashboard

Use this when users need to filter and explore data themselves.

**Step 1 — Scaffold**

```r
create_vvn_dashboard(
  "housing_dashboard",
  title = "Virginia Housing Affordability Dashboard"
)
```

Creates:

```
housing_dashboard/
├── app.R              ← Main Shiny app; load data + display charts + reactive UI
├── scripts/
│   └── analysis.R     ← Build all ggplot2 charts here; source this first
├── figures/           ← Auto-numbered PNGs saved by analysis.R
│   ├── 01_trend_statewide.png
│   └── 02_bar_by_region.png
├── www/
│   └── vvn.css        ← VVN brand styles — do not edit
└── data/
    ├── raw/           ← Original source files — do not edit
    └── processed/     ← Cleaned files loaded in app.R
```

**Step 2 — Build charts in `scripts/analysis.R`**, then source it — figures are auto-numbered and saved to `figures/`.

**Step 3 — Load data and wire charts in `app.R`**

```r
# Near the top of app.R — uncomment and fill in your filename:
app_data <- readr::read_csv("data/processed/housing.csv",
                             show_col_types = FALSE)
```

Then update each `renderUI` block with the matching filename from `figures/`.

**Step 4 — Run and deploy**

```r
shiny::runApp("housing_dashboard")
rsconnect::deployApp("housing_dashboard")
```

---

### Option 3 · Standalone Charts

Use vvnthemes in any R script or Quarto document.

```r
library(ggplot2)
library(vvnthemes)

set_vvn_defaults()

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point(size = 2.5) +
  theme_vvn() +
  scale_color_vvn("main") +
  labs(
    title    = "Engine Displacement vs. Highway MPG",
    subtitle = "Visualizing Virginia's Numbers · VT Brand Theme",
    x = "Displacement (L)", y = "Highway MPG"
  ) +
  vvn_source("EPA Fuel Economy Data")
```

---

## Key functions at a glance

### Colors & palettes

```r
vvn_colors("maroon")                    # single hex: "#861F41"
vvn_colors("maroon", "orange", "navy")  # named vector

vvn_palette("main")                     # 10-color categorical
vvn_palette("accessible")               # Okabe-Ito colorblind-safe (7 colors)
vvn_palette("maroon_seq", n = 8)        # 8-step sequential
vvn_palette("diverging", n = 11)        # 11-step diverging
```

### Themes & scales

```r
# Themes
theme_vvn()          # standard charts (bar, line, scatter)
theme_vvn_map()      # choropleth / geom_sf() maps
theme_vvn_minimal()  # infographic / panel-free layout

# Discrete scales
scale_color_vvn("main")      # 10-color categorical
scale_fill_vvn("accessible") # colorblind-safe

# Continuous scales
scale_color_vvn_c("maroon_seq")  # sequential
scale_fill_vvn_c("diverging")    # diverging
```

### Tables

```r
library(gt)

my_df |>
  gt() |>
  vvn_table(
    title       = "Summary Statistics by County",
    source_note = "Source: American Community Survey, 2022"
  )
```

### Maps

```r
library(leaflet)

leaflet(va_counties) |>
  vvn_map_style(
    data      = va_counties,
    value_col = "median_income",
    title     = "Median Household Income ($)"
  )
```

### Accessibility

```r
vvn_accessibility_check(vvn_palette("brand"))
# ■ VVN Accessibility Check · WCAG AA (4.5:1)
# ✔ #861F41  10.5:1  PASS
# ! #E5751F   3.8:1  FAIL → use vvn_palette("accessible") for text
# ✔ #1B5299   8.3:1  PASS
```

### Export

```r
p <- ggplot(mpg, aes(displ, hwy)) + geom_point() + theme_vvn()

vvn_save(p, "figures/plot.png")                          # PNG default
vvn_save(p, "figures/plot", formats = c("png", "pdf"))   # multiple formats
```

---

## Brand reference

| Token | Hex | Usage |
|-------|-----|-------|
| VT Maroon | `#861F41` | Titles, headers, primary accents |
| VT Orange | `#E5751F` | Highlights, callouts, active states |
| Navy | `#1B5299` | Secondary data series |
| Charcoal | `#3D3D3D` | Body text |
| Light Gray | `#F7F7F7` | Page and row backgrounds |

---

## Package structure

```
vvnthemes/
├── DESCRIPTION
├── NAMESPACE
├── R/
│   ├── colors.R               # vvn_colors(), vvn_palette(), view_vvn_palette()
│   ├── scales.R               # scale_color_vvn(), scale_fill_vvn(), _c variants
│   ├── theme_vvn.R            # theme_vvn(), theme_vvn_map(), theme_vvn_minimal()
│   ├── plot_utils.R           # vvn_title(), vvn_source(), set_vvn_defaults()
│   ├── vvn_save.R             # vvn_save()
│   ├── vvn_table.R            # vvn_table(), vvn_table_pvalues()
│   ├── vvn_map.R              # vvn_map_style()
│   ├── vvn_filter.R           # vvn_filter(), vvn_slider(), vvn_button(),
│   │                          #   vvn_kpi_card(), vvn_bs_theme()
│   ├── vvn_accessibility.R    # vvn_accessibility_check()
│   ├── create_vvn_story.R     # create_vvn_story(), check_vvn_story()
│   ├── create_vvn_dashboard.R # create_vvn_dashboard()
│   └── zzz.R                  # package docs & startup message
├── inst/
│   ├── templates/
│   │   ├── story/             # Quarto data story template
│   │   └── dashboard/         # Shiny dashboard template (app.R + scripts/)
│   └── www/
│       └── vvn.css            # Compiled VVN CSS for Shiny apps
└── man/                       # Auto-generated by roxygen2
```

---

## Contributing

Issues and pull requests are welcome at <https://github.com/yujuangao/VVN>.

---

*Visualizing Virginia's Numbers · Virginia Tech*
