# =============================================================================
# R/data_prep.R  —  VVN Dashboard Data Preparation
# Replace the example data below with your actual data sources.
# =============================================================================

# ── Load your data ─────────────────────────────────────────────────────────
# app_data <- readr::read_csv("data/processed/my_data.csv")
# va_counties <- sf::read_sf("data/processed/va_counties.geojson")

# ── Example data (replace with real data) ──────────────────────────────────
set.seed(2024)

app_data <- expand.grid(
  year   = 2015:2023,
  region = c("Rural", "Small City", "Suburban", "Urban Fringe", "Urban Core"),
  stringsAsFactors = FALSE
) |>
  dplyr::mutate(
    value = dplyr::case_when(
      region == "Rural"        ~ stats::rnorm(dplyr::n(), 46,  3),
      region == "Small City"   ~ stats::rnorm(dplyr::n(), 52,  3),
      region == "Suburban"     ~ stats::rnorm(dplyr::n(), 57,  3),
      region == "Urban Fringe" ~ stats::rnorm(dplyr::n(), 61,  3),
      region == "Urban Core"   ~ stats::rnorm(dplyr::n(), 65,  4),
      TRUE ~ NA_real_
    ) + (year - 2015) * 0.85,    # upward trend
    employment = pmin(97, value + stats::rnorm(dplyr::n(), 10, 2)),
    poverty    = pmax(2,  20 - value / 5 + stats::rnorm(dplyr::n(), 0, 1))
  ) |>
  dplyr::arrange(year, region)

# Convenience aggregation by region (for display)
va_regions <- app_data |>
  dplyr::group_by(region) |>
  dplyr::summarise(
    mean_value = mean(value),
    n_years    = dplyr::n_distinct(year),
    .groups    = "drop"
  )

# Null-coalescing operator (used in app.R)
`%||%` <- function(x, y) if (!is.null(x) && length(x) > 0) x else y
