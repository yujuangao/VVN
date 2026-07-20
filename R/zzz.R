#' vvnthemes: Visualizing Virginia Numbers Themes and Templates
#'
#' @description
#' `vvnthemes` is the design system for all Visualizing Virginia Numbers (VVN)
#' projects at Virginia Tech. It enforces VT brand colors, typography, and
#' layout rules so every chart, map, table, dashboard, and narrative report
#' produced by VVN teams is consistent and publication-ready.
#'
#' VT brand colors: **Maroon** `#861F41` · **Orange** `#E5751F` · **Navy** `#1B5299`
#'
#' @section Quick start:
#' ```r
#' library(vvnthemes)
#' set_vvn_defaults()        # apply VT Maroon theme + geom colors globally
#' view_vvn_palette("main")  # preview the brand palette
#' ```
#'
#' @section Setup:
#' Apply or remove VT brand defaults for the session.
#' - [set_vvn_defaults()] — Set `theme_vvn()` as the global ggplot2 theme and
#'   change default geom colors to VT Maroon and VT Orange. Call once per script.
#' - [undo_vvn_defaults()] — Revert ggplot2 to factory defaults.
#'
#' @section Themes:
#' ggplot2 themes built on [ggplot2::theme_minimal()].
#' - [theme_vvn()] — Standard VVN chart theme: white background, maroon titles,
#'   light gray horizontal gridlines. Use for bar charts, line charts, histograms.
#' - [theme_vvn_map()] — Map variant: removes axes, muted background, legend at
#'   bottom. Use with [ggplot2::geom_sf()] for static choropleth maps.
#' - [theme_vvn_minimal()] — No gridlines, no axes. For small multiples and
#'   annotation-heavy figures.
#'
#' @section Color system:
#' Access and preview VT brand and artistic palettes.
#'
#' **VT Brand (categorical):** `"vt"`, `"brand"`, `"main"`, `"accessible"`, `"wcag"`
#'
#' **Sequential:** `"maroon_seq"`, `"orange_seq"`, `"navy_seq"`, `"gray_seq"`
#'
#' **Diverging:** `"diverging"` (navy–white–maroon)
#'
#' **Artistic themes (categorical):** `"monet"`, `"sunflower"`, `"academic"`, `"natural"`
#'
#' **Artistic themes (diverging):** `"monet_div"`, `"sunflower_div"`,
#' `"academic_div"`, `"natural_div"` — interpolated to any `n`.
#'
#' - [vvn_colors()] — Return hex codes for named VVN brand colors.
#' - [vvn_palette()] — Build a color vector from any palette; use `pick` to
#'   extract a single color by index.
#' - [view_vvn_palette()] — Render a swatch strip using [ggplot2::ggplot()].
#'
#' @section Scales:
#' Drop-in replacements for [ggplot2::scale_color_discrete()] and
#' [ggplot2::scale_fill_gradient()].
#' - [scale_color_vvn()] — Discrete color scale for grouped line/scatter charts.
#' - [scale_fill_vvn()] — Discrete fill scale for grouped bar/area charts.
#' - [scale_color_vvn_c()] — Continuous color scale (sequential or diverging).
#' - [scale_fill_vvn_c()] — Continuous fill scale; primary function for static
#'   choropleth maps with [ggplot2::geom_sf()].
#'
#' @section Chart helpers:
#' Wrappers around [ggplot2::labs()] and [ggplot2::theme()].
#' - [vvn_title()] — Add headline-case title and sentence-case subtitle.
#' - [vvn_source()] — Add required source attribution caption. **Required on
#'   every published VVN figure.**
#' - [vvn_note()] — Add a footnote annotation without a source line.
#' - [remove_ticks()] — Remove axis tick marks.
#' - [remove_axis()] — Remove a full axis (text, title, ticks, line).
#' - [scatter_grid()] — Add gridlines on both axes for scatter plots.
#' - [legend_bottom()] — Move legend to bottom in horizontal orientation.
#' - [remove_legend()] — Remove the legend entirely.
#' - [vvn_save()] — Export at 300 dpi using [ggplot2::ggsave()].
#' - [vvn_accessibility_check()] — Check WCAG 2.1 contrast ratios (AA/AAA).
#'
#' @section Tables:
#' Requires the \pkg{gt} package (`install.packages("gt")`).
#' See [gt::gt()] for how to create a gt table before styling.
#' - [vvn_table()] — Apply VT Maroon headers, alternating rows, and orange
#'   accent border to a [gt::gt()] table.
#' - [vvn_table_pvalues()] — Color-code a p-value column in a regression table.
#'   Pipe after [vvn_table()].
#'
#' @section Maps:
#' Requires \pkg{leaflet} and \pkg{sf}.
#' See [leaflet::leaflet()] and [sf::st_read()] for prerequisites.
#' - [vvn_map_style()] — Build an interactive Leaflet county choropleth map with
#'   VT brand colors, maroon hover highlight, popup tooltips, and a styled legend.
#'
#' @section Shiny UI:
#' Requires \pkg{shiny} (`install.packages("shiny")`).
#' See [shiny::fluidPage()] and [shiny::sidebarLayout()] for dashboard structure.
#' - [vvn_filter()] — Branded [shiny::selectInput()] dropdown with maroon label.
#' - [vvn_slider()] — Branded [shiny::sliderInput()] with maroon track.
#' - [vvn_button()] — Styled [shiny::actionButton()] in primary, secondary, or
#'   outline variants.
#' - [vvn_kpi_card()] — Large-number KPI card with label and trend indicator.
#'   Use three per row: maroon, orange, navy.
#'
#' @section Scaffolding:
#' One-command project setup. Both templates run immediately with placeholder data.
#' - [create_vvn_dashboard()] — Generate a complete Shiny dashboard:
#'   `app.R`, `scripts/analysis.R`, `www/vvn.css`, `data/`, `figures/` folders.
#'   Run with [shiny::runApp()]; deploy with `rsconnect::deployApp()`.
#' - [create_vvn_story()] — Generate a VVN Insights Quarto project:
#'   `index.qmd`, `_quarto.yml`, `styles.scss`, `figures/`, `scripts/`.
#'   Render with `quarto::quarto_render()`.
#' - [check_vvn_story()] — Validate a VVN Insights `index.qmd` before
#'   publishing (checks sections, [theme_vvn()], [vvn_source()]).
#'
#' @seealso
#' **Documentation:** <https://yujuangao.github.io/VVN/>
#'
#' **Style guide:** <https://yujuangao.github.io/VVN/guide/>
#'
#' **GitHub:** <https://github.com/yujuangao/VVN>
#'
#' **Key dependencies:**
#' [ggplot2::ggplot()], [gt::gt()], [leaflet::leaflet()],
#' [shiny::shinyApp()], [sf::st_read()]
#'
"_PACKAGE"


.onAttach <- function(libname, pkgname) {
  v <- utils::packageVersion(pkgname)
  packageStartupMessage(
    "\u25a0 vvnthemes ", v,
    " \u00b7 Visualizing Virginia Numbers \u00b7 Virginia Tech\n",
    "  Use set_vvn_defaults() to apply VVN brand globally."
  )
}
