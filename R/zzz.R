#' vvnthemes: Visualizing Virginia Numbers Themes and Templates
#'
#' @description
#' Provides ggplot2 themes, color palettes, scales, GT table styles, Leaflet
#' map helpers, Shiny UI components, and ready-to-use project templates for the
#' Visualizing Virginia Numbers (VVN) at Virginia Tech. Inspired by
#' [urbnthemes](https://urbaninstitute.github.io/urbnthemes/).
#'
#' @section Get started:
#' ```r
#' library(vvnthemes)
#'
#' # Apply VVN brand theme globally
#' set_vvn_defaults()
#'
#' # View a color palette
#' view_vvn_palette("main")
#'
#' # Create a new data story (Quarto → HTML)
#' create_vvn_story("my_story", title = "Housing in Rural Virginia")
#'
#' # Create a Shiny dashboard
#' create_vvn_dashboard("my_dashboard", title = "Virginia Data Explorer")
#' ```
#'
#' @keywords internal
"_PACKAGE"


.onAttach <- function(libname, pkgname) {
  v <- utils::packageVersion(pkgname)
  packageStartupMessage(
    "\u25a0 vvnthemes ", v,
    " \u00b7 Visualizing Virginia Numbers \u00b7 Virginia Tech\n",
    "  Use set_vvn_defaults() to apply VVN brand globally."
  )
}
