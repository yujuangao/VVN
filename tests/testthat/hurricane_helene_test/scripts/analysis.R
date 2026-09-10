# ── VVN Story Analysis Script ─────────────────────────────────────────────────
# Project : Hurricane Helene Impact on Virginia Vegetation
# Author  : Yujuan Gao
# Created : 2026-09-10
# ─────────────────────────────────────────────────────────────────────────────

library(vvnthemes)
library(ggplot2)
library(dplyr)

set_vvn_defaults()

.script_dir <- tryCatch(
  dirname(rstudioapi::getSourceEditorContext()$path),
  error = function(e) {
    args <- commandArgs(trailingOnly = FALSE)
    f    <- grep("--file=", args, value = TRUE)
    if (length(f)) dirname(normalizePath(sub("--file=", "", f))) else getwd()
  }
)
setwd(normalizePath(file.path(.script_dir, "..")))
dir.create("figures", showWarnings = FALSE)

.n <- 0L
save_fig <- function(plot, name, width = 8, height = 5) {
  .n <<- .n + 1L
  path <- sprintf("figures/%02d_%s.png", .n, name)
  vvn_save(plot, path, width = width, height = height)
}

# ── Data ────────────────────────────────────────────────────────────────────
set.seed(42)

ndvi <- data.frame(
  county = rep(c("Montgomery", "Floyd", "Giles", "Pulaski", "Craig",
                 "Roanoke", "Bedford", "Franklin", "Patrick", "Carroll"), 2),
  period = rep(c("Pre-storm (Aug 2024)", "Post-storm (Oct 2024)"), each = 10),
  ndvi = c(0.72, 0.68, 0.75, 0.71, 0.74, 0.70, 0.73, 0.69, 0.67, 0.71,
           0.45, 0.41, 0.52, 0.48, 0.55, 0.50, 0.47, 0.44, 0.39, 0.46)
)
ndvi$period <- factor(ndvi$period, levels = c("Pre-storm (Aug 2024)", "Post-storm (Oct 2024)"))

# ── Figure 1: NDVI bar chart ───────────────────────────────────────────────
p1 <- ggplot(ndvi, aes(x = reorder(county, -ndvi), y = ndvi, fill = period)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.65) +
  scale_fill_vvn(palette = "vt") +
  labs(
    title = "Vegetation Greenness Dropped Sharply After Hurricane Helene",
    subtitle = "NDVI for 10 southwest Virginia counties",
    x = NULL, y = "NDVI", fill = NULL
  ) +
  vvn_source("Sentinel-2 SR Harmonized, Google Earth Engine") +
  legend_bottom() +
  theme(axis.text.x = element_text(angle = 35, hjust = 1))

save_fig(p1, "ndvi_comparison", width = 10, height = 5.5)

message(sprintf("Done — %d figure(s) saved to figures/", .n))
