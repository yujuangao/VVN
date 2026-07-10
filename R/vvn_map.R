# =============================================================================
# VVN Leaflet Map Styling
# =============================================================================

#' Apply VVN branding to a Leaflet choropleth map
#'
#' Adds a muted CartoDB basemap, VVN-palette choropleth fill, county hover
#' highlights in maroon, popup tooltips, and a styled legend.
#'
#' @param map        A `leaflet` map object.
#' @param data       An `sf` or spatial data frame.
#' @param value_col  Name of the numeric column to visualise.
#' @param label_col  Column for popup label. Defaults to `value_col`.
#' @param palette    VVN palette for the choropleth: `"maroon_seq"` (default),
#'   `"orange_seq"`, `"navy_seq"`, `"diverging"`.
#' @param n_bins     Number of legend bins. Default `6`.
#' @param title      Legend title. Defaults to `value_col`.
#' @param opacity    Fill opacity (0–1). Default `0.75`.
#' @param fmt_fn     Function to format popup values. Default: comma-formatted.
#'
#' @return A styled `leaflet` map.
#' @export
#'
#' @examples
#' \dontrun{
#' library(leaflet); library(sf)
#' leaflet(va_counties) |>
#'   vvn_map_style(va_counties, "median_income", title = "Median Income ($)")
#' }
vvn_map_style <- function(map,
                           data,
                           value_col,
                           label_col = value_col,
                           palette   = "maroon_seq",
                           n_bins    = 6,
                           title     = value_col,
                           opacity   = 0.75,
                           fmt_fn    = function(x) format(round(x), big.mark = ",")) {

  for (pkg in c("leaflet", "htmltools")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      cli::cli_abort("Package {.pkg {pkg}} is required.")
    }
  }

  pal_cols <- vvn_palette(palette, n = n_bins)
  vals     <- data[[value_col]]
  pal_fn   <- leaflet::colorBin(pal_cols, domain = vals, bins = n_bins,
                                 na.color = "#AAAAAA")

  labels <- sprintf(
    "<strong>%s</strong><br/>%s: %s",
    data[[label_col]], title, fmt_fn(vals)
  ) |> lapply(htmltools::HTML)

  map |>
    leaflet::addProviderTiles("CartoDB.Positron",
      options = leaflet::providerTileOptions(opacity = 0.9)
    ) |>
    leaflet::addPolygons(
      data         = data,
      fillColor    = ~pal_fn(vals),
      fillOpacity  = opacity,
      color        = "#FFFFFF",
      weight       = 1,
      smoothFactor = 0.4,
      highlight    = leaflet::highlightOptions(
        weight      = 2.5,
        color       = "#861F41",
        fillOpacity = 0.9,
        bringToFront = TRUE
      ),
      label        = labels,
      labelOptions = leaflet::labelOptions(
        style = list(
          "font-family"   = "sans-serif",
          "font-size"     = "13px",
          "padding"       = "6px 10px",
          "border-radius" = "6px",
          "border"        = "1.5px solid #861F41",
          "box-shadow"    = "0 2px 6px rgba(0,0,0,0.15)"
        ),
        direction = "auto"
      )
    ) |>
    leaflet::addLegend(
      position  = "bottomright",
      pal       = pal_fn,
      values    = vals,
      title     = title,
      opacity   = 0.9,
      labFormat = leaflet::labelFormat(big.mark = ",")
    )
}
