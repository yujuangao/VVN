# ── VVN Dashboard Analysis Script ─────────────────────────────────────────────
# Project : VVN_TITLE
# Author  : VVN_AUTHOR
# Created : VVN_DATE
#
# HOW TO USE:
#   1. Place your data in data/raw/ or data/processed/.
#   2. Load it in Section 1 below.
#   3. Uncomment and fill in the chart block(s) you want from the gallery.
#   4. Source this script — figures are auto-numbered and saved to figures/.
#   5. Open app.R: fill in chart filenames (e.g., 01_[name].png) and
#      uncomment the renderUI() blocks for each chart, then run shiny::runApp().
#
# Charts generated here are displayed as static PNGs in app.R.
# Interactive components (KPI cards, filters, table, map) are built in app.R.
#
# Run from project root:
#   source("scripts/analysis.R")          # RStudio
#   Rscript scripts/analysis.R            # terminal
# ─────────────────────────────────────────────────────────────────────────────

library(vvnthemes)
library(ggplot2)
library(dplyr)
library(tidyr)

set_vvn_defaults()

# ── Set root to project folder (one level up from scripts/) ──────────────────
.script_dir <- tryCatch(
  dirname(rstudioapi::getSourceEditorContext()$path),   # RStudio: open & source
  error = function(e) {
    # Rscript fallback: Rscript scripts/analysis.R
    args <- commandArgs(trailingOnly = FALSE)
    f    <- grep("--file=", args, value = TRUE)
    if (length(f)) dirname(normalizePath(sub("--file=", "", f))) else getwd()
  }
)
setwd(normalizePath(file.path(.script_dir, "..")))
dir.create("figures", showWarnings = FALSE)
message("Project root      : ", getwd())
message("Figures saved to  : ", normalizePath("figures"))

# ── Auto-numbering helper ─────────────────────────────────────────────────────
# Figures are numbered in the order you run them — no manual renaming needed.
.n <- 0L
save_fig <- function(plot, name, width = 8, height = 5) {
  .n <<- .n + 1L
  path <- sprintf("figures/%02d_%s.png", .n, name)
  vvn_save(plot, path, width = width, height = height)
}

# ── 1. Load your data ────────────────────────────────────────────────────────
# TODO: Replace with your actual file paths.
# df        <- readr::read_csv("data/processed/my_data.csv")
# df_region <- readr::read_csv("data/processed/my_regional_data.csv")


# =============================================================================
# CHART GALLERY — uncomment the blocks you want, fill in column names & labels
# =============================================================================


# ── LINE CHART: single metric trend over time ─────────────────────────────────
# Good for: showing how one indicator changed year over year statewide.
#
# p <- ggplot(df, aes(x = year, y = value)) +
#   geom_line(linewidth = 1.3, color = vvn_colors("maroon")) +
#   geom_point(size = 2.8, color = vvn_colors("maroon")) +
#   scale_x_continuous(breaks = unique(df$year)) +
#   labs(
#     title    = "[Chart title]",
#     subtitle = "[Subtitle or data source note]",
#     x = NULL, y = "[Y-axis label]"
#   ) +
#   vvn_source("[Dataset name]") +
#   scatter_grid()
#
# save_fig(p, "trend_single")


# ── LINE CHART: multiple groups over time ─────────────────────────────────────
# Good for: comparing regions, counties, or demographic groups across years.
#
# p <- ggplot(df, aes(x = year, y = value, color = group, group = group)) +
#   geom_line(linewidth = 1.2) +
#   geom_point(size = 2.5) +
#   scale_color_vvn("main") +
#   scale_x_continuous(breaks = unique(df$year)) +
#   labs(
#     title    = "[Chart title]",
#     subtitle = "[Subtitle]",
#     x = NULL, y = "[Y-axis label]", color = "[Legend title]"
#   ) +
#   vvn_source("[Dataset name]") +
#   scatter_grid()
#
# save_fig(p, "trend_grouped")


# ── HORIZONTAL BAR CHART: ranking or comparison ───────────────────────────────
# Good for: comparing localities or groups side by side; highlight one in orange.
#
# p <- df |>
#   mutate(name   = reorder(name, value),
#          hi     = name == "[name to highlight]") |>
#   ggplot(aes(x = value, y = name, fill = hi)) +
#   geom_col(width = 0.65) +
#   geom_text(aes(label = round(value, 1)), hjust = -0.2, size = 3.4,
#             color = "#3D3D3D") +
#   scale_fill_manual(values = c(`TRUE` = "#E5751F", `FALSE` = "#861F41"),
#                     guide = "none") +
#   scale_x_continuous(expand = expansion(mult = c(0, .15))) +
#   labs(
#     title    = "[Chart title]",
#     subtitle = "[Highlighted group] in orange",
#     x = "[X-axis label]", y = NULL
#   ) +
#   vvn_source("[Dataset name]") +
#   remove_ticks()
#
# save_fig(p, "bar_horizontal")


# ── VERTICAL BAR CHART ────────────────────────────────────────────────────────
# Good for: comparing a small number of categories (≤ 8).
#
# p <- df |>
#   mutate(name = reorder(name, -value)) |>
#   ggplot(aes(x = name, y = value, fill = name)) +
#   geom_col(width = 0.65, show.legend = FALSE) +
#   geom_text(aes(label = round(value, 1)), vjust = -0.4, size = 3.4,
#             color = "#3D3D3D") +
#   scale_fill_vvn("main") +
#   scale_y_continuous(expand = expansion(mult = c(0, .12))) +
#   labs(
#     title = "[Chart title]",
#     x = NULL, y = "[Y-axis label]"
#   ) +
#   vvn_source("[Dataset name]") +
#   remove_ticks()
#
# save_fig(p, "bar_vertical")


# ── STACKED BAR CHART ────────────────────────────────────────────────────────
# Good for: showing part-to-whole relationships across groups.
#
# p <- df |>
#   ggplot(aes(x = group, y = value, fill = category)) +
#   geom_col(width = 0.65, position = "stack") +
#   scale_fill_vvn("main") +
#   scale_y_continuous(expand = expansion(mult = c(0, .08))) +
#   labs(
#     title = "[Chart title]",
#     x = NULL, y = "[Y-axis label]", fill = "[Legend title]"
#   ) +
#   vvn_source("[Dataset name]") +
#   remove_ticks()
#
# save_fig(p, "bar_stacked")


# ── SCATTER PLOT ──────────────────────────────────────────────────────────────
# Good for: showing the relationship between two continuous variables.
#
# p <- ggplot(df, aes(x = x_var, y = y_var, color = group)) +
#   geom_point(size = 3, alpha = 0.8) +
#   scale_color_vvn("main") +
#   labs(
#     title    = "[Chart title]",
#     subtitle = "Each point = one locality",
#     x = "[X-axis label]", y = "[Y-axis label]", color = "[Legend title]"
#   ) +
#   vvn_source("[Dataset name]") +
#   scatter_grid()
#
# save_fig(p, "scatter")


# ── BUBBLE CHART: scatter with size ──────────────────────────────────────────
# Good for: adding a third dimension (e.g., population size) to a scatter.
#
# p <- ggplot(df, aes(x = x_var, y = y_var, color = group, size = size_var)) +
#   geom_point(alpha = 0.75) +
#   scale_color_vvn("main") +
#   scale_size_continuous(range = c(2, 10), labels = scales::comma,
#                         name = "[Size legend title]") +
#   labs(
#     title    = "[Chart title]",
#     subtitle = "Size = [size variable]",
#     x = "[X-axis label]", y = "[Y-axis label]", color = "[Legend title]"
#   ) +
#   vvn_source("[Dataset name]") +
#   scatter_grid()
#
# save_fig(p, "bubble")


# ── LOLLIPOP CHART: ranking ───────────────────────────────────────────────────
# Good for: ranking counties or groups with a score; highlight top vs. bottom.
#
# p <- df |>
#   mutate(name  = reorder(name, value),
#          group = if_else(value >= median(value), "Above median", "Below median")) |>
#   ggplot(aes(x = value, y = name, color = group)) +
#   geom_segment(aes(x = 0, xend = value, yend = name),
#                linewidth = 0.7, alpha = 0.5) +
#   geom_point(size = 3.5) +
#   geom_text(aes(label = round(value, 1)), hjust = -0.4, size = 3.2) +
#   scale_color_manual(values = c(`Above median` = "#861F41",
#                                 `Below median` = "#E5751F")) +
#   scale_x_continuous(limits = c(0, NA), expand = expansion(mult = c(0, .15))) +
#   labs(
#     title = "[Chart title]",
#     x = "[X-axis label]", y = NULL, color = NULL
#   ) +
#   vvn_source("[Dataset name]") +
#   remove_ticks()
#
# save_fig(p, "lollipop", height = 7)


# ── HISTOGRAM / DISTRIBUTION ──────────────────────────────────────────────────
# Good for: showing the spread or skew of a variable across observations.
#
# p <- ggplot(df, aes(x = value)) +
#   geom_histogram(bins = 20, fill = "#861F41", color = "#FFFFFF", alpha = 0.9) +
#   geom_vline(xintercept = mean(df$value, na.rm = TRUE),
#              color = "#E5751F", linewidth = 1.2, linetype = "dashed") +
#   annotate("text",
#            x = mean(df$value, na.rm = TRUE), y = Inf,
#            label = paste0("Mean: ", round(mean(df$value, na.rm = TRUE), 1)),
#            color = "#E5751F", hjust = -0.1, vjust = 1.5, size = 3.5) +
#   labs(
#     title = "[Chart title]",
#     x = "[X-axis label]", y = "Count"
#   ) +
#   vvn_source("[Dataset name]")
#
# save_fig(p, "histogram", width = 6, height = 3.5)


# ── FACETED CHART: small multiples ───────────────────────────────────────────
# Good for: showing the same metric across multiple subgroups simultaneously.
#
# p <- ggplot(df, aes(x = year, y = value, color = subgroup, group = subgroup)) +
#   geom_line(linewidth = 1.1) +
#   geom_point(size = 2) +
#   facet_wrap(~ facet_var, ncol = 3) +
#   scale_color_vvn("main") +
#   labs(
#     title = "[Chart title]",
#     x = NULL, y = "[Y-axis label]", color = "[Legend title]"
#   ) +
#   vvn_source("[Dataset name]") +
#   scatter_grid()
#
# save_fig(p, "faceted", height = 6)


# ── COUNTY MAP (saved as PNG) ─────────────────────────────────────────────────
# Good for: showing geographic variation across Virginia counties.
# Requires: library(leaflet), library(sf), library(mapshot2)
#
# library(leaflet)
# library(sf)
# library(mapshot2)   # install.packages("mapshot2")
#
# va_counties <- sf::read_sf("data/processed/va_counties.geojson")
#
# m <- leaflet::leaflet(va_counties) |>
#   vvn_map_style(
#     data      = va_counties,
#     value_col = "[your_variable]",
#     title     = "[Legend title]"
#   )
#
# .n <- .n + 1L
# mapshot2::mapshot2(m, file = sprintf("figures/%02d_map.png", .n))
# message(sprintf("Saved figures/%02d_map.png", .n))


# =============================================================================

message(sprintf("Done — %d figure(s) saved to figures/", .n))
