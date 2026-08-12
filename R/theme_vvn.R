# =============================================================================
# VVN ggplot2 Themes
# =============================================================================

#' VVN ggplot2 theme (standard charts)
#'
#' A clean, accessible ggplot2 theme using VT Maroon titles, light grid lines,
#' and open axis styling. Mirrors the design philosophy of `theme_urbn_print()`.
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

  grid_line <- ggplot2::element_line(colour = "#E0E0E0", linewidth = 0.4)
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

      # ── Axes ─────────────────────────────────────────────────────────
      axis.line   = ggplot2::element_line(colour = "#E0E0E0", linewidth = 0.5),
      axis.ticks  = ggplot2::element_line(colour = "#CCCCCC", linewidth = 0.4),
      axis.text   = ggplot2::element_text(colour = "#3D3D3D", size = small),
      axis.title  = ggplot2::element_text(colour = "#3D3D3D", size = base_size * 0.85,
                                           margin = ggplot2::margin(4, 4, 4, 4)),

      # ── Titles ───────────────────────────────────────────────────────
      plot.title    = ggplot2::element_text(
        colour = "#861F41", size = base_size * 1.25, face = "bold",
        hjust  = 0, margin = ggplot2::margin(b = half)
      ),
      plot.subtitle = ggplot2::element_text(
        colour = "#3D3D3D", size = base_size * 0.9, hjust = 0,
        margin = ggplot2::margin(b = half)
      ),
      plot.caption  = ggplot2::element_text(
        colour = "#AAAAAA", size = base_size * 0.7, hjust = 1,
        margin = ggplot2::margin(t = half)
      ),
      plot.title.position   = "plot",
      plot.caption.position = "plot",
      plot.margin = ggplot2::margin(half, half, half, half),

      # ── Legend ───────────────────────────────────────────────────────
      legend.position   = "right",
      legend.title      = ggplot2::element_text(colour = "#3D3D3D", size = small,
                                                 face = "bold"),
      legend.text       = ggplot2::element_text(colour = "#3D3D3D", size = small),
      legend.key        = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      legend.background = ggplot2::element_blank(),

      # ── Facets ───────────────────────────────────────────────────────
      strip.background = ggplot2::element_rect(fill = "#861F41", colour = NA),
      strip.text       = ggplot2::element_text(
        colour = "#FFFFFF", face = "bold", size = base_size * 0.85,
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


#' VVN Research Hub theme
#'
#' A clean, academic publication-quality ggplot2 theme inspired by the design
#' of research data-blog sites (e.g., the DHS Research Hub at
#' \url{https://tech.popdata.org/dhs-research-hub/}).
#'
#' Key differences from `theme_vvn()`:
#' \itemize{
#'   \item Near-black (`#1A1A1A`) titles instead of VT Maroon — neutral /
#'         publication-ready.
#'   \item No axis lines or ticks — pure grid-only minimal look.
#'   \item Legend defaults to **bottom / horizontal** for easier reading.
#'   \item Left-aligned caption (matching blog conventions).
#'   \item Neutral gray facet strips (not VT Maroon).
#'   \item Grid lines are slightly lighter (`#EBEBEB`) for a softer feel.
#' }
#'
#' Pairs naturally with the `"forest"` and `"forest_div"` palettes for
#' environmental / land-cover research visualizations.
#'
#' @inheritParams theme_vvn
#'
#' @return A `ggplot2::theme` object.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(ggplot2::mpg, aes(displ, hwy, colour = class)) +
#'   geom_point() +
#'   theme_vvn_research()
#'
#' # Environmental / deforestation-style map
#' # ggplot(forest_sf, aes(fill = pct_change)) +
#' #   geom_sf(colour = NA) +
#' #   scale_fill_vvn_c("forest_div") +
#' #   theme_vvn_research(grid = "none")
theme_vvn_research <- function(base_size = 12, base_family = "sans", grid = "y") {
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

      # ── Axes — no lines/ticks (pure minimal academic style) ───────────
      axis.line   = no_line,
      axis.ticks  = no_line,
      axis.text   = ggplot2::element_text(colour = "#333333", size = small),
      axis.title  = ggplot2::element_text(colour = "#333333", size = base_size * 0.85,
                                           margin = ggplot2::margin(4, 4, 4, 4)),

      # ── Titles — near-black for academic / publication neutrality ─────
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

      # ── Legend — bottom / horizontal (standard for research figures) ──
      legend.position   = "bottom",
      legend.direction  = "horizontal",
      legend.title      = ggplot2::element_text(colour = "#333333", size = small,
                                                 face = "bold"),
      legend.text       = ggplot2::element_text(colour = "#333333", size = small),
      legend.key        = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      legend.background = ggplot2::element_blank(),
      legend.margin     = ggplot2::margin(t = 4),

      # ── Facets — neutral gray strips (not VT Maroon) ──────────────────
      strip.background = ggplot2::element_rect(fill = "#F0F0F0", colour = NA),
      strip.text       = ggplot2::element_text(
        colour = "#333333", face = "bold", size = base_size * 0.85,
        margin = ggplot2::margin(4, 6, 4, 6)
      )
    )
}


#' VVN minimal theme (no axes, no grid)
#'
#' For infographic-style figures, tables-as-charts, and annotation-heavy plots.
#' @inheritParams theme_vvn
#' @export
theme_vvn_minimal <- function(base_size = 12, base_family = "sans") {
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
#' Equivalent to `urbnthemes::set_urbn_defaults()`. Sets `theme_vvn()` as the
#' active theme and updates default aesthetics for all common geoms so that
#' every subsequent `ggplot()` call automatically uses VVN brand colors.
#'
#' @param style One of `"standard"` (default charts), `"map"`, or
#'   `"research"` (clean academic / research-hub style — neutral dark titles,
#'   no axis lines, bottom legend).
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
#' set_vvn_defaults("research")  # research-hub / academic style
#'
#' undo_vvn_defaults()       # revert when done
set_vvn_defaults <- function(style = c("standard", "map", "research"),
                              base_size = 12) {
  style <- match.arg(style)
  thm <- switch(style,
    map      = theme_vvn_map(base_size),
    research = theme_vvn_research(base_size),
    theme_vvn(base_size)
  )
  ggplot2::theme_set(thm)

  # ── Geom defaults ────────────────────────────────────────────────────────
  ggplot2::update_geom_defaults("bar",      list(fill   = .VVN$maroon, colour = NA))
  ggplot2::update_geom_defaults("col",      list(fill   = .VVN$maroon, colour = NA))
  ggplot2::update_geom_defaults("line",     list(colour = .VVN$maroon, linewidth = 1))
  ggplot2::update_geom_defaults("path",     list(colour = .VVN$maroon, linewidth = 1))
  ggplot2::update_geom_defaults("point",    list(colour = .VVN$maroon, size = 2.5))
  ggplot2::update_geom_defaults("smooth",   list(colour = .VVN$orange, fill = .VVN$orange))
  ggplot2::update_geom_defaults("text",     list(colour = .VVN$charcoal, family = base_family_default()))
  ggplot2::update_geom_defaults("label",    list(colour = .VVN$charcoal, fill = .VVN$light_gray))
  ggplot2::update_geom_defaults("hline",    list(colour = .VVN$gray, linewidth = 0.5))
  ggplot2::update_geom_defaults("vline",    list(colour = .VVN$gray, linewidth = 0.5))
  ggplot2::update_geom_defaults("abline",   list(colour = .VVN$gray, linewidth = 0.5))
  ggplot2::update_geom_defaults("boxplot",  list(colour = .VVN$charcoal, fill = .VVN$maroon_lt))
  ggplot2::update_geom_defaults("violin",   list(colour = .VVN$charcoal, fill = .VVN$maroon_lt))
  ggplot2::update_geom_defaults("density",  list(colour = .VVN$maroon, fill = .VVN$maroon, alpha = 0.25))
  ggplot2::update_geom_defaults("area",     list(fill   = .VVN$maroon, alpha = 0.25, colour = NA))
  ggplot2::update_geom_defaults("ribbon",   list(fill   = .VVN$maroon, alpha = 0.25, colour = NA))
  ggplot2::update_geom_defaults("segment",  list(colour = .VVN$charcoal))
  ggplot2::update_geom_defaults("step",     list(colour = .VVN$maroon, linewidth = 1))
  ggplot2::update_geom_defaults("histogram",list(fill   = .VVN$maroon, colour = .VVN$white))
  ggplot2::update_geom_defaults("tile",     list(colour = .VVN$white))
  ggplot2::update_geom_defaults("sf",       list(fill   = .VVN$maroon_lt, colour = .VVN$white))

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
             "ribbon","segment","step","histogram","tile","sf")
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

# Internal helper
base_family_default <- function() "sans"
