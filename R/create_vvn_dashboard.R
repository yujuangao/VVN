# =============================================================================
# VVN Project Scaffolding — Shiny Dashboard
# =============================================================================

#' Create a VVN Shiny dashboard project
#'
#' Scaffolds a production-ready Shiny dashboard using `bslib` with full VVN
#' branding: maroon navbar, KPI cards, reactive charts, map, and filter panel.
#' The generated `app.R` runs immediately on example data.
#'
#' @param name      Project folder name.
#' @param path      Parent directory. Default: `"."`.
#' @param title     Dashboard title shown in the navbar.
#' @param author    Author name(s).
#' @param overwrite If `TRUE`, delete and recreate an existing project folder.
#'   Default `FALSE` (error if folder exists).
#'
#' @return Invisibly the project path.
#' @export
#'
#' @examples
#' \dontrun{
#' create_vvn_dashboard("housing_dashboard",
#'                       title = "Virginia Housing Affordability Dashboard")
#' shiny::runApp("housing_dashboard")
#' # Re-run without error:
#' create_vvn_dashboard("housing_dashboard", overwrite = TRUE)
#' }
create_vvn_dashboard <- function(name,
                                  path      = ".",
                                  title     = name,
                                  author    = "Visualizing Virginia Numbers",
                                  overwrite = FALSE) {

  proj <- fs::path(path, name)
  if (fs::dir_exists(proj)) {
    if (!overwrite) cli::cli_abort("Directory {.path {proj}} already exists. Use `overwrite = TRUE` to replace it.")
    fs::dir_delete(proj)
  }

  for (d in c("data/raw", "data/processed", "figures", "scripts", "www")) {
    fs::dir_create(fs::path(proj, d))
  }

  # Copy bundled templates
  tmpl <- system.file("templates", "dashboard", package = "vvnthemes")
  if (nzchar(tmpl) && fs::dir_exists(tmpl)) {
    tmpl_files <- fs::dir_ls(tmpl, recurse = TRUE, type = "file")
    for (f in tmpl_files) {
      rel  <- fs::path_rel(f, start = tmpl)
      dest <- fs::path(proj, rel)
      fs::dir_create(dirname(dest))
      fs::file_copy(f, dest, overwrite = FALSE)
    }
  }

  # Copy vvn.css → www/vvn.css
  css_src <- system.file("www", "vvn.css", package = "vvnthemes")
  if (nzchar(css_src)) {
    fs::file_copy(css_src, fs::path(proj, "www", "vvn.css"), overwrite = TRUE)
  }

  # Patch title in app.R
  app_path <- fs::path(proj, "app.R")
  if (fs::file_exists(app_path)) {
    lines <- readLines(app_path, warn = FALSE)
    lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
    lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
    writeLines(lines, app_path)
  }

  .write_readme(proj, name, title,
    body = paste0(
      "## Workflow\n\n",
      "```r\n",
      "# Step 1: uncomment data loading in app.R (data/processed/ or data/raw/)\n",
      "# Step 2: build charts in scripts/analysis.R, then source it\n",
      "source(\"scripts/analysis.R\")\n",
      "# Step 3: replace [placeholders] in app.R, then run\n",
      "shiny::runApp(\"", name, "\")\n",
      "```\n\n",
      "## Deploy\n\n",
      "```r\n",
      "rsconnect::deployApp(\"", name, "\")\n",
      "```\n\n",
      "## Structure\n\n",
      "```\n",
      name, "/\n",
      "\u251c\u2500\u2500 app.R                \u2190 Main dashboard; load data + interactive parts\n",
      "\u251c\u2500\u2500 scripts/analysis.R   \u2190 Build all charts here; source this first\n",
      "\u251c\u2500\u2500 figures/             \u2190 Auto-created when analysis.R runs\n",
      "\u251c\u2500\u2500 www/vvn.css          \u2190 VVN brand CSS\n",
      "\u2514\u2500\u2500 data/\n",
      "    \u251c\u2500\u2500 raw/\n",
      "    \u2514\u2500\u2500 processed/\n",
      "```\n"
    )
  )

  cli::cli_h1("VVN Dashboard: {name}")
  cli::cli_alert_success("Created at {.path {proj}}")
  cli::cli_bullets(c(
    "*" = "Uncomment data loading near the top of {.path app.R}",
    "*" = "Build charts: {.code source(\"{name}/scripts/analysis.R\")}",
    "*" = "Run: {.code shiny::runApp(\"{name}\")}",
    "*" = "Deploy: {.code rsconnect::deployApp(\"{name}\")}"
  ))
  invisible(proj)
}
