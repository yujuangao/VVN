# =============================================================================
# VVN Colors & Palettes
# Visualizing Virginia Numbers · Virginia Tech
# =============================================================================

# ── Internal color constants (not exported) ───────────────────────────────────

.VVN <- list(
  maroon     = "#861F41",
  maroon_dk  = "#520F25",
  maroon_lt  = "#F5C8D4",
  orange     = "#E5751F",
  orange_lt  = "#FDE8D4",
  navy       = "#1B5299",
  charcoal   = "#3D3D3D",
  gray       = "#AAAAAA",
  light_gray = "#F7F7F7",
  rule       = "#E0E0E0",
  white      = "#FFFFFF"
)

# Named palette lists
.VVN_PALETTES <- list(
  # ── Categorical ─────────────────────────────────────────────────────────
  main = c(
    "#861F41", "#E5751F", "#1B5299", "#2E7D32", "#7B1FA2",
    "#C05878", "#5B9BD5", "#F0964A", "#00838F", "#795548"
  ),
  brand = c("#861F41", "#E5751F", "#1B5299"),

  # ── Sequential ──────────────────────────────────────────────────────────
  maroon_seq = c("#F5C8D4", "#E09BB0", "#C86880", "#A03558", "#861F41", "#520F25"),
  orange_seq = c("#FDE8D4", "#FAC89A", "#F0964A", "#E5751F", "#B05010", "#703008"),
  navy_seq   = c("#D0E0F5", "#A0C0E8", "#6090CC", "#3060AA", "#1B5299", "#0A2A66"),

  # ── Diverging ────────────────────────────────────────────────────────────
  diverging = c("#1B5299", "#5B9BD5", "#AED0F0", "#F4F4F4",
                "#F5C8D4", "#C05878", "#861F41"),

  # ── Colorblind-friendly (Okabe-Ito) ─────────────────────────────────────
  accessible = c("#0077BB", "#EE7733", "#009988", "#CC3311",
                 "#33BBEE", "#EE3377", "#BBBBBB"),

  # ── Monochrome ──────────────────────────────────────────────────────────
  gray_seq = c("#F7F7F7", "#DDDDDD", "#BBBBBB", "#888888", "#555555", "#222222")
)


# ── Public API ────────────────────────────────────────────────────────────────

#' Return VVN brand colors
#'
#' Retrieve one or more named VVN brand colors as a named character vector.
#'
#' @param ... Color names to retrieve. If none provided, returns all colors.
#'   Valid names: `"maroon"`, `"orange"`, `"navy"`, `"charcoal"`, `"gray"`,
#'   `"light_gray"`, `"white"`, `"maroon_dk"`, `"maroon_lt"`, `"orange_lt"`.
#'
#' @return A named character vector of hex color codes.
#' @export
#'
#' @examples
#' vvn_colors()
#' vvn_colors("maroon")
#' vvn_colors("maroon", "orange", "navy")
vvn_colors <- function(...) {
  all_cols <- c(
    maroon     = "#861F41",
    orange     = "#E5751F",
    navy       = "#1B5299",
    charcoal   = "#3D3D3D",
    gray       = "#AAAAAA",
    light_gray = "#F7F7F7",
    white      = "#FFFFFF",
    maroon_dk  = "#520F25",
    maroon_lt  = "#F5C8D4",
    orange_lt  = "#FDE8D4"
  )
  req <- c(...)
  if (length(req) == 0L) return(all_cols)
  bad <- setdiff(req, names(all_cols))
  if (length(bad)) {
    cli::cli_alert_warning("Unknown VVN color(s): {.val {bad}}")
  }
  all_cols[req]
}


#' VVN color palette generator
#'
#' Returns a vector of colors from a named VVN palette. Sequential and
#' diverging palettes are interpolated when `n` exceeds the base palette size.
#'
#' @param palette Palette name. One of:
#'   - Categorical: `"main"` (10 colors), `"brand"` (3 colors)
#'   - Sequential: `"maroon_seq"`, `"orange_seq"`, `"navy_seq"`
#'   - Diverging: `"diverging"`
#'   - Accessibility: `"accessible"` (Okabe-Ito inspired)
#'   - Neutral: `"gray_seq"`
#' @param n Number of colors. `NULL` returns all base colors.
#' @param reverse Reverse the palette? Default `FALSE`.
#' @param alpha Opacity (0–1). Default `1`.
#'
#' @return A character vector of hex color codes.
#' @export
#'
#' @examples
#' vvn_palette()                          # all "main" colors
#' vvn_palette("brand")                   # maroon, orange, navy
#' vvn_palette("maroon_seq", n = 9)       # 9-step sequential
#' vvn_palette("diverging", n = 11)
#' vvn_palette("accessible")
vvn_palette <- function(palette = "main", n = NULL, reverse = FALSE, alpha = 1) {
  if (!palette %in% names(.VVN_PALETTES)) {
    cli::cli_abort(c(
      "Unknown palette {.val {palette}}.",
      "i" = "Available: {.val {names(.VVN_PALETTES)}}"
    ))
  }
  base <- .VVN_PALETTES[[palette]]
  if (reverse) base <- rev(base)
  n_out <- if (is.null(n)) length(base) else as.integer(n)
  cols  <- if (n_out <= length(base)) {
    base[seq_len(n_out)]
  } else {
    grDevices::colorRampPalette(base)(n_out)
  }
  if (alpha < 1) cols <- scales::alpha(cols, alpha)
  cols
}


#' View a VVN color palette
#'
#' Displays a horizontal swatch strip for the chosen VVN palette, built with
#' ggplot2 so it can be saved with `vvn_save()`.
#'
#' @param palette Palette name (see [vvn_palette()]).
#' @param n Number of colors to show. Default: all base colors.
#' @param label Show hex codes on swatches? Default `TRUE`.
#' @param title Plot title. Default: palette name.
#'
#' @return A `ggplot` object (printed invisibly).
#' @export
#'
#' @examples
#' view_vvn_palette()
#' view_vvn_palette("diverging", n = 9)
#' view_vvn_palette("accessible")
view_vvn_palette <- function(palette = "main",
                              n       = NULL,
                              label   = TRUE,
                              title   = NULL) {
  cols <- vvn_palette(palette, n = n)
  n_c  <- length(cols)
  ttl  <- title %||% paste0('vvn_palette("', palette, '")')

  df <- data.frame(
    x     = seq_len(n_c),
    color = cols,
    stringsAsFactors = FALSE
  )
  # Choose label color (white on dark, dark on light)
  lum <- vapply(cols, function(h) {
    rgb <- grDevices::col2rgb(h) / 255
    rgb <- ifelse(rgb <= .04045, rgb/12.92, ((rgb+.055)/1.055)^2.4)
    .2126*rgb[1] + .7152*rgb[2] + .0722*rgb[3]
  }, numeric(1))
  df$label_col <- ifelse(lum > 0.4, .VVN$charcoal, .VVN$white)

  p <- ggplot2::ggplot(df, ggplot2::aes(x = x, y = 1)) +
    ggplot2::geom_tile(ggplot2::aes(fill = I(color)), width = 0.96, height = 0.7) +
    ggplot2::geom_text(
      ggplot2::aes(label = if (label) color else "", color = I(label_col)),
      size = 3, angle = 0, vjust = 0.5, fontface = "bold"
    ) +
    ggplot2::scale_x_continuous(breaks = seq_len(n_c), labels = seq_len(n_c),
                                 expand = ggplot2::expansion(add = 0.3)) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(add = 0.2)) +
    ggplot2::labs(title = ttl, x = NULL, y = NULL) +
    ggplot2::theme_void(base_size = 11) +
    ggplot2::theme(
      plot.title     = ggplot2::element_text(colour = .VVN$maroon, face = "bold",
                                              size = 13, hjust = 0.5, margin = ggplot2::margin(b = 8)),
      plot.background = ggplot2::element_rect(fill = .VVN$white, colour = NA),
      axis.text.x    = ggplot2::element_text(colour = .VVN$charcoal, size = 8),
      plot.margin    = ggplot2::margin(12, 12, 12, 12)
    )
  print(p)
  invisible(p)
}

# Null-coalescing operator (internal)
`%||%` <- function(x, y) if (!is.null(x)) x else y
