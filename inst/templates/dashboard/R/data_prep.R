# ==============================================================================
# R/data_prep.R — VVN Dashboard Data Preparation
# ==============================================================================
# Load your data here. This file is sourced by app.R on startup.
#
# Folder conventions:
#   data/raw/        — original, unmodified data files (do not edit)
#   data/processed/  — cleaned, analysis-ready files (load these here)
#
# After loading, define these two objects for use in app.R:
#   app_data    — data frame, your main analysis-ready data
#   va_counties — sf object, Virginia county shapefile (optional, for Map tab)
# ==============================================================================

# ── Load your processed data ───────────────────────────────────────────────────
# Uncomment and update the filename to match your file in data/processed/:
#
# library(readr)
# app_data <- readr::read_csv(
#   "data/processed/[your_file].csv",   # <-- Replace with your filename
#   show_col_types = FALSE
# )

# ── Load county shapefile (required for the Map tab only) ─────────────────────
# Place your GeoJSON or shapefile in data/processed/ first, then uncomment:
#
# library(sf)
# va_counties <- sf::read_sf("data/processed/va_counties.geojson")

# ── Internal helper ────────────────────────────────────────────────────────────
# Null-coalescing operator used in app.R
`%||%` <- function(x, y) if (!is.null(x) && length(x) > 0) x else y
