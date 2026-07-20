# =============================================================================
# VVN Colors & Palettes
# Visualizing Virginia's Numbers · Virginia Tech
# Source: brand.vt.edu/identity/color.html
# =============================================================================

# Suppress R CMD check notes for ggplot2 aesthetic variables
utils::globalVariables(c("x", "color", "label_col"))

# ── Internal color constants (not exported) ───────────────────────────────────

.VVN <- list(

  # ── VT Primary Palette (brand.vt.edu) ─────────────────────────────────────
  # Chicago Maroon  CSS: --vt-maroon        HEX: #861F41
  # Burnt Orange    CSS: --vt-burntOrange   HEX: #E5751F  (print / chart)
  # Hokie Stone     CSS: --vt-hokieStone    HEX: #75787B
  # Yardline White  CSS: --vt-white         HEX: #FFFFFF
  # Impact Orange   CSS: --vt-impactOrange  HEX: #CA4F00  (digital text / UI)
  maroon         = "#861F41",
  maroon_dk      = "#520F25",
  maroon_lt      = "#F5C8D4",
  orange         = "#E5751F",   # Burnt Orange — print / chart
  orange_lt      = "#FDE8D4",
  hokie_stone    = "#75787B",   # Hokie Stone (CSS: --vt-hokieStone)
  impact_orange  = "#CA4F00",   # Impact Orange — digital text & UI accent
  white          = "#FFFFFF",

  # ── VT Secondary Palette (brand.vt.edu) ───────────────────────────────────
  # CSS variables: --vt-purple, --vt-pink, --vt-yellow, --vt-teal,
  #                --vt-turquoise, --vt-grey, --vt-smoke, --vt-impactOrange
  purple     = "#642667",   # Pylon Purple
  pink       = "#CE0058",   # Boundless Pink
  yellow     = "#F7EA48",   # Triumphant Yellow
  teal       = "#508590",   # Sustainable Teal
  turquoise  = "#2CD5C4",   # Vibrant Turquoise
  land_grey  = "#D7D2CB",   # Land Grant Grey
  smoke      = "#E5E1E6",   # Skipper Smoke

  # ── Non-official utility colors (kept for chart/palette use) ──────────────
  navy       = "#1B5299",   # Not in VT palette; used in diverging scales
  charcoal   = "#3D3D3D",   # Body text
  gray       = "#AAAAAA",
  light_gray = "#F7F7F7",
  rule       = "#E0E0E0",

  # ── UI / website chrome ───────────────────────────────────────────────────
  ui_nav_bg    = "#FFFFFF",
  ui_page_bg   = "#F3F4F7",
  ui_footer    = "#222C3D",
  ui_text      = "#1A1A1A",
  ui_text_2    = "#3F4650",
  ui_card_bg   = "#FFFFFF",
  ui_card_bdr  = "#D9D9D9",
  ui_btn_bdr   = "#D5D5D5",
  ui_footer_div= "#8C939C",
  ui_orange    = "#CA4F00",   # Impact Orange (CSS: --vt-impactOrange)
  ui_launch    = "#8A2045"    # Dark maroon for CTA buttons
)

# ── Named palette lists ───────────────────────────────────────────────────────

.VVN_PALETTES <- list(

  # ── VT Primary — categorical ──────────────────────────────────────────────
  # Six-color palette drawn entirely from official VT brand colors.
  # Uses primary palette (maroon, burnt orange, hokie stone) +
  # three secondary colors (purple, teal, land grey) for variety.
  # Source: brand.vt.edu/identity/color.html
  vt = c(
    "#861F41",  # Chicago Maroon   (primary)
    "#CA4F00",  # Impact Orange    (primary digital)
    "#642667",  # Pylon Purple     (secondary)
    "#508590",  # Sustainable Teal (secondary)
    "#75787B",  # Hokie Stone      (primary)
    "#D7D2CB"   # Land Grant Grey  (secondary)
  ),

  # ── VT Secondary — all 8 official secondary colors ────────────────────────
  # Complete secondary palette from brand.vt.edu.
  # Use sparingly; for accent and supplemental data series.
  vt_secondary = c(
    "#642667",  # Pylon Purple
    "#CE0058",  # Boundless Pink
    "#F7EA48",  # Triumphant Yellow
    "#508590",  # Sustainable Teal
    "#2CD5C4",  # Vibrant Turquoise
    "#D7D2CB",  # Land Grant Grey
    "#E5E1E6",  # Skipper Smoke
    "#CA4F00"   # Impact Orange
  ),

  # ── Brand — 3-color primary brand triad ──────────────────────────────────
  # Chicago Maroon + Burnt Orange (print) + Hokie Stone.
  # For charts where 3 groups need clear VT identity.
  brand = c("#861F41", "#E5751F", "#75787B"),

  # ── General-purpose categorical ───────────────────────────────────────────
  main = c(
    "#861F41", "#E5751F", "#1B5299", "#2E7D32", "#7B1FA2",
    "#C05878", "#5B9BD5", "#F0964A", "#00838F", "#795548"
  ),

  # ── Sequential ────────────────────────────────────────────────────────────
  maroon_seq     = c("#F5C8D4", "#E09BB0", "#C86880", "#A03558", "#861F41", "#520F25"),
  orange_seq     = c("#FDE8D4", "#FAC89A", "#F0964A", "#E5751F", "#B05010", "#703008"),
  navy_seq       = c("#D0E0F5", "#A0C0E8", "#6090CC", "#3060AA", "#1B5299", "#0A2A66"),
  hokie_stone_seq = c("#F2F2F2", "#D7D2CB", "#B5B0AB", "#8E8C89", "#75787B", "#4A4D50"),

  # ── Diverging (navy–white–maroon, 7 fixed stops) ──────────────────────────
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
  monet = c(
    "#A8C5D9",  # sky blue
    "#B9CBAE",  # sage green
    "#7FA7A6",  # deep teal
    "#F3F1E6",  # cream / warm neutral
    "#C7D5E3"   # soft periwinkle
  ),

  # ── Van Gogh Sunflowers ───────────────────────────────────────────────────
  sunflower = c(
    "#F2C94C",  # sunflower yellow
    "#1E4E8C",  # cobalt blue
    "#D4A04A",  # warm gold
    "#8A9B5B",  # olive green
    "#F7F4E7"   # warm parchment
  ),

  # ── Academic Deep Blue ────────────────────────────────────────────────────
  academic = c(
    "#0D1B3D",  # deep navy
    "#385C8E",  # slate blue
    "#BFC7D5",  # blue-gray
    "#E8ECF4",  # pale ice blue
    "#F28E2B"   # warm amber
  ),

  # ── Natural Muted ─────────────────────────────────────────────────────────
  natural = c(
    "#A6B89A",  # sage green
    "#8CA3B7",  # muted slate blue
    "#DCCDB4",  # warm linen
    "#333333",  # near-black
    "#F7F7F5"   # warm off-white
  )
)

# ── Diverging control points (internal) ──────────────────────────────────────
# Each entry: [pole A, neutral midpoint, pole B].
# vvn_palette() interpolates these to n colors via colorRampPalette().

.VVN_DIV <- list(

  # ── VT Brand diverging ────────────────────────────────────────────────────
  # Classic VT diverging: VT Maroon ↔ white ↔ Navy (utility, not official VT)
  vt_div        = c("#861F41", "#F4F4F4", "#1B5299"),
  # Impact Orange (digital) ↔ light cream ↔ VT Maroon
  # Uses official #CA4F00 (--vt-impactOrange) as the warm pole.
  vt_orange_div = c("#CA4F00", "#FDE8D4", "#861F41"),

  # ── Artistic theme diverging ──────────────────────────────────────────────
  monet_div     = c("#A8C5D9", "#F3F1E6", "#7FA7A6"),
  sunflower_div = c("#1E4E8C", "#F7F4E7", "#F2C94C"),
  academic_div  = c("#0D1B3D", "#BFC7D5", "#F28E2B"),
  natural_div   = c("#333333", "#F7F7F5", "#A6B89A")
)


# ── Public API ────────────────────────────────────────────────────────────────

#' Return VVN / VT brand colors
#'
#' Retrieve one or more named VVN brand colors as a named character vector.
#' Colors include all official VT primary and secondary palette entries from
#' \url{https://brand.vt.edu/identity/color.html}.
#'
#' @param ... Color names to retrieve. If none provided, returns all colors.
#'   **Primary:** `"maroon"`, `"orange"`, `"hokie_stone"`, `"white"`,
#'   `"impact_orange"`, `"maroon_dk"`, `"maroon_lt"`, `"orange_lt"`.
#'   **Secondary:** `"purple"`, `"pink"`, `"yellow"`, `"teal"`,
#'   `"turquoise"`, `"land_grey"`, `"smoke"`.
#'   **Utility:** `"navy"`, `"charcoal"`, `"gray"`, `"light_gray"`.
#'
#' @return A named character vector of hex color codes.
#' @export
#'
#' @examples
#' vvn_colors()
#' vvn_colors("maroon")
#' vvn_colors("maroon", "orange", "hokie_stone")
#' vvn_colors("teal", "purple", "pink")
vvn_colors <- function(...) {
  all_cols <- c(
    # VT Primary
    maroon        = "#861F41",
    orange        = "#E5751F",   # Burnt Orange (print / chart)
    hokie_stone   = "#75787B",
    white         = "#FFFFFF",
    impact_orange = "#CA4F00",   # Impact Orange (digital text / UI)
    maroon_dk     = "#520F25",
    maroon_lt     = "#F5C8D4",
    orange_lt     = "#FDE8D4",
    # VT Secondary
    purple        = "#642667",   # Pylon Purple
    pink          = "#CE0058",   # Boundless Pink
    yellow        = "#F7EA48",   # Triumphant Yellow
    teal          = "#508590",   # Sustainable Teal
    turquoise     = "#2CD5C4",   # Vibrant Turquoise
    land_grey     = "#D7D2CB",   # Land Grant Grey
    smoke         = "#E5E1E6",   # Skipper Smoke
    # Utility (not official VT; retained for chart use)
    navy          = "#1B5299",
    charcoal      = "#3D3D3D",
    gray          = "#AAAAAA",
    light_gray    = "#F7F7F7"
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
#'   **VT Brand (official):**
#'   - `"vt"` — 6-color palette using official VT primary + secondary colors
#'   - `"vt_secondary"` — all 8 VT secondary palette colors
#'   - `"brand"` — 3-color primary triad (maroon, burnt orange, hokie stone)
#'   - `"main"` — 10-color general purpose
#'
#'   **Sequential:** `"maroon_seq"`, `"orange_seq"`, `"navy_seq"`,
#'   `"hokie_stone_seq"`, `"gray_seq"`
#'
#'   **Diverging (standard):** `"diverging"` (navy–white–maroon, 7 fixed colors)
#'
#'   **Colorblind-safe:** `"accessible"` (Okabe-Ito), `"wcag"` (all \eqn{\ge}4.5:1)
#'
#'   **VT brand diverging (interpolated to any n):**
#'   - `"vt_div"` — VT Maroon \eqn{\leftrightarrow} white \eqn{\leftrightarrow} Navy
#'   - `"vt_orange_div"` — Impact Orange (#CA4F00) \eqn{\leftrightarrow} cream \eqn{\leftrightarrow} VT Maroon
#'
#'   **Artistic themes (categorical):**
#'   - `"monet"`, `"sunflower"`, `"academic"`, `"natural"`
#'
#'   **Artistic themes (diverging):**
#'   - `"monet_div"`, `"sunflower_div"`, `"academic_div"`, `"natural_div"`
#'
#' @param n Number of colors to return. `NULL` returns all base colors.
#'   For diverging palettes (`_div`), defaults to 7.
#' @param reverse Reverse the palette? Default `FALSE`.
#' @param alpha Opacity (0–1). Default `1`.
#' @param pick Integer index to select a single color from the palette.
#'   Overrides `n`.
#'
#' @return A character vector of hex color codes (length 1 when `pick` is set).
#' @export
#'
#' @examples
#' vvn_palette()                          # all "main" colors
#' vvn_palette("vt")                      # VT brand categorical (6 colors)
#' vvn_palette("vt_secondary")            # all 8 VT secondary colors
#' vvn_palette("brand")                   # maroon, burnt orange, hokie stone
#' vvn_palette("hokie_stone_seq", n = 8)  # 8-step Hokie Stone sequential
#' vvn_palette("vt_div", n = 9)           # 9-step VT maroon–white–navy diverging
#' vvn_palette("vt_orange_div", n = 7)    # 7-step impact orange–cream–maroon
#' vvn_palette("monet")                   # Monet Pond theme
#' vvn_palette("maroon_seq", n = 9)       # 9-step sequential
vvn_palette <- function(palette = "main", n = NULL, reverse = FALSE,
                        alpha = 1, pick = NULL) {

  all_names <- c(names(.VVN_PALETTES), names(.VVN_DIV))

  if (!palette %in% all_names) {
    cli::cli_abort(c(
      "Unknown palette {.val {palette}}.",
      "i" = "VT brand: {.val {c('vt','vt_secondary','brand','main')}}",
      "i" = "Sequential: {.val {c('maroon_seq','orange_seq','navy_seq','hokie_stone_seq','gray_seq')}}",
      "i" = "Diverging: {.val {c('diverging','vt_div','vt_orange_div','monet_div','sunflower_div','academic_div','natural_div')}}",
      "i" = "Artistic: {.val {c('monet','sunflower','academic','natural')}}",
      "i" = "Accessible: {.val {c('accessible','wcag')}}"
    ))
  }

  # ── Diverging palettes — interpolate from 3-point control ─────────────────
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
#' view_vvn_palette("vt")
#' view_vvn_palette("vt_secondary")
#' view_vvn_palette("hokie_stone_seq", n = 8)
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
      plot.title      = ggplot2::element_text(colour = .VVN$maroon, face = "bold",
                                               size = 13, hjust = 0.5,
                                               margin = ggplot2::margin(b = 8)),
      plot.background = ggplot2::element_rect(fill = .VVN$white, colour = NA),
      axis.text.x     = ggplot2::element_text(colour = .VVN$charcoal, size = 8),
      plot.margin     = ggplot2::margin(12, 12, 12, 12)
    )
  print(p)
  invisible(p)
}

# Null-coalescing operator (internal)
`%||%` <- function(x, y) if (!is.null(x)) x else y
