# =============================================================================
# VVN ggplot2 Color & Fill Scales
# =============================================================================

#' Discrete color scale using VVN brand palettes
#'
#' Drop-in replacement for [ggplot2::scale_color_discrete()].
#'
#' @param palette VVN palette name (see [vvn_palette()]). Default `"main"`.
#' @param reverse Reverse palette order? Default `FALSE`.
#' @param alpha Opacity (0–1). Default `1`.
#' @param ... Passed to [ggplot2::discrete_scale()].
#'
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, fill = class)) +
#'   geom_bar() + scale_fill_vvn()
scale_color_vvn <- function(palette = "main", reverse = FALSE, alpha = 1, ...) {
  pal_fn <- function(n) vvn_palette(palette, n = n, reverse = reverse, alpha = alpha)
  ggplot2::discrete_scale("colour", "vvn", palette = pal_fn, ...)
}

#' @rdname scale_color_vvn
#' @export
scale_colour_vvn <- scale_color_vvn

#' @rdname scale_color_vvn
#' @export
scale_fill_vvn <- function(palette = "main", reverse = FALSE, alpha = 1, ...) {
  pal_fn <- function(n) vvn_palette(palette, n = n, reverse = reverse, alpha = alpha)
  ggplot2::discrete_scale("fill", "vvn", palette = pal_fn, ...)
}


#' Continuous color scale using VVN sequential / diverging palettes
#'
#' @param palette One of `"maroon_seq"`, `"orange_seq"`, `"navy_seq"`,
#'   `"diverging"`, `"gray_seq"`. Default `"maroon_seq"`.
#' @param reverse Reverse palette? Default `FALSE`.
#' @param ... Passed to [ggplot2::scale_color_gradientn()].
#'
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_tile() + scale_fill_vvn_c("maroon_seq")
scale_color_vvn_c <- function(palette = "maroon_seq", reverse = FALSE, ...) {
  ggplot2::scale_color_gradientn(colours = vvn_palette(palette, reverse = reverse), ...)
}

#' @rdname scale_color_vvn_c
#' @export
scale_colour_vvn_c <- scale_color_vvn_c

#' @rdname scale_color_vvn_c
#' @export
scale_fill_vvn_c <- function(palette = "maroon_seq", reverse = FALSE, ...) {
  ggplot2::scale_fill_gradientn(colours = vvn_palette(palette, reverse = reverse), ...)
}
