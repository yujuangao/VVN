# =============================================================================
# VVN Project Scaffolding - Data Story
# =============================================================================

#' Create a new VVN data story project
#'
#' Sets up a self-contained Quarto project with VVN branding. Your title and
#' author are filled in automatically. Everything else — charts, narrative, and
#' data — is left for you to fill in using clearly marked `[placeholders]`.
#'
#' **Filled in automatically from your function call:**
#' - Title and author in `index.qmd`
#' - Creation date in `index.qmd` and `scripts/analysis.R`
#'
#' **Already configured — no changes needed:**
#' - VVN brand theme and colors (`styles.scss`)
#' - Quarto format settings (TOC, embed-resources, figure size)
#'
#' **You fill in:**
#' - Data files → place in `data/raw/` or `data/processed/`
#' - Charts → uncomment blocks in `scripts/analysis.R`, then `source()` it
#' - Narrative → edit `index.qmd`, replace every `[placeholder]` with your text
#'
#' @param name      Folder name for the project. Use `snake_case`
#'   (e.g., `"childcare_cost"`). Created inside `path`.
#' @param path      Parent directory. Defaults to the current working directory.
#' @param title     Story title shown in the document header and browser tab.
#'   Filled into `index.qmd` automatically.
#' @param subtitle  Subtitle shown below the title. Default `""` (empty).
#' @param author    Author name(s) shown below the title. Defaults to
#'   `"Visualizing Virginia's Numbers"`.
#' @param overwrite If `TRUE`, delete an existing folder with the same name and
#'   recreate it. Default `FALSE` — raises an error if the folder exists.
#'
#' @return Invisibly returns the path to the created project folder.
#' @export
#'
#' @examples
#' \dontrun{
#' # Title, subtitle, and author are filled in automatically:
#' create_vvn_story(
#'   "childcare_cost",
#'   title    = "Childcare Cost in Rural Virginia",
#'   subtitle = "County-Level Trends from the ACS",
#'   author   = "Jane Smith"
#' )
#'
#' # Build figures, then render:
#' source("childcare_cost/scripts/analysis.R")
#' quarto::quarto_render("childcare_cost/index.qmd")
#'
#' # Recreate (overwrites existing folder):
#' create_vvn_story("childcare_cost", title = "...", overwrite = TRUE)
#' }
create_vvn_story <- function(name,
                              path      = ".",
                              title     = name,
                              subtitle  = "",
                              author    = "Visualizing Virginia's Numbers",
                              overwrite = FALSE) {

  proj <- fs::path(path, name)
  if (fs::dir_exists(proj)) {
    if (!overwrite) cli::cli_abort("Directory {.path {proj}} already exists. Use `overwrite = TRUE` to replace it.")
    fs::dir_delete(proj)
  }

  created_fresh <- FALSE
  tryCatch({
    # Create directory structure
    for (d in c("data/raw", "data/processed", "figures", "assets", "scripts")) {
      fs::dir_create(fs::path(proj, d))
    }
    created_fresh <- TRUE

    # Write .gitkeep files in empty directories
    for (d in c("data/raw", "data/processed", "figures", "assets")) {
      file.create(fs::path(proj, d, ".gitkeep"))
    }

    # Copy bundled templates (root-level files: index.qmd, _quarto.yml, styles.scss)
    tmpl <- system.file("templates", "story", package = "vvnthemes")
    if (nzchar(tmpl) && fs::dir_exists(tmpl)) {
      root_files <- fs::dir_ls(tmpl, type = "file")
      if (length(root_files)) fs::file_copy(root_files, proj, overwrite = TRUE)
    } else {
      .write_story_stubs(proj)
    }

    # Copy analysis.R template into scripts/
    analysis_tmpl <- system.file("templates", "story", "scripts", "analysis.R",
                                  package = "vvnthemes")
    if (nzchar(analysis_tmpl) && fs::file_exists(analysis_tmpl)) {
      fs::file_copy(analysis_tmpl, fs::path(proj, "scripts", "analysis.R"),
                    overwrite = TRUE)
    } else {
      .write_analysis_stub(fs::path(proj, "scripts", "analysis.R"))
    }

    today <- format(Sys.Date(), "%Y-%m-%d")

    # Inject title, author, date into index.qmd
    qmd <- fs::path(proj, "index.qmd")
    if (fs::file_exists(qmd)) {
      lines <- readLines(qmd, warn = FALSE)
      lines <- gsub("VVN_TITLE",    title,    lines, fixed = TRUE)
      lines <- gsub("VVN_SUBTITLE", subtitle, lines, fixed = TRUE)
      lines <- gsub("VVN_AUTHOR",   author,   lines, fixed = TRUE)
      lines <- gsub("VVN_DATE",     today,    lines, fixed = TRUE)
      writeLines(lines, qmd)
    }

    # Inject title into _quarto.yml
    yml <- fs::path(proj, "_quarto.yml")
    if (fs::file_exists(yml)) {
      lines <- readLines(yml, warn = FALSE)
      lines <- gsub("VVN_TITLE", title, lines, fixed = TRUE)
      writeLines(lines, yml)
    }

    # Inject title, author, date into scripts/analysis.R
    analysis_path <- fs::path(proj, "scripts", "analysis.R")
    if (fs::file_exists(analysis_path)) {
      lines <- readLines(analysis_path, warn = FALSE)
      lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
      lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
      lines <- gsub("VVN_DATE",   today,  lines, fixed = TRUE)
      writeLines(lines, analysis_path)
    }
  }, error = function(e) {
    if (created_fresh && fs::dir_exists(proj)) fs::dir_delete(proj)
    cli::cli_abort("Failed to create project: {e$message}", call = NULL)
  })

  # README
  .write_readme(proj, name, title,
    body = paste0(
      "## Workflow\n\n",
      "**Step 1 — Build figures**\n\n",
      "Open `scripts/analysis.R`, fill in your chart code, then source it:\n\n",
      "```r\n",
      "source(\"scripts/analysis.R\")\n",
      "# Static figures saved to figures/01_name.png, 02_name.png, ...\n",
      "# Interactive HTML maps saved to assets/name.html\n",
      "```\n\n",
      "**Step 2 — Write the narrative**\n\n",
      "Open `index.qmd`. Replace every `[placeholder]` with your content.\n",
      "- **Static figures:** update `knitr::include_graphics()` filenames\n",
      "- **Interactive maps:** uncomment the `.map-card` iframe block and set the `src` path\n\n",
      "**Step 3 — Render**\n\n",
      "```r\n",
      "quarto::quarto_render(\"index.qmd\")\n",
      "```\n\n",
      "Output: `index.html` (self-contained, ready to publish)\n\n",
      "## Structure\n\n",
      "```\n",
      name, "/\n",
      "\u251c\u2500\u2500 index.qmd            \u2190 Narrative — fill in text, insert figure names\n",
      "\u251c\u2500\u2500 _quarto.yml\n",
      "\u251c\u2500\u2500 styles.scss          \u2190 VVN brand SCSS (do not edit)\n",
      "\u251c\u2500\u2500 assets/              \u2190 Interactive HTML maps/widgets (iframe in index.qmd)\n",
      "\u251c\u2500\u2500 data/raw/\n",
      "\u251c\u2500\u2500 data/processed/\n",
      "\u251c\u2500\u2500 scripts/\n",
      "\u2502   \u2514\u2500\u2500 analysis.R       \u2190 Build figures + maps here, then source\n",
      "\u2514\u2500\u2500 figures/             \u2190 Static PNG charts\n",
      "```\n"
    )
  )

  cli::cli_h1("VVN Story: {name}")
  cli::cli_alert_success("Created at {.path {proj}}")
  cli::cli_bullets(c(
    "1" = "Fill in {.path scripts/analysis.R} and source it to generate figures",
    "2" = "Edit {.path index.qmd} — replace placeholders and insert figure names",
    "3" = "Render: {.code quarto::quarto_render(\"index.qmd\")}"
  ))
  invisible(proj)
}


#' Check a VVN Insights story for required sections
#'
#' Validates `index.qmd` for key structural sections and VVN function usage.
#' Searches both `index.qmd` and `scripts/analysis.R` for `vvn_source`.
#'
#' @param path Path to the story folder. Default: `"."`.
#' @return Invisibly `TRUE` if all checks pass, `FALSE` otherwise.
#' @export
#'
#' @examples
#' \dontrun{
#' check_vvn_story("childcare_cost")
#' }
check_vvn_story <- function(path = ".") {
  qmd    <- fs::path(path, "index.qmd")
  script <- fs::path(path, "scripts", "analysis.R")

  if (!fs::file_exists(qmd)) cli::cli_abort("No {.path index.qmd} in {.path {path}}.")

  # Check for figures (independent of script existence)
  fig_dir <- fs::path(path, "figures")
  if (fs::dir_exists(fig_dir)) {
    n_figs <- length(fs::dir_ls(fig_dir, glob = "*.png", fail = FALSE))
    if (n_figs == 0) {
      cli::cli_alert_warning("No PNG files in {.path figures/} — source {.path scripts/analysis.R} first.")
    } else {
      cli::cli_alert_success("{n_figs} figure(s) found in {.path figures/}.")
    }
  } else {
    cli::cli_alert_warning("No {.path figures/} directory found.")
  }

  # Check analysis script exists
  if (!fs::file_exists(script)) {
    cli::cli_alert_warning("Missing {.path scripts/analysis.R} — create and source it to generate figures.")
  }

  # Check index.qmd sections
  txt_qmd <- paste(readLines(qmd, warn = FALSE), collapse = "\n")

  # Search both files for vvn_source
  has_vvn_source <- grepl("vvn_source", txt_qmd, fixed = TRUE)
  if (!has_vvn_source && fs::file_exists(script)) {
    txt_script <- paste(readLines(script, warn = FALSE), collapse = "\n")
    has_vvn_source <- grepl("vvn_source", txt_script, fixed = TRUE)
  }

  # Check required sections in index.qmd (vvn_source checked separately)
  has_figures <- grepl("include_graphics", txt_qmd, fixed = TRUE) ||
                 grepl("map-card", txt_qmd, fixed = TRUE)
  required_sections <- c("finding-statement")
  missing <- required_sections[!vapply(required_sections, grepl, logical(1),
                                        x = txt_qmd, fixed = TRUE)]
  if (!has_figures) missing <- c(missing, "include_graphics or map-card")

  if (!has_vvn_source) missing <- c(missing, "vvn_source")

  if (length(missing) == 0) {
    cli::cli_alert_success("All required VVN sections present.")
    return(invisible(TRUE))
  }
  cli::cli_alert_warning("Missing:")
  cli::cli_bullets(stats::setNames(paste("Missing:", missing), rep("x", length(missing))))
  invisible(FALSE)
}


# Internal helpers -------------------------------------------------------

.write_story_stubs <- function(proj) {
  # index.qmd stub (will be copied from inst/ if available)
  writeLines(
    c("---",
      'title: "VVN_TITLE"',
      'author: "VVN_AUTHOR"',
      "date: today",
      "format:",
      "  html:",
      "    theme: [cosmo, styles.scss]",
      "    toc: true",
      "    toc-depth: 2",
      "    toc-location: left",
      "    number-sections: true",
      "    embed-resources: true",
      "execute:",
      "  echo: false",
      "  warning: false",
      "---",
      "",
      '```{r setup}',
      "#| include: false",
      "library(vvnthemes)",
      "library(ggplot2)",
      "set_vvn_defaults()",
      '```',
      "",
      "::: {.vvn-header}",
      "## VVN_TITLE {.unnumbered .unlisted}",
      ":::",
      "",
      "## Finding 1 {.finding}",
      "",
      '::: {.finding-statement}',
      "[Write your key finding here.]",
      ":::",
      "",
      "## Conclusion {.unnumbered}",
      "",
      "---",
      "*Visualizing Virginia's Numbers \u00B7 Virginia Tech*"
    ),
    fs::path(proj, "index.qmd")
  )

  writeLines(
    c("project:",
      "  type: website",
      "format:",
      "  html:",
      "    theme: [cosmo, styles.scss]",
      "    toc: true",
      "    toc-depth: 2",
      "    toc-location: left",
      "    number-sections: true",
      "    embed-resources: true"
    ),
    fs::path(proj, "_quarto.yml")
  )

  # Copy CSS from inst/www
  css <- system.file("www", "vvn.css", package = "vvnthemes")
  if (nzchar(css)) fs::file_copy(css, fs::path(proj, "styles.scss"))
  else file.create(fs::path(proj, "styles.scss"))
}

.write_analysis_stub <- function(path) {
  writeLines(c(
    "# ── VVN Story Analysis Script ──────────────────────────────────────────────",
    "# HOW TO USE:",
    "#   1. Load your data in Section 1.",
    "#   2. Uncomment the chart type(s) you want from the gallery below.",
    "#   3. Fill in your data columns and labels.",
    "#   4. Source this script — figures are auto-numbered and saved to figures/",
    "#   5. Open index.qmd, replace text placeholders, update include_graphics()",
    "#      filenames, and render.",
    "#",
    "# Run from project root:  source(\"scripts/analysis.R\")",
    "# ───────────────────────────────────────────────────────────────────────────",
    "",
    "library(vvnthemes)",
    "library(ggplot2)",
    "library(dplyr)",
    "",
    "set_vvn_defaults()",
    "",
    "# ── Set root to project folder (one level up from scripts/) ────────────────",
    ".script_dir <- tryCatch(",
    "  dirname(rstudioapi::getSourceEditorContext()$path),",
    "  error = function(e) {",
    "    args <- commandArgs(trailingOnly = FALSE)",
    "    f    <- grep(\"--file=\", args, value = TRUE)",
    "    if (length(f)) dirname(normalizePath(sub(\"--file=\", \"\", f))) else getwd()",
    "  }",
    ")",
    "setwd(normalizePath(file.path(.script_dir, \"..\")))",
    "dir.create(\"figures\", showWarnings = FALSE)",
    "message(\"Project root     : \", getwd())",
    "message(\"Figures saved to : \", normalizePath(\"figures\"))",
    "",
    "# ── Auto-numbering helper ──────────────────────────────────────────────────",
    ".n <- 0L",
    "save_fig <- function(plot, name, width = 8, height = 5) {",
    "  .n <<- .n + 1L",
    "  path <- sprintf(\"figures/%02d_%s.png\", .n, name)",
    "  vvn_save(plot, path, width = width, height = height)",
    "}",
    "",
    "# ── 1. Load your data ──────────────────────────────────────────────────────",
    "# TODO: Replace with your actual file paths.",
    "# df <- readr::read_csv(\"data/processed/my_data.csv\")",
    "",
    "# ===========================================================================",
    "# CHART GALLERY — uncomment the blocks you want and fill in column names",
    "# ===========================================================================",
    "",
    "# ── LINE CHART: multiple groups over time ───────────────────────────────────",
    "# p1 <- ggplot(df, aes(x = year, y = value, color = group, group = group)) +",
    "#   geom_line(linewidth = 1.2) + geom_point(size = 2.5) +",
    "#   scale_color_vvn(\"main\") +",
    "#   scale_x_continuous(breaks = unique(df$year)) +",
    "#   labs(title = \"[Chart title]\", x = NULL, y = \"[Metric]\", color = \"[Legend]\") +",
    "#   vvn_source(\"[Dataset]\") + scatter_grid()",
    "# save_fig(p1, \"trend_grouped\")",
    "",
    "message(sprintf(\"Done — %d figure(s) saved to figures/\", .n))"
  ), path)
}

.write_readme <- function(proj, name, title, body) {
  writeLines(
    c(glue::glue("# {title}"),
      "",
      glue::glue("VVN project generated with `vvnthemes`."),
      "",
      body
    ),
    fs::path(proj, "README.md")
  )
}
