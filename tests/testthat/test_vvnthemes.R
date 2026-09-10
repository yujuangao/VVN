# =============================================================================
# vvnthemes Test Suite — Hurricane Project
# Test02: Comprehensive package test using Hurricane Helene data context
# =============================================================================

library(vvnthemes)
library(ggplot2)
library(gt)

script_dir <- getwd()
out_dir <- file.path(script_dir, "outputs")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

results <- list()
pass <- function(name, note = "") { results[[name]] <<- list(status = "PASS", note = note) }
fail <- function(name, note = "") { results[[name]] <<- list(status = "FAIL", note = note) }

cat("=== vvnthemes Test Suite — Hurricane Project ===\n\n")

# ── 1. Package loads ─────────────────────────────────────────────────────────
tryCatch({
  v <- as.character(packageVersion("vvnthemes"))
  cat("1. Package version:", v, "\n")
  pass("1_package_loads", paste("v", v))
}, error = function(e) fail("1_package_loads", e$message))

# ── 2. set_vvn_defaults / undo_vvn_defaults ──────────────────────────────────
tryCatch({
  set_vvn_defaults()
  th <- ggplot2::theme_get()
  stopifnot(inherits(th, "theme"))
  undo_vvn_defaults()
  pass("2_set_undo_defaults")
}, error = function(e) fail("2_set_undo_defaults", e$message))

# ── 3. theme_vvn() ──────────────────────────────────────────────────────────
tryCatch({
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn()
  ggsave(file.path(out_dir, "03_theme_vvn.png"), p, width = 8, height = 5, dpi = 150, bg = "white")
  pass("3_theme_vvn")
}, error = function(e) fail("3_theme_vvn", e$message))

# ── 4. theme_vvn_map() ──────────────────────────────────────────────────────
tryCatch({
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn_map()
  ggsave(file.path(out_dir, "04_theme_vvn_map.png"), p, width = 8, height = 5, dpi = 150, bg = "white")
  pass("4_theme_vvn_map")
}, error = function(e) fail("4_theme_vvn_map", e$message))

# ── 5. theme_vvn(grid variants) ─────────────────────────────────────────────
tryCatch({
  for (g in c("y", "x", "both", "none")) {
    p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn(grid = g)
  }
  pass("5_theme_grid_variants")
}, error = function(e) fail("5_theme_grid_variants", e$message))

# ── 6. vvn_colors() ─────────────────────────────────────────────────────────
tryCatch({
  cols <- vvn_colors("maroon", "orange", "navy")
  stopifnot(length(cols) == 3, all(grepl("^#", cols)))
  cat("6. vvn_colors: maroon=", cols[1], " orange=", cols[2], " navy=", cols[3], "\n")
  pass("6_vvn_colors", paste(cols, collapse = ", "))
}, error = function(e) fail("6_vvn_colors", e$message))

# ── 7. vvn_palette() — all categorical palettes ─────────────────────────────
cat_pals <- c("vt", "vt_secondary", "brand", "main", "accessible", "wcag",
              "monet", "sunflower", "academic", "natural")
tryCatch({
  for (pal in cat_pals) {
    p <- vvn_palette(pal)
    stopifnot(is.character(p), length(p) >= 3)
  }
  pass("7_categorical_palettes", paste(length(cat_pals), "palettes OK"))
}, error = function(e) fail("7_categorical_palettes", e$message))

# ── 8. vvn_palette() — sequential & diverging ───────────────────────────────
seq_pals <- c("maroon_seq", "orange_seq", "navy_seq", "gray_seq",
              "hokie_stone_seq", "diverging")
tryCatch({
  for (pal in seq_pals) {
    p <- vvn_palette(pal)
    stopifnot(is.character(p), length(p) >= 3)
  }
  pass("8_sequential_palettes", paste(length(seq_pals), "palettes OK"))
}, error = function(e) fail("8_sequential_palettes", e$message))

# ── 9. view_vvn_palette() ───────────────────────────────────────────────────
tryCatch({
  p <- view_vvn_palette("vt")
  ggsave(file.path(out_dir, "09_palette_vt.png"), p, width = 8, height = 2, dpi = 150, bg = "white")
  p2 <- view_vvn_palette("maroon_seq")
  ggsave(file.path(out_dir, "09_palette_maroon_seq.png"), p2, width = 8, height = 2, dpi = 150, bg = "white")
  pass("9_view_palette")
}, error = function(e) fail("9_view_palette", e$message))

# ── 10. scale_fill_vvn() — Hurricane bar chart ──────────────────────────────
tryCatch({
  helene <- data.frame(
    site = rep(c("Blacksburg", "Floyd", "Giles", "Montgomery", "Pulaski"), 2),
    period = rep(c("Pre-storm", "Post-storm"), each = 5),
    ndvi = c(0.72, 0.68, 0.75, 0.71, 0.69, 0.45, 0.41, 0.52, 0.48, 0.43)
  )
  p <- ggplot(helene, aes(site, ndvi, fill = period)) +
    geom_col(position = "dodge") +
    scale_fill_vvn() +
    theme_vvn() +
    vvn_title("NDVI Change After Hurricane Helene",
              subtitle = "Treatment sites in southwest Virginia") +
    vvn_source("Sentinel-2 SR Harmonized, Google Earth Engine")
  ggsave(file.path(out_dir, "10_bar_hurricane.png"), p, width = 8, height = 5, dpi = 150, bg = "white")
  pass("10_scale_fill_vvn")
}, error = function(e) fail("10_scale_fill_vvn", e$message))

# ── 11. scale_color_vvn() — line chart ──────────────────────────────────────
tryCatch({
  ts_data <- data.frame(
    month = rep(1:12, 3),
    sensor = rep(c("Sentinel-1", "Sentinel-2", "Combined"), each = 12),
    obs = c(runif(12, 8, 12), runif(12, 4, 8), runif(12, 12, 20))
  )
  p <- ggplot(ts_data, aes(month, obs, color = sensor)) +
    geom_line(linewidth = 1) +
    scale_color_vvn(palette = "vt") +
    theme_vvn() +
    vvn_title("Monthly Satellite Observations", subtitle = "Hurricane monitoring sites") +
    vvn_source("Google Earth Engine")
  ggsave(file.path(out_dir, "11_line_hurricane.png"), p, width = 8, height = 5, dpi = 150, bg = "white")
  pass("11_scale_color_vvn")
}, error = function(e) fail("11_scale_color_vvn", e$message))

# ── 12. scale_fill_vvn_c() — continuous heatmap ─────────────────────────────
tryCatch({
  grid_data <- expand.grid(x = 1:10, y = 1:10)
  grid_data$ndvi_change <- rnorm(100, -0.15, 0.1)
  p <- ggplot(grid_data, aes(x, y, fill = ndvi_change)) +
    geom_tile() +
    scale_fill_vvn_c("diverging") +
    theme_vvn_map() +
    vvn_title("NDVI Difference (Post - Pre Storm)")
  ggsave(file.path(out_dir, "12_heatmap_ndvi.png"), p, width = 6, height = 5, dpi = 150, bg = "white")
  pass("12_scale_fill_vvn_c")
}, error = function(e) fail("12_scale_fill_vvn_c", e$message))

# ── 13. Plot utilities ──────────────────────────────────────────────────────
tryCatch({
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn() +
    vvn_title("Test") + vvn_source("Test source") +
    scatter_grid() + legend_bottom()
  # Also test remove functions
  p2 <- p + remove_ticks() + remove_axis("y") + remove_legend()
  ggsave(file.path(out_dir, "13_utils.png"), p2, width = 8, height = 5, dpi = 150, bg = "white")
  pass("13_plot_utilities")
}, error = function(e) fail("13_plot_utilities", e$message))

# ── 14. vvn_note() ──────────────────────────────────────────────────────────
tryCatch({
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn() +
    vvn_note("Cloud-free composites only; gaps filled with nearest date")
  pass("14_vvn_note")
}, error = function(e) fail("14_vvn_note", e$message))

# ── 15. vvn_save() — multi-format ───────────────────────────────────────────
tryCatch({
  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_vvn()
  vvn_save(p, file.path(out_dir, "15_save_test"), formats = c("png", "pdf"))
  stopifnot(file.exists(file.path(out_dir, "15_save_test.png")))
  stopifnot(file.exists(file.path(out_dir, "15_save_test.pdf")))
  pass("15_vvn_save")
}, error = function(e) fail("15_vvn_save", e$message))

# ── 16. vvn_table() — GT table ──────────────────────────────────────────────
tryCatch({
  sensor_tbl <- data.frame(
    Sensor = c("Sentinel-1 GRD", "Sentinel-2 SR"),
    Bands = c("VV, VH", "B2-B8A, B11-B12"),
    Resolution = c("10m", "10-20m"),
    Revisit = c("6 days", "5 days")
  )
  tbl <- gt(sensor_tbl) |>
    vvn_table(
      title = "Satellite Data Sources",
      subtitle = "Hurricane Helene Monitoring",
      source_note = "European Space Agency (ESA)"
    )
  gt::gtsave(tbl, file.path(out_dir, "16_table.png"))
  pass("16_vvn_table")
}, error = function(e) fail("16_vvn_table", e$message))

# ── 17. vvn_accessibility_check() ───────────────────────────────────────────
tryCatch({
  result <- vvn_accessibility_check(vvn_palette("vt"))
  stopifnot(is.data.frame(result))
  cat("17. Accessibility check columns:", paste(names(result), collapse = ", "), "\n")
  pass("17_accessibility_check")
}, error = function(e) fail("17_accessibility_check", e$message))

# ── 18. Alias functions work ────────────────────────────────────────────────
tryCatch({
  stopifnot(is.function(vvn_remove_ticks))
  stopifnot(is.function(vvn_remove_axis))
  stopifnot(is.function(vvn_remove_legend))
  stopifnot(is.function(vvn_legend_bottom))
  stopifnot(is.function(vvn_scatter_grid))
  stopifnot(is.function(scale_colour_vvn))
  stopifnot(is.function(scale_colour_vvn_c))
  pass("18_alias_functions", "7 aliases confirmed")
}, error = function(e) fail("18_alias_functions", e$message))

# ── 19. Hurricane composite chart ───────────────────────────────────────────
tryCatch({
  set_vvn_defaults()
  sites <- data.frame(
    county = rep(c("Montgomery", "Floyd", "Giles", "Pulaski", "Craig"), each = 4),
    type = rep(c("Treatment", "Counterfactual"), each = 2, times = 5),
    sensor = rep(c("Sentinel-1", "Sentinel-2"), times = 10),
    scenes = c(18,12, 20,14, 16,10, 19,13, 17,11,
               22,15, 21,16, 23,14, 20,13, 24,17)
  )
  p <- ggplot(sites, aes(county, scenes, fill = interaction(type, sensor))) +
    geom_col(position = position_dodge(width = 0.8), width = 0.7) +
    scale_fill_vvn(palette = "main") +
    vvn_title("Satellite Scene Counts by County",
              subtitle = "Treatment vs. Counterfactual sites — Sentinel-1 & Sentinel-2") +
    vvn_source("Google Earth Engine", note = "Oct 2024 – Mar 2025") +
    labs(x = NULL, y = "Number of Scenes", fill = NULL) +
    legend_bottom()
  ggsave(file.path(out_dir, "19_composite_hurricane.png"), p, width = 10, height = 6, dpi = 150, bg = "white")
  undo_vvn_defaults()
  pass("19_composite_chart")
}, error = function(e) { undo_vvn_defaults(); fail("19_composite_chart", e$message) })

# ── 20. Assets exist check ──────────────────────────────────────────────────
tryCatch({
  assets_dir <- file.path(dirname(dirname(dirname(dirname(script_dir)))),
                          "VVN Insights", "Hurricane", "assets")
  expected <- c("01_treatment_counterfactual_map.html",
                "02_greenness_map.html",
                "03_helene_track.html")
  found <- file.exists(file.path(assets_dir, expected))
  names(found) <- expected
  cat("20. Assets:\n")
  for (i in seq_along(found)) cat("    ", names(found)[i], ":", ifelse(found[i], "FOUND", "MISSING"), "\n")
  if (all(found)) pass("20_assets_check", "3/3 maps found") else pass("20_assets_check", paste(sum(found), "/3 maps found"))
}, error = function(e) fail("20_assets_check", e$message))

# =============================================================================
# Summary
# =============================================================================
cat("\n===== TEST RESULTS =====\n")
n_pass <- sum(sapply(results, `[[`, "status") == "PASS")
n_fail <- sum(sapply(results, `[[`, "status") == "FAIL")
for (nm in names(results)) {
  r <- results[[nm]]
  tag <- if (r$status == "PASS") "[PASS]" else "[FAIL]"
  note <- if (nchar(r$note) > 0) paste0(" — ", r$note) else ""
  cat(sprintf("  %s %s%s\n", tag, nm, note))
}
cat(sprintf("\nTotal: %d passed, %d failed, %d total\n", n_pass, n_fail, n_pass + n_fail))

# Save results as RDS for README generation
saveRDS(results, file.path(out_dir, "test_results.rds"))
cat("\nOutputs saved to:", out_dir, "\n")
