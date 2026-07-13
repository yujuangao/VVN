# =============================================================================
# VVN Plot Utilities  (mirrors urbn_note, urbn_title, urbn_source, etc.)
# =============================================================================

#' Add a VVN-branded title to a ggplot
#'
#' Convenience wrapper around `ggplot2::labs(title = ...)` that also applies
#' the VVN title style. Can be added to any ggplot object with `+`.
#'
#' @param title Title string (supports markdown via `ggtext` if installed).
#' @param subtitle Optional subtitle string.
#'
#' @return A `ggplot2::labs()` call (can be added with `+`).
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(ggplot2::mpg, aes(displ, hwy)) + geom_point() +
#'   vvn_title("Engine Size vs Fuel Economy",
#'              subtitle = "Visualizing Virginia Numbers, 2024")
vvn_title <- function(title, subtitle = NULL) {
  ggplot2::labs(title = title, subtitle = subtitle)
}


#' Add a VVN-branded source note
#'
#' Appends a formatted caption to a ggplot, styled as a source attribution.
#' Equivalent to `urbnthemes::urbn_source()`.
#'
#' @param source Source string, e.g. `"American Community Survey (2022)"`.
#' @param note Optional additional note prepended before the source.
#'
#' @return A `ggplot2::labs(caption = ...)` call.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(ggplot2::mpg, aes(displ, hwy)) + geom_point() +
#'   vvn_source("EPA Fuel Economy Guide")
vvn_source <- function(source, note = NULL) {
  txt <- if (!is.null(note)) {
    paste0("Note: ", note, "\nSource: ", source)
  } else {
    paste0("Source: ", source)
  }
  ggplot2::labs(caption = txt)
}


#' Add a VVN note / annotation line
#'
#' Equivalent to `urbnthemes::urbn_note()`. Adds a footnote-style annotation
#' below the plot using `ggplot2::labs(caption = ...)`.
#'
#' @param text Note text.
#' @return A `ggplot2::labs()` call.
#' @export
vvn_note <- function(text) {
  ggplot2::labs(caption = paste0("Note: ", text))
}


#' Remove axis ticks from a ggplot
#'
#' Equivalent to `urbnthemes::remove_ticks()`.
#'
#' @param axis Which axis? `"both"`, `"x"`, or `"y"`. Default `"both"`.
#' @return A `ggplot2::theme()` call.
#' @export
remove_ticks <- function(axis = "both") {
  switch(axis,
    both = ggplot2::theme(axis.ticks = ggplot2::element_blank()),
    x    = ggplot2::theme(axis.ticks.x = ggplot2::element_blank()),
    y    = ggplot2::theme(axis.ticks.y = ggplot2::element_blank()),
    ggplot2::theme(axis.ticks = ggplot2::element_blank())
  )
}


#' Remove an axis from a ggplot
#'
#' Equivalent to `urbnthemes::remove_axis()`.
#'
#' @param axis Which axis? `"x"`, `"y"`, or `"both"`. Default `"x"`.
#' @return A `ggplot2::theme()` call.
#' @export
remove_axis <- function(axis = "x") {
  switch(axis,
    x = ggplot2::theme(
      axis.text.x  = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.line.x  = ggplot2::element_blank()
    ),
    y = ggplot2::theme(
      axis.text.y  = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.line.y  = ggplot2::element_blank()
    ),
    both = ggplot2::theme(
      axis.text    = ggplot2::element_blank(),
      axis.title   = ggplot2::element_blank(),
      axis.ticks   = ggplot2::element_blank(),
      axis.line    = ggplot2::element_blank()
    )
  )
}


#' Add a subtle grid to a scatter plot
#'
#' Equivalent to `urbnthemes::scatter_grid()`. Adds both x and y major grid
#' lines, useful for scatter plots where the default y-only grid is insufficient.
#'
#' @return A `ggplot2::theme()` call.
#' @export
scatter_grid <- function() {
  ggplot2::theme(
    panel.grid.major.x = ggplot2::element_line(colour = "#E0E0E0", linewidth = 0.4),
    panel.grid.major.y = ggplot2::element_line(colour = "#E0E0E0", linewidth = 0.4)
  )
}


#' Move legend to bottom of a ggplot
#'
#' @return A `ggplot2::theme()` call.
#' @export
legend_bottom <- function() {
  ggplot2::theme(legend.position = "bottom", legend.direction = "horizontal")
}


#' Remove legend from a ggplot
#'
#' @return A `ggplot2::theme()` call.
#' @export
remove_legend <- function() {
  ggplot2::theme(legend.position = "none")
}


#' Save a VVN plot at publication quality
#'
#' Wrapper around [ggplot2::ggsave()] with sensible VVN defaults (300 dpi,
#' white background, 8×5 inches). Supports simultaneous multi-format export.
#'
#' @param plot A ggplot. Defaults to [ggplot2::last_plot()].
#' @param filename File path (with extension) or base path when `formats` is set.
#' @param width Width in inches. Default `8`.
#' @param height Height in inches. Default `5`.
#' @param dpi Resolution. Default `300`.
#' @param formats Character vector of extensions for multi-format export,
#'   e.g. `c("png","pdf","svg")`. Overrides `filename` extension.
#'
#' @return Invisibly the file path(s).
#' @export
#'
#' @examples
#' \dontrun{
#' p <- ggplot2::ggplot(ggplot2::mpg, ggplot2::aes(displ, hwy)) +
#'   ggplot2::geom_point() + theme_vvn()
#' vvn_save(p, "figures/mpg.png")
#' vvn_save(p, "figures/mpg", formats = c("png", "pdf"))
#' }
vvn_save <- function(plot     = ggplot2::last_plot(),
                     filename,
                     width    = 8,
                     height   = 5,
                     dpi      = 300,
                     formats  = NULL) {
  if (!is.null(formats)) {
    base <- tools::file_path_sans_ext(filename)
    fs::dir_create(dirname(base))
    paths <- vapply(formats, function(fmt) {
      p <- paste0(base, ".", fmt)
      ggplot2::ggsave(p, plot = plot, width = width, height = height, dpi = dpi, bg = "white")
      cli::cli_alert_success("Saved {.path {p}}")
      p
    }, character(1))
    return(invisible(paths))
  }
  fs::dir_create(dirname(filename))
  ggplot2::ggsave(filename, plot = plot, width = width, height = height, dpi = dpi, bg = "white")
  cli::cli_alert_success("Saved {.path {filename}}")
  invisible(filename)
}
