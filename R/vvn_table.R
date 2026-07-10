# =============================================================================
# VVN GT Table Styling
# =============================================================================

#' Apply VVN branding to a GT table
#'
#' Styles a `gt` table with VT Maroon column headers, alternating gray rows,
#' orange accent border, and clean typography. Optionally adds title, subtitle,
#' and source note.
#'
#' @param gt_tbl A `gt_tbl` object from [gt::gt()].
#' @param title   Title string (or `NULL`).
#' @param subtitle Subtitle string (or `NULL`).
#' @param source_note Source attribution string (or `NULL`).
#' @param striped  Alternating row shading? Default `TRUE`.
#' @param compact  Reduce padding for dense tables? Default `FALSE`.
#'
#' @return A styled `gt_tbl`.
#' @export
#'
#' @examples
#' \dontrun{
#' library(gt)
#' gt(head(mtcars)) |>
#'   vvn_table(title = "Motor Trend Road Tests",
#'              source_note = "Source: Henderson & Velleman (1981)")
#' }
vvn_table <- function(gt_tbl,
                       title       = NULL,
                       subtitle    = NULL,
                       source_note = NULL,
                       striped     = TRUE,
                       compact     = FALSE) {

  if (!requireNamespace("gt", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg gt} is required. Install with {.code install.packages('gt')}")
  }

  pad <- if (compact) gt::px(6) else gt::px(10)

  out <- gt_tbl |>
    gt::tab_options(
      table.font.names             = "sans-serif",
      table.font.size              = gt::px(13),
      table.background.color       = "#FFFFFF",
      table.border.top.color       = "#861F41",
      table.border.top.width       = gt::px(3),
      table.border.bottom.color    = "#E0E0E0",
      table.border.bottom.width    = gt::px(1),
      column_labels.background.color    = "#861F41",
      column_labels.font.weight         = "bold",
      column_labels.font.size           = gt::px(13),
      column_labels.border.bottom.color = "#E5751F",
      column_labels.border.bottom.width = gt::px(2),
      column_labels.padding             = pad,
      data_row.padding                  = pad,
      row.striping.background_color     = "#F7F7F7",
      row.striping.include_stub         = TRUE,
      stub.background.color             = "#F7F7F7",
      footnotes.font.size               = gt::px(11),
      source_notes.font.size            = gt::px(11),
      source_notes.border.bottom.color  = "#E0E0E0"
    ) |>
    gt::tab_style(
      style     = gt::cell_text(color = "#FFFFFF", weight = "bold"),
      locations = gt::cells_column_labels()
    )

  if (striped) out <- out |> gt::opt_row_striping()

  if (!is.null(title)) {
    out <- out |>
      gt::tab_header(
        title    = gt::md(paste0("**", title, "**")),
        subtitle = if (!is.null(subtitle)) subtitle else gt::md("")
      ) |>
      gt::tab_style(
        style     = gt::cell_text(color = "#861F41", size = gt::px(16), weight = "bold"),
        locations = gt::cells_title("title")
      ) |>
      gt::tab_style(
        style     = gt::cell_text(color = "#3D3D3D", size = gt::px(12)),
        locations = gt::cells_title("subtitle")
      )
  }

  if (!is.null(source_note)) {
    out <- out |>
      gt::tab_source_note(gt::md(paste0("*", source_note, "*")))
  }

  out
}


#' Highlight p-values in a VVN regression table
#'
#' Colors cells in a `gt` table: Maroon for `p < 0.001`, Orange for `p < 0.05`.
#'
#' @param gt_tbl A `gt_tbl`.
#' @param col_name Column name containing p-values (character).
#' @param thresholds Named numeric vector of thresholds → colors.
#'
#' @return A `gt_tbl` with highlighted p-values.
#' @export
vvn_table_pvalues <- function(gt_tbl,
                               col_name   = "p.value",
                               thresholds = c("0.001" = "#861F41", "0.05" = "#E5751F")) {
  if (!requireNamespace("gt", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg gt} required.")
  }
  tholds <- as.numeric(names(thresholds))
  for (i in seq_along(tholds)) {
    out <- gt_tbl |>
      gt::tab_style(
        style     = gt::cell_text(color = thresholds[[i]], weight = "bold"),
        locations = gt::cells_body(
          columns = gt::any_of(col_name),
          rows    = gt::any_of(col_name) < tholds[[i]]
        )
      )
    gt_tbl <- out
  }
  gt_tbl
}
