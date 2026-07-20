# vvnthemes

<!-- badges: start -->
[![R-CMD-check](https://github.com/yujuangao/VVN/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yujuangao/VVN/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
<!-- badges: end -->

📖 [R Library Docs](https://yujuangao.github.io/VVN/) · 🎨 [Style Guide](https://yujuangao.github.io/VVN/guide/)

---

## What is Visualizing Virginia's Numbers?

**Visualizing Virginia's Numbers (VVN)** is a Virginia Tech initiative that turns complex public data into clear, accessible visualizations for all 133 Virginia localities — covering broadband, housing, workforce, healthcare, and economic trends.

Every VVN output — charts, maps, tables, dashboards, and reports — must follow a consistent visual standard so the work is immediately recognizable, trustworthy, and publication-ready.

---

## What is vvnthemes?

`vvnthemes` is the official R design system for all VVN projects. It packages Virginia Tech's brand colors, typography, and layout rules into a single toolkit so every team member can produce consistent outputs without building styles from scratch.

### What it includes

| Module | Key functions | What it does |
|--------|---------------|--------------|
| **Colors** | `vvn_colors()`, `vvn_palette()`, `view_vvn_palette()` | VT brand hex values and named palettes (sequential, diverging, colorblind-safe, artistic) |
| **ggplot2 Scales** | `scale_color_vvn()`, `scale_fill_vvn()`, `scale_*_vvn_c()` | Drop-in discrete and continuous color/fill scales |
| **ggplot2 Theme** | `theme_vvn()`, `theme_vvn_map()`, `theme_vvn_minimal()` | VT-branded chart themes for standard, map, and minimal layouts |
| **Chart Helpers** | `vvn_source()`, `vvn_save()`, `set_vvn_defaults()` | Source lines, multi-format export, global brand defaults |
| **Tables** | `vvn_table()`, `vvn_table_pvalues()` | Styled `gt` tables with VT maroon headers and footnotes |
| **Maps** | `vvn_map_style()` | One-function VT-branded Leaflet county choropleth |
| **Shiny UI** | `vvn_filter()`, `vvn_slider()`, `vvn_button()`, `vvn_kpi_card()`, `vvn_bs_theme()` | Branded dropdowns, sliders, buttons, KPI cards, Bootstrap theme |
| **Story scaffold** | `create_vvn_story()`, `check_vvn_story()` | Generate a complete Quarto data story project |
| **Dashboard scaffold** | `create_vvn_dashboard()` | Generate a complete Shiny dashboard project |

All outputs follow **VT Brand Guidelines** (Maroon `#861F41`, Orange `#E5751F`) and meet **WCAG 2.1 AA** accessibility standards.

---

## Installation

### 1 · Create a master setup file

Before starting any VVN project, create a `master.R` file in your project root and run it once. This installs everything you need.

```r
# master.R — run this once before starting a VVN project

# Install the fast package installer
if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")

# vvnthemes (from GitHub)
pak::pak("yujuangao/VVN")

# Core packages — always needed
pak::pak(c("ggplot2", "dplyr", "tidyr", "readr"))

# Dashboard packages — needed for create_vvn_dashboard()
pak::pak(c("shiny", "bslib", "bsicons"))

# Optional — uncomment what you need
# pak::pak("gt")                       # styled tables
# pak::pak(c("leaflet", "sf"))         # interactive maps
# pak::pak("DT")                       # interactive data tables
# pak::pak("mapshot2")                 # save maps as PNG

# Verify
library(vvnthemes)
set_vvn_defaults()
message("vvnthemes ready!")
```

### 2 · Load in any script

```r
library(vvnthemes)
set_vvn_defaults()   # applies VT brand theme and geom colors globally
```

> **Alternative install (without pak):**
> ```r
> install.packages("remotes")
> remotes::install_github("yujuangao/VVN")
> ```

---

## Workflow

VVN produces two types of outputs. Choose the one that fits your goal:

| Goal | Output type | Function |
|------|-------------|----------|
| Tell a story with a fixed narrative | Quarto data story | `create_vvn_story()` |
| Let users filter and explore data | Shiny dashboard | `create_vvn_dashboard()` |

---

### Option A · Quarto Data Story

Use when you have a single finding to communicate as a scrollable, publishable web page.

**Step 1 — Scaffold the project**

```r
library(vvnthemes)

create_vvn_story(
  "childcare_cost",
  title  = "Childcare Cost in Rural Virginia",
  author = "VVN Research Team"
)
```

This creates a ready-to-run project:

```
childcare_cost/
├── index.qmd        ← write your narrative here
├── _quarto.yml      ← site title, navbar, footer
├── styles.scss      ← VT brand styles (do not edit)
├── scripts/
│   └── analysis.R   ← build all charts here; source this first
├── figures/         ← auto-numbered PNGs from analysis.R
└── data/
    ├── raw/         ← original source files (do not edit)
    └── processed/   ← cleaned files used in analysis.R
```

**Step 2 — Build charts in `scripts/analysis.R`**

```r
library(vvnthemes)
library(ggplot2)

set_vvn_defaults()

df <- readr::read_csv("data/processed/childcare.csv")

p <- ggplot(df, aes(x = year, y = cost, color = region)) +
  geom_line(linewidth = 1.2) +
  scale_color_vvn("main") +
  labs(title    = "Annual Childcare Cost by Region",
       subtitle = "Virginia, 2015–2023",
       x = NULL, y = "Annual Cost ($)") +
  vvn_source("Virginia Department of Social Services")

vvn_save(p, "figures/01_childcare_trend.png")
```

Source the script to auto-number and save all figures to `figures/`.

**Step 3 — Write your story and render**

Open `index.qmd`, fill in your narrative, embed your figures, then render:

```r
quarto::quarto_render("index.qmd")
# → index.html (self-contained, ready to publish)
```

---

### Option B · Shiny Dashboard

Use when users need to filter and explore data themselves in real time.

**Step 1 — Scaffold the project**

```r
create_vvn_dashboard(
  "housing_dashboard",
  title = "Virginia Housing Affordability Dashboard"
)
```

This creates a ready-to-run project:

```
housing_dashboard/
├── app.R            ← Shiny app; load data, display charts, reactive UI
├── scripts/
│   └── analysis.R   ← build all charts here; source this first
├── figures/         ← auto-numbered PNGs from analysis.R
├── www/
│   └── vvn.css      ← VVN brand styles (do not edit)
└── data/
    ├── raw/         ← original source files (do not edit)
    └── processed/   ← cleaned files loaded in app.R
```

**Step 2 — Build charts in `scripts/analysis.R`**

Same as Option A — uncomment the chart types you need from the gallery, fill in your column names, and source the script. Figures save automatically to `figures/`.

**Step 3 — Load data in `app.R`**

```r
# Near the top of app.R — uncomment and fill in your filename:
app_data <- readr::read_csv("data/processed/housing.csv",
                             show_col_types = FALSE)
```

Then update each `renderUI` block with the filename saved in `figures/`.

**Step 4 — Run and deploy**

```r
shiny::runApp("housing_dashboard")       # preview locally
rsconnect::deployApp("housing_dashboard") # publish to shinyapps.io
```

---

### Option C · Standalone Charts

Use `vvnthemes` in any existing R script or Quarto document.

```r
library(ggplot2)
library(vvnthemes)

set_vvn_defaults()

ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point(size = 2.5) +
  scale_color_vvn("main") +
  labs(title    = "Engine Displacement vs. Highway MPG",
       subtitle = "Virginia counties · VT Brand Theme",
       x = "Displacement (L)", y = "Highway MPG") +
  vvn_source("EPA Fuel Economy Data")
```

---

## Quick reference

**Colors**
```r
vvn_colors("maroon")                 # "#861F41"
vvn_palette("main")                  # 10-color categorical
vvn_palette("accessible")            # Okabe-Ito colorblind-safe (7 colors)
vvn_palette("maroon_seq", n = 8)     # 8-step sequential
vvn_palette("vt_div", n = 11)        # 11-step diverging (maroon ↔ navy)
```

**Themes & scales**
```r
theme_vvn()                          # standard charts
theme_vvn_map()                      # choropleth maps
scale_color_vvn("main")              # discrete, 10 colors
scale_fill_vvn_c("maroon_seq")       # continuous sequential
scale_fill_vvn_c("vt_div")          # continuous diverging
```

**Tables**
```r
my_df |> gt() |>
  vvn_table(title = "Summary by County",
            source_note = "Source: ACS 2022")
```

**Maps**
```r
leaflet(va_counties) |>
  vvn_map_style(data = va_counties, value_col = "rate",
                title = "Poverty Rate (%)")
```

**Export**
```r
vvn_save(p, "figures/plot.png")
vvn_save(p, "figures/plot", formats = c("png", "pdf", "svg"))
```

---

## Brand colors

| Color | Hex | Primary use |
|-------|-----|-------------|
| VT Maroon | `#861F41` | Titles, headers, fills |
| VT Orange | `#E5751F` | Accents, highlights |
| Navy | `#1B5299` | Secondary data series |
| Charcoal | `#3D3D3D` | Body text |
| Light Gray | `#F7F7F7` | Backgrounds, rows |

---

## Contact & Support

| Channel | Link |
|---------|------|
| General questions & feedback | [vvn@vt.edu](mailto:vvn@vt.edu) |
| Bug reports & feature requests | [GitHub Issues](https://github.com/yujuangao/VVN/issues) |
| Pull requests | [GitHub Repo](https://github.com/yujuangao/VVN) |

Have a question about using a function, found unexpected behavior, or want to suggest a new feature? Open a [GitHub Issue](https://github.com/yujuangao/VVN/issues) or email **vvn@vt.edu** — we read both.

---

*Visualizing Virginia's Numbers · Virginia Tech*
