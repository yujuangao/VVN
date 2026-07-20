# =============================================================================
# VVN Colors & Palettes
# Visualizing Virginia Numbers · Virginia Tech
# =============================================================================

# Suppress R CMD check notes for ggplot2 aesthetic variables
utils::globalVariables(c("x", "color", "label_col"))

# ── Internal color constants (not exported) ───────────────────────────────────

.VVN <- list(
  # ── Chart / brand colors ──────────────────────────────────────────────────
  maroon     = "#861F41",
  maroon_dk  = "#520F25",
  maroon_lt  = "#F5C8D4",
  orange     = "#E5751F",   # print/chart orange
  orange_lt  = "#FDE8D4",
  navy       = "#1B5299",
  charcoal   = "#3D3D3D",
  gray       = "#AAAAAA",
  light_gray = "#F7F7F7",
  rule       = "#E0E0E0",
  white      = "#FFFFFF",

  # ── UI / website chrome colors (new design system) ────────────────────────
  ui_nav_bg    = "#FFFFFF",   # top navigation background
  ui_page_bg   = "#F3F4F7",   # page background
  ui_footer    = "#222C3D",   # footer & breadcrumb bar
  ui_text      = "#1A1A1A",   # main text
  ui_text_2    = "#3F4650",   # secondary text
  ui_card_bg   = "#FFFFFF",   # card background
  ui_card_bdr  = "#D9D9D9",   # card border
  ui_btn_bdr   = "#D5D5D5",   # button border
  ui_footer_div= "#8C939C",   # footer divider
  ui_orange    = "#E87722",   # UI accent orange (Impact Orange — digital)
  ui_launch    = "#8A2045"    # dark maroon for launch / primary CTA buttons
)

# ── Named palette lists ───────────────────────────────────────────────────────

.VVN_PALETTES <- list(

  # ── VT Brand — categorical ────────────────────────────────────────────────
  # Official Virginia Tech brand colors for data visualizations.
  # Source: brand.vt.edu
  vt = c(
    "#861F41",  # VT Maroon
    "#E87722",  # Impact Orange (digital screen)
    "#1B5299",  # Navy Blue
    "#4B6734",  # Forest Green
    "#75757A",  # Hokie Stone
    "#CEB893"   # Sand / Wheat
  ),

  # ── General-purpose categorical ───────────────────────────────────────────
  main = c(
    "#861F41", "#E5751F", "#1B5299", "#2E7D32", "#7B1FA2",
    "#C05878", "#5B9BD5", "#F0964A", "#00838F", "#795548"
  ),
  brand = c("#861F41", "#E5751F", "#1B5299"),

  # ── Sequential ────────────────────────────────────────────────────────────
  maroon_seq = c("#F5C8D4", "#E09BB0", "#C86880", "#A03558", "#861F41", "#520F25"),
  orange_seq = c("#FDE8D4", "#FAC89A", "#F0964A", "#E5751F", "#B05010", "#703008"),
  navy_seq   = c("#D0E0F5", "#A0C0E8", "#6090CC", "#3060AA", "#1B5299", "#0A2A66"),

  # ── Diverging (navy–white–maroon) ─────────────────────────────────────────
  diverging = c("#1B5299", "#5B9BD5", "#AED0F0", "#F4F4F4",
                "#F5C8D4", "#C05878", "#861F41"),

  # ── Colorblind-friendly (Okabe-Ito) ──────────────────────────────────────
  accessible = c("#0077BB", "#EE7733", "#009988", "#CC3311",
                 "#33BBEE", "#EE3377", "#BBBBBB"),

  # ── WCAG AA compliant (all ≥ 4.5:1 on white) ─────────────────────────────
  wcag = c("#861F41", "#1B5299", "#0077BB", "#CC3311", "#117733", "#5C3893"),

  # ── Monochrome ────────────────────────────────────────────────────────────
  gray_seq = c("#F7F7F7", "#DDDDDD", "#BBBBBB", "#888888", "#555555", "#222222"),

  # ─────────────────────────────────────────────────────────────────────────
  # ── ARTISTIC THEMES ──────────────────────────────────────────────────────
  # ─────────────────────────────────────────────────────────────────────────

  # ── Monet Pond ────────────────────────────────────────────────────────────
  # Inspired by Monet's Water Lilies series. Cool blues and greens with a
  # warm cream that evokes impressionistic light on water.
  monet = c(
    "#A8C5D9",  # sky blue
    "#B9CBAE",  # sage green
    "#7FA7A6",  # deep teal
    "#F3F1E6",  # cream / warm neutral
    "#C7D5E3"   # soft periwinkle
  ),

  # ── Van Gogh Sunflowers ───────────────────────────────────────────────────
  # Inspired by Van Gogh's Sunflowers. Deep cobalt blue grounds warm yellow
  # and gold tones, with earthy olive green.
  sunflower = c(
    "#F2C94C",  # sunflower yellow
    "#1E4E8C",  # cobalt blue
    "#D4A04A",  # warm gold
    "#8A9B5B",  # olive green
    "#F7F4E7"   # warm parchment
  ),

  # ── Academic Deep Blue ────────────────────────────────────────────────────
  # A scholarly navy-to-orange palette. Evokes academic publishing,
  # journal covers, and institutional graphics.
  academic = c(
    "#0D1B3D",  # deep navy
    "#385C8E",  # slate blue
    "#BFC7D5",  # blue-gray
    "#E8ECF4",  # pale ice blue (near-white, stays visible on white bg)
    "#F28E2B"   # warm amber / burnt orange
  ),

  # ── Natural Muted ─────────────────────────────────────────────────────────
  # Earthy, understated tones — sage, slate, linen — for environmental,
  # agricultural, or sustainability topics.
  natural = c(
    "#A6B89A",  # sage green
    "#8CA3B7",  # muted slate blue
    "#DCCDB4",  # warm linen
    "#333333",  # near-black
    "#F7F7F5"   # warm off-white
  )

  # Note: Diverging variants for artistic themes are generated dynamically
  # in vvn_palette() — use palette = "monet_div", "sunflower_div", etc.
)

# ── Diverging control points (internal) ──────────────────────────────────────
# Each entry is a 3-element vector: [pole A, neutral midpoint, pole B].
# vvn_palette() interpolates these to n colors using colorRampPalette().

.VVN_DIV <- list(

  # ── VT Brand diverging ────────────────────────────────────────────────────
  # Classic VT brand diverging: maroon ↔ neutral white ↔ navy
  vt_div        = c("#861F41", "#F4F4F4", "#1B5299"),
  # Orange-accented diverging: Impact Orange ↔ cream ↔ VT Maroon
  vt_orange_div = c("#E87722", "#FDE8D4", "#861F41"),

  # ── Artistic theme diverging ──────────────────────────────────────────────
  monet_div     = c("#A8C5D9", "#F3F1E6", "#7FA7A6"),
  sunflower_div = c("#1E4E8C", "#F7F4E7", "#F2C94C"),
  academic_div  = c("#0D1B3D", "#BFC7D5", "#F28E2B"),
  natural_div   = c("#333333", "#F7F7F5", "#A6B89A")
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
#' Use `pick` to extract a single color by position.
#'
#' @param palette Palette name. One of:
#'   **VT Brand:**
#'   - `"vt"` — 6-color VT brand palette (maroon, orange, navy, forest, stone, sand)
#'   - `"brand"` — 3-color brand (maroon, orange, navy)
#'   - `"main"` — 10-color general purpose
#'
#'   **Sequential:** `"maroon_seq"`, `"orange_seq"`, `"navy_seq"`, `"gray_seq"`
#'
#'   **Diverging (standard):** `"diverging"` (navy–white–maroon, 7 fixed colors)
#'
#'   **Colorblind-safe:** `"accessible"` (Okabe-Ito), `"wcag"` (all ≥ 4.5:1)
#'
#'   **VT brand diverging (interpolated to any n):**
#'   - `"vt_div"` — VT Maroon ↔ white ↔ Navy (classic VT)
#'   - `"vt_orange_div"` — Impact Orange ↔ cream ↔ VT Maroon
#'
#'   **Artistic themes (categorical):**
#'   - `"monet"` — Monet Pond: cool blues and sage greens
#'   - `"sunflower"` — Van Gogh Sunflowers: cobalt + gold
#'   - `"academic"` — Academic Deep Blue: navy + amber
#'   - `"natural"` — Natural Muted: sage, slate, linen
#'
#'   **Artistic themes (diverging — interpolated to any n):**
#'   - `"monet_div"` — sky blue ↔ cream ↔ deep teal
#'   - `"sunflower_div"` — cobalt ↔ parchment ↔ sunflower yellow
#'   - `"academic_div"` — deep navy ↔ blue-gray ↔ amber
#'   - `"natural_div"` — near-black ↔ off-white ↔ sage green
#'
#' @param n Number of colors to return. `NULL` returns all base colors.
#'   For diverging palettes (`_div`), defaults to 7.
#' @param reverse Reverse the palette? Default `FALSE`.
#' @param alpha Opacity (0–1). Default `1`.
#' @param pick Integer index to select a single color from the palette.
#'   E.g. `pick = 2` returns the 2nd color. Overrides `n`.
#'
#' @return A character vector of hex color codes (length 1 when `pick` is set).
#' @export
#'
#' @examples
#' vvn_palette()                          # all "main" colors
#' vvn_palette("vt")                      # VT brand categorical (6 colors)
#' vvn_palette("vt_div", n = 9)          # 9-step VT maroon-white-navy diverging
#' vvn_palette("vt_orange_div", n = 7)   # 7-step VT orange-cream-maroon diverging
#' vvn_palette("monet")                   # Monet Pond theme
#' vvn_palette("monet", pick = 3)         # 3rd Monet color (#7FA7A6 teal)
#' vvn_palette("sunflower_div", n = 9)    # 9-step diverging from sunflower
#' vvn_palette("brand")                   # maroon, orange, navy
#' vvn_palette("maroon_seq", n = 9)       # 9-step sequential
vvn_palette <- function(palette = "main", n = NULL, reverse = FALSE,
                        alpha = 1, pick = NULL) {

  all_names <- c(names(.VVN_PALETTES), names(.VVN_DIV))

  if (!palette %in% all_names) {
    cli::cli_abort(c(
      "Unknown palette {.val {palette}}.",
      "i" = "VT brand: {.val {c('vt','brand','main')}}",
      "i" = "Sequential: {.val {c('maroon_seq','orange_seq','navy_seq','gray_seq')}}",
      "i" = "Diverging: {.val {c('diverging','monet_div','sunflower_div','academic_div','natural_div')}}",
      "i" = "Artistic: {.val {c('monet','sunflower','academic','natural')}}",
      "i" = "Accessible: {.val {c('accessible','wcag')}}"
    ))
  }

  # ── Artistic diverging palettes — generate from 3-point control ───────────
  if (palette %in% names(.VVN_DIV)) {
    ctrl  <- .VVN_DIV[[palette]]
    n_out <- if (is.null(n)) 7L else as.integer(n)
    if (reverse) ctrl <- rev(ctrl)
    cols  <- grDevices::colorRampPalette(ctrl)(n_out)
    if (!is.null(pick)) return(cols[pick])
    if (alpha < 1) cols <- scales::alpha(cols, alpha)
    return(cols)
  }

  # ── Standard palettes ─────────────────────────────────────────────────────
  base  <- .VVN_PALETTES[[palette]]
  if (reverse) base <- rev(base)
  n_out <- if (is.null(n)) length(base) else as.integer(n)
  cols  <- if (n_out <= length(base)) {
    base[seq_len(n_out)]
  } else {
    grDevices::colorRampPalette(base)(n_out)
  }

  # ── Single-color pick ─────────────────────────────────────────────────────
  if (!is.null(pick)) return(cols[pick])

  if (alpha < 1) cols <- scales::alpha(cols, alpha)
  cols
}


#' View a VVN color palette
#'
#' Displays a horizontal swatch strip for the chosen VVN palette, built with
#' ggplot2 so it can be saved with `vvn_save()`.
#'
#' @param palette Palette name (see [vvn_palette()]).
#' @param n Number of colors to show. Default: all base colors (7 for `_div`).
#' @param label Show hex codes on swatches? Default `TRUE`.
#' @param title Plot title. Default: palette name.
#'
#' @return A `ggplot` object (printed invisibly).
#' @export
#'
#' @examples
#' view_vvn_palette()
#' view_vvn_palette("monet")
#' view_vvn_palette("sunflower_div", n = 9)
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
