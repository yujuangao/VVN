# =============================================================================
# VVN ggplot2 Themes
# =============================================================================

#' VVN ggplot2 theme
#'
#' A clean, publication-quality ggplot2 theme with near-black titles, no axis
#' lines or ticks, light grid, and bottom legend. This is the single standard
#' theme for all VVN charts.
#'
#' @param base_size Base font size. Default `12`.
#' @param base_family Font family. Default `"sans"`.
#' @param grid One of `"y"` (horizontal only), `"x"`, `"both"`, `"none"`.
#'
#' @return A `ggplot2::theme` object.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(ggplot2::mpg, aes(class)) +
#'   geom_bar() +
#'   theme_vvn()
theme_vvn <- function(base_size = 12, base_family = "sans", grid = "y") {
  half  <- base_size / 2
  small <- base_size * 0.75

  grid_line <- ggplot2::element_line(colour = "#EBEBEB", linewidth = 0.4)
  no_line   <- ggplot2::element_blank()

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # ── Backgrounds ──────────────────────────────────────────────────
      plot.background  = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      panel.background = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),

      # ── Grid ─────────────────────────────────────────────────────────
      panel.grid.major.y = if (grid %in% c("y", "both")) grid_line else no_line,
      panel.grid.major.x = if (grid %in% c("x", "both")) grid_line else no_line,
      panel.grid.minor   = no_line,

      # ── Axes — no lines/ticks (clean minimal style) ──────────────────
      axis.line   = no_line,
      axis.ticks  = no_line,
      axis.text   = ggplot2::element_text(colour = "#333333", size = small),
      axis.title  = ggplot2::element_text(colour = "#333333", size = base_size * 0.85,
                                           margin = ggplot2::margin(4, 4, 4, 4)),

      # ── Titles — near-black for publication neutrality ─────────────
      plot.title    = ggplot2::element_text(
        colour = "#1A1A1A", size = base_size * 1.2, face = "bold",
        hjust  = 0, margin = ggplot2::margin(b = half)
      ),
      plot.subtitle = ggplot2::element_text(
        colour = "#555555", size = base_size * 0.9, hjust = 0,
        margin = ggplot2::margin(b = half)
      ),
      plot.caption  = ggplot2::element_text(
        colour = "#888888", size = base_size * 0.7, hjust = 0,
        margin = ggplot2::margin(t = half)
      ),
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.margin = ggplot2::margin(half, half, half, half),

      # ── Legend — bottom / horizontal ───────────────────────────────
      legend.position   = "bottom",
      legend.direction  = "horizontal",
      legend.title      = ggplot2::element_text(colour = "#333333", size = small,
                                                 face = "bold"),
      legend.text       = ggplot2::element_text(colour = "#333333", size = small),
      legend.key        = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      legend.background = ggplot2::element_blank(),
      legend.margin     = ggplot2::margin(t = 4),

      # ── Facets — neutral gray strips ───────────────────────────────
      strip.background = ggplot2::element_rect(fill = "#F0F0F0", colour = NA),
      strip.text       = ggplot2::element_text(
        colour = "#333333", face = "bold", size = base_size * 0.85,
        margin = ggplot2::margin(4, 6, 4, 6)
      )
    )
}


#' VVN map theme
#'
#' A stripped-back theme for choropleth / `geom_sf()` plots with a muted
#' basemap feel and horizontal legend at bottom.
#'
#' @inheritParams theme_vvn
#' @export
#'
#' @examples
#' # library(ggplot2); library(sf)
#' # ggplot(va_sf) + geom_sf(aes(fill = value)) +
#' #   scale_fill_vvn_c() + theme_vvn_map()
theme_vvn_map <- function(base_size = 11, base_family = "sans") {
  theme_vvn(base_size = base_size, base_family = base_family, grid = "none") +
    ggplot2::theme(
      panel.background = ggplot2::element_rect(fill = "#EAE6DC", colour = NA),
      axis.line        = ggplot2::element_blank(),
      axis.ticks       = ggplot2::element_blank(),
      axis.text        = ggplot2::element_blank(),
      axis.title       = ggplot2::element_blank(),
      legend.position  = "bottom",
      legend.direction = "horizontal",
      legend.key.width = ggplot2::unit(2, "cm"),
      legend.key.height = ggplot2::unit(0.35, "cm"),
      legend.title     = ggplot2::element_text(size = base_size * 0.8, colour = "#3D3D3D"),
      legend.text      = ggplot2::element_text(size = base_size * 0.7, colour = "#3D3D3D"),
      panel.grid       = ggplot2::element_blank()
    )
}


#' VVN Research Hub theme (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `theme_vvn_research()` is now identical to [theme_vvn()]. Use
#' `theme_vvn()` instead.
#'
#' @inheritParams theme_vvn
#' @export
theme_vvn_research <- function(base_size = 12, base_family = "sans", grid = "y") {
  .Deprecated("theme_vvn")
  theme_vvn(base_size = base_size, base_family = base_family, grid = grid)
}


#' VVN minimal theme (deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Use `theme_vvn(grid = "none")` instead.
#'
#' @inheritParams theme_vvn
#' @export
theme_vvn_minimal <- function(base_size = 12, base_family = "sans") {
  .Deprecated("theme_vvn")
  theme_vvn(base_size = base_size, base_family = base_family, grid = "none") +
    ggplot2::theme(
      axis.line  = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.text  = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank()
    )
}


#' Set VVN as the default ggplot2 theme
#'
#' Sets `theme_vvn()` as the active theme and updates default aesthetics for
#' all common geoms so that every subsequent `ggplot()` call automatically
#' uses VVN brand colors.
#'
#' @param style Deprecated. Ignored silently for backward compatibility.
#' @param base_size Passed to the theme.
#'
#' @return Invisibly `NULL`. Called for its side effects.
#' @export
#'
#' @examples
#' set_vvn_defaults()
#' ggplot2::ggplot(ggplot2::mpg, ggplot2::aes(displ, hwy)) +
#'   ggplot2::geom_point()   # automatically maroon points, VVN theme
#'
#' undo_vvn_defaults()       # revert when done
set_vvn_defaults <- function(style = NULL, base_size = 12) {
  ggplot2::theme_set(theme_vvn(base_size))

  # ── Geom defaults ────────────────────────────────────────────────────────
  .safe_geom_default("bar",      list(fill   = .VVN$maroon, colour = NA))
  .safe_geom_default("col",      list(fill   = .VVN$maroon, colour = NA))
  .safe_geom_default("line",     list(colour = .VVN$maroon, linewidth = 1))
  .safe_geom_default("path",     list(colour = .VVN$maroon, linewidth = 1))
  .safe_geom_default("point",    list(colour = .VVN$maroon, size = 2.5))
  .safe_geom_default("smooth",   list(colour = .VVN$orange, fill = .VVN$orange))
  .safe_geom_default("text",     list(colour = .VVN$charcoal, family = base_family_default()))
  .safe_geom_default("label",    list(colour = .VVN$charcoal, fill = .VVN$light_gray))
  .safe_geom_default("hline",    list(colour = .VVN$gray, linewidth = 0.5))
  .safe_geom_default("vline",    list(colour = .VVN$gray, linewidth = 0.5))
  .safe_geom_default("abline",   list(colour = .VVN$gray, linewidth = 0.5))
  .safe_geom_default("boxplot",  list(colour = .VVN$charcoal, fill = .VVN$maroon_lt))
  .safe_geom_default("violin",   list(colour = .VVN$charcoal, fill = .VVN$maroon_lt))
  .safe_geom_default("density",  list(colour = .VVN$maroon, fill = .VVN$maroon, alpha = 0.25))
  .safe_geom_default("area",     list(fill   = .VVN$maroon, alpha = 0.25, colour = NA))
  .safe_geom_default("ribbon",   list(fill   = .VVN$maroon, alpha = 0.25, colour = NA))
  .safe_geom_default("segment",  list(colour = .VVN$charcoal))
  .safe_geom_default("step",     list(colour = .VVN$maroon, linewidth = 1))
  .safe_geom_default("tile",     list(colour = .VVN$white))
  .safe_geom_default("sf",       list(fill   = .VVN$maroon_lt, colour = .VVN$white))

  options(vvn_defaults_set = TRUE)
  cli::cli_alert_success("VVN defaults set. Use {.fn undo_vvn_defaults} to revert.")
  invisible(NULL)
}


#' Revert to ggplot2 defaults
#'
#' Undoes `set_vvn_defaults()` and restores ggplot2 factory settings.
#'
#' @return Invisibly `NULL`.
#' @export
undo_vvn_defaults <- function() {
  ggplot2::theme_set(ggplot2::theme_gray())
  geoms <- c("bar","col","line","path","point","smooth","text","label",
             "hline","vline","abline","boxplot","violin","density","area",
             "ribbon","segment","step","tile","sf")
  for (g in geoms) {
    tryCatch(
      ggplot2::update_geom_defaults(g, ggplot2::GeomBar$default_aes[0]),
      error = function(e) NULL
    )
  }
  options(vvn_defaults_set = FALSE)
  cli::cli_alert_info("VVN defaults removed. ggplot2 factory settings restored.")
  invisible(NULL)
}

# Internal helpers -------------------------------------------------------
base_family_default <- function() "sans"

.safe_geom_default <- function(geom, defaults) {
  tryCatch(
    ggplot2::update_geom_defaults(geom, defaults),
    error = function(e) NULL
  )
}
