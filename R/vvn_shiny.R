# =============================================================================
# VVN Shiny UI Components
# =============================================================================

#' VVN-branded select filter
#'
#' A Shiny `selectInput` wrapped in a VVN-styled container.
#'
#' @param inputId Shiny input ID.
#' @param label   Display label.
#' @param choices Named vector/list of choices.
#' @param selected Default value(s). Default `NULL`.
#' @param multiple Allow multiple selections? Default `FALSE`.
#' @param width   CSS width. Default `"100%"`.
#'
#' @return A Shiny `tagList`.
#' @export
vvn_filter <- function(inputId, label, choices,
                        selected = NULL, multiple = FALSE, width = "100%") {
  .require_shiny()
  shiny::div(
    class = "vvn-filter-wrap",
    shiny::selectInput(
      inputId  = inputId,
      label    = shiny::tags$span(class = "vvn-filter-label", label),
      choices  = choices,
      selected = selected,
      multiple = multiple,
      width    = width
    )
  )
}


#' VVN-branded slider
#'
#' A Shiny `sliderInput` with VVN maroon track and handle.
#'
#' @param inputId Shiny input ID.
#' @param label   Display label.
#' @param min,max Slider range.
#' @param value   Default value (scalar or length-2 for range).
#' @param step    Step size. Default `1`.
#' @param width   CSS width. Default `"100%"`.
#'
#' @return A Shiny `tagList`.
#' @export
vvn_slider <- function(inputId, label, min, max, value, step = 1, width = "100%") {
  .require_shiny()
  shiny::div(
    class = "vvn-slider-wrap",
    shiny::sliderInput(
      inputId = inputId,
      label   = shiny::tags$span(class = "vvn-filter-label", label),
      min     = min, max = max, value = value, step = step, width = width
    )
  )
}


#' VVN action button
#'
#' A styled `actionButton`. Style options: `"primary"` (maroon), `"secondary"`
#' (orange), `"outline"` (bordered maroon).
#'
#' @param inputId Shiny input ID.
#' @param label   Button label.
#' @param icon    Optional shiny icon. Default `NULL`.
#' @param style   Button style variant. Default `"primary"`.
#' @param width   CSS width. Default `NULL`.
#'
#' @return A Shiny `actionButton`.
#' @export
vvn_button <- function(inputId, label, icon = NULL,
                        style = c("primary", "secondary", "outline"),
                        width = NULL) {
  .require_shiny()
  style <- match.arg(style)
  shiny::actionButton(
    inputId = inputId, label = label, icon = icon,
    class   = paste0("vvn-btn vvn-btn-", style), width = width
  )
}


#' VVN KPI card
#'
#' Renders a metric card with large value, label, and optional trend indicator.
#'
#' @param value       Scalar value (character or numeric).
#' @param label       Descriptive label.
#' @param trend       `"up"`, `"down"`, or `NULL`. Default `NULL`.
#' @param trend_text  Trend annotation, e.g. `"+5% vs last year"`.
#' @param color_scheme `"maroon"` (default), `"orange"`, or `"navy"`.
#'
#' @return A Shiny `div` tag.
#' @export
vvn_kpi_card <- function(value, label, trend = NULL, trend_text = NULL,
                          color_scheme = c("maroon", "orange", "navy")) {
  .require_shiny()
  color_scheme <- match.arg(color_scheme)
  accent <- switch(color_scheme,
    maroon = "#861F41", orange = "#E5751F", navy = "#1B5299"
  )

  trend_tag <- NULL
  if (!is.null(trend)) {
    arrow      <- if (trend == "up") "\u2191" else "\u2193"
    trend_clr  <- if (trend == "up") "#2E7D32" else "#C62828"
    trend_tag  <- shiny::p(
      style = glue::glue("color:{trend_clr};font-size:.82rem;margin:.2rem 0 0"),
      shiny::HTML(paste(arrow, trend_text %||% ""))
    )
  }

  shiny::div(
    class = "vvn-kpi-card",
    style = glue::glue(
      "border-top:4px solid {accent};background:#FFFFFF;padding:1rem 1.2rem;",
      "border-radius:6px;box-shadow:0 1px 4px rgba(0,0,0,.10);"
    ),
    shiny::p(
      style = glue::glue("font-size:2rem;font-weight:700;color:{accent};margin:0 0 .2rem"),
      as.character(value)
    ),
    shiny::p(style = "font-size:.82rem;color:#3D3D3D;margin:0", label),
    trend_tag
  )
}


#' VVN accessibility check (WCAG contrast ratio)
#'
#' Computes WCAG 2.1 contrast ratios for a set of hex colors against a
#' background and flags which fail the chosen standard.
#'
#' @param colors     Character vector of hex codes.
#' @param background Background hex code. Default `"#FFFFFF"`.
#' @param level      `"AA"` (≥ 4.5:1, default) or `"AAA"` (≥ 7.0:1).
#'
#' @return A data frame with columns `color`, `contrast_ratio`, `pass`.
#'   Printed via `cli` with pass/fail badges.
#' @export
#'
#' @examples
#' vvn_accessibility_check(vvn_palette("brand"))
vvn_accessibility_check <- function(colors, background = "#FFFFFF",
                                     level = c("AA", "AAA")) {
  level     <- match.arg(level)
  threshold <- if (level == "AA") 4.5 else 7.0

  lum <- function(hex) {
    r <- grDevices::col2rgb(hex) / 255
    r <- ifelse(r <= .04045, r / 12.92, ((r + .055) / 1.055)^2.4)
    .2126 * r[1] + .7152 * r[2] + .0722 * r[3]
  }
  ratio <- function(c1, c2) {
    l <- sort(c(lum(c1), lum(c2)), decreasing = TRUE)
    (l[1] + .05) / (l[2] + .05)
  }

  ratios <- vapply(colors, ratio, numeric(1), c2 = background)
  pass   <- ratios >= threshold
  result <- data.frame(color = colors, contrast_ratio = round(ratios, 2), pass = pass,
                        stringsAsFactors = FALSE)

  cli::cli_h1("VVN Accessibility · WCAG {level} (threshold: {threshold}:1)")
  for (i in seq_len(nrow(result))) {
    r <- result[i, ]
    if (r$pass) cli::cli_alert_success("{r$color}  {r$contrast_ratio}:1  PASS")
    else        cli::cli_alert_danger( "{r$color}  {r$contrast_ratio}:1  FAIL")
  }
  n_fail <- sum(!pass)
  if (n_fail > 0) {
    cli::cli_alert_info(
      "{n_fail} color(s) fail. Try {.code vvn_palette('accessible')} for WCAG-safe colors."
    )
  }
  invisible(result)
}


# Internal helper
.require_shiny <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg shiny} is required.")
  }
}
