# =============================================================================
# VVN Project Scaffolding — Shiny Dashboard
# =============================================================================

#' Create a new VVN Shiny dashboard project
#'
#' Sets up a Shiny dashboard with VVN branding. Your title and author are filled
#' in automatically. Everything else — data, charts, filters, and KPI values —
#' is left for you to fill in using clearly marked `[placeholders]` and
#' commented-out code blocks.
#'
#' **Filled in automatically from your function call:**
#' - Title and author in `app.R` and `scripts/analysis.R`
#' - Creation date in both files
#'
#' **Already configured — no changes needed:**
#' - VVN Bootstrap theme (`vvn_bs_theme()`), maroon navbar, VVN CSS
#' - Tab structure: Overview / Map / Data / About
#' - KPI card slots, chart slots, sidebar filter slots (commented out, ready to activate)
#'
#' **You fill in:**
#' - Data files → place in `data/raw/` or `data/processed/`
#' - Charts → uncomment blocks in `scripts/analysis.R`, then `source()` it
#' - `app.R` → load data, fill in chart filenames, uncomment KPI/filter/table blocks
#' - About tab → add your data sources, methods, and contact info
#'
#' @param name      Folder name for the project. Use `snake_case`
#'   (e.g., `"housing_dashboard"`). Created inside `path`.
#' @param path      Parent directory. Defaults to the current working directory.
#' @param title     Dashboard title shown in the navbar.
#'   Filled into `app.R` automatically.
#' @param author    Author name(s) shown in the file header comment. Defaults to
#'   `"Visualizing Virginia's Numbers"`.
#' @param overwrite If `TRUE`, delete an existing folder with the same name and
#'   recreate it. Default `FALSE` — raises an error if the folder exists.
#'
#' @return Invisibly returns the path to the created project folder.
#' @export
#'
#' @examples
#' \dontrun{
#' # Title and author are filled in automatically:
#' create_vvn_dashboard(
#'   "housing_dashboard",
#'   title  = "Virginia Housing Affordability",
#'   author = "Jane Smith"
#' )
#'
#' # Build figures, then run:
#' source("housing_dashboard/scripts/analysis.R")
#' shiny::runApp("housing_dashboard")
#'
#' # Recreate (overwrites existing folder):
#' create_vvn_dashboard("housing_dashboard", title = "...", overwrite = TRUE)
#' }
create_vvn_dashboard <- function(name,
                                  path      = ".",
                                  title     = name,
                                  author    = "Visualizing Virginia's Numbers",
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

  today <- format(Sys.Date(), "%Y-%m-%d")

  # Patch title, author, date in app.R
  app_path <- fs::path(proj, "app.R")
  if (fs::file_exists(app_path)) {
    lines <- readLines(app_path, warn = FALSE)
    lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
    lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
    lines <- gsub("VVN_DATE",   today,  lines, fixed = TRUE)
    writeLines(lines, app_path)
  }

  # Patch title, author, date in scripts/analysis.R
  analysis_path <- fs::path(proj, "scripts", "analysis.R")
  if (fs::file_exists(analysis_path)) {
    lines <- readLines(analysis_path, warn = FALSE)
    lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
    lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
    lines <- gsub("VVN_DATE",   today,  lines, fixed = TRUE)
    writeLines(lines, analysis_path)
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
