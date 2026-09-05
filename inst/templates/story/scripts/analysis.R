# ── VVN Story Analysis Script ─────────────────────────────────────────────────
# Project : VVN_TITLE
# Author  : VVN_AUTHOR
# Created : VVN_DATE
#
# HOW TO USE:
#   1. Place your data in data/raw/ or data/processed/.
#   2. Load it in Section 1 below.
#   3. Uncomment and fill in the chart block(s) you want from the gallery.
#   4. Source this script — figures are auto-numbered and saved to figures/.
#   5. Open index.qmd: replace [placeholders] and update include_graphics()
#      filenames to match what was saved in figures/.
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


# ── COUNTY MAP (leaflet + static PNG) ────────────────────────────────────────
# Good for: showing geographic variation across Virginia counties.
#
# library(leaflet)
# library(mapshot2)   # install.packages("mapshot2")
#
# m <- leaflet(va_counties) |>
#   vvn_map_style(
#     data      = va_counties,
#     value_col = "[your_variable]",
#     title     = "[Legend title]"
#   )
#
# mapshot2(m, file = sprintf("figures/%02d_map.png", .n + 1L))
# .n <<- .n + 1L   # advance counter manually for the map
# message(sprintf("Saved figures/%02d_map.png", .n))


# =============================================================================

message(sprintf("Done — %d figure(s) saved to figures/", .n))
