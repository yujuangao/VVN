# =============================================================================
# VVN Project Scaffolding - Data Story
# =============================================================================

#' Create a VVN Insights data story project
#'
#' Scaffolds a Quarto project with VVN branding that renders to a
#' self-contained HTML page. Equivalent to creating a new Urban Institute
#' analysis project.
#'
#' @param name      Project folder name (use snake_case, e.g. `"childcare_cost"`).
#' @param path      Parent directory. Default: current working directory.
#' @param title     Story title for YAML front matter and README.
#' @param author    Author name(s).
#' @param overwrite If `TRUE`, delete and recreate an existing project folder.
#'   Default `FALSE` (error if folder exists).
#'
#' @return Invisibly the project path (character).
#' @export
#'
#' @examples
#' \dontrun{
#' create_vvn_story("childcare_cost",
#'                   title  = "Childcare Cost in Rural Virginia",
#'                   author = "VVN Research Team")
#' # Re-run without error:
#' create_vvn_story("childcare_cost", overwrite = TRUE)
#' # Renders to HTML:
#' quarto::quarto_render("childcare_cost/index.qmd")
#' }
create_vvn_story <- function(name,
                              path      = ".",
                              title     = name,
                              author    = "Visualizing Virginia Numbers",
                              overwrite = FALSE) {

  proj <- fs::path(path, name)
  if (fs::dir_exists(proj)) {
    if (!overwrite) cli::cli_abort("Directory {.path {proj}} already exists. Use `overwrite = TRUE` to replace it.")
    fs::dir_delete(proj)
  }

  created_fresh <- FALSE
  tryCatch({
    # Create directory structure
    for (d in c("data/raw", "data/processed", "figures", "scripts")) {
      fs::dir_create(fs::path(proj, d))
    }
    created_fresh <- TRUE

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

    # Inject title & author into index.qmd
    qmd <- fs::path(proj, "index.qmd")
    if (fs::file_exists(qmd)) {
      lines <- readLines(qmd, warn = FALSE)
      lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
      lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
      writeLines(lines, qmd)
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
      "# figures saved to figures/01_name.png, 02_name.png, ...\n",
      "```\n\n",
      "**Step 2 — Write the narrative**\n\n",
      "Open `index.qmd`. Replace every `[placeholder]` with your content and\n",
      "update the filenames in `knitr::include_graphics()` to match `figures/`.\n\n",
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
      "\u251c\u2500\u2500 data/raw/\n",
      "\u251c\u2500\u2500 data/processed/\n",
      "\u251c\u2500\u2500 scripts/\n",
      "\u2502   \u2514\u2500\u2500 analysis.R       \u2190 Build all figures here, then source\n",
      "\u2514\u2500\u2500 figures/             \u2190 Auto-created when analysis.R runs\n",
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

  # Check analysis script exists and figures have been generated
  if (!fs::file_exists(script)) {
    cli::cli_alert_warning("Missing {.path scripts/analysis.R} — create and source it to generate figures.")
  } else {
    n_figs <- length(fs::dir_ls(fs::path(path, "figures"), glob = "*.png",
                                 fail = FALSE))
    if (n_figs == 0) {
      cli::cli_alert_warning("No PNG files in {.path figures/} — source {.path scripts/analysis.R} first.")
    } else {
      cli::cli_alert_success("{n_figs} figure(s) found in {.path figures/}.")
    }
  }

  # Check index.qmd sections
  txt      <- paste(readLines(qmd, warn = FALSE), collapse = "\n")
  required <- c("Overview", "Background", "Findings", "Conclusion",
                 "include_graphics", "vvn_source")
  missing  <- required[!vapply(required, grepl, logical(1), x = txt, fixed = TRUE)]

  if (length(missing) == 0) {
    cli::cli_alert_success("All required VVN sections present in {.path index.qmd}.")
    return(invisible(TRUE))
  }
  cli::cli_alert_warning("Missing in {.path index.qmd}:")
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
      "    toc-depth: 3",
      "    toc-location: right",
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
      '```',
      "",
      "## Overview {.hero}",
      "",
      "> **Key Finding:** Write your key finding here.",
      "",
      "## Background",
      "",
      "## Findings",
      "",
      "## Conclusion",
      "",
      "---",
      "*Visualizing Virginia Numbers \u00B7 Virginia Tech*"
    ),
    fs::path(proj, "index.qmd")
  )

  writeLines(
    c("project:",
      "  type: website",
      "format:",
      "  html:",
      "    theme: [cosmo, styles.scss]",
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
    "# ── HORIZONTAL BAR CHART: ranking or comparison ─────────────────────────────",
    "# p2 <- df |>",
    "#   mutate(name = reorder(name, value), hi = name == \"[highlight]\") |>",
    "#   ggplot(aes(x = value, y = name, fill = hi)) +",
    "#   geom_col(width = 0.65) +",
    "#   geom_text(aes(label = round(value, 1)), hjust = -0.2, size = 3.4) +",
    "#   scale_fill_manual(values = c(`TRUE` = \"#E5751F\", `FALSE` = \"#861F41\"),",
    "#                     guide = \"none\") +",
    "#   scale_x_continuous(expand = expansion(mult = c(0, .15))) +",
    "#   labs(title = \"[Chart title]\", x = \"[Metric]\", y = NULL) +",
    "#   vvn_source(\"[Dataset]\") + remove_ticks()",
    "# save_fig(p2, \"bar_horizontal\")",
    "",
    "# ── SCATTER / BUBBLE CHART ──────────────────────────────────────────────────",
    "# p3 <- ggplot(df, aes(x = x_var, y = y_var, color = group, size = size_var)) +",
    "#   geom_point(alpha = 0.75) +",
    "#   scale_color_vvn(\"main\") +",
    "#   scale_size_continuous(range = c(2, 10), labels = scales::comma) +",
    "#   labs(title = \"[Chart title]\", x = \"[X]\", y = \"[Y]\", color = \"[Legend]\") +",
    "#   vvn_source(\"[Dataset]\") + scatter_grid()",
    "# save_fig(p3, \"scatter\")",
    "",
    "# ── LOLLIPOP CHART: ranking ─────────────────────────────────────────────────",
    "# p4 <- df |>",
    "#   mutate(name = reorder(name, value),",
    "#          grp  = if_else(value >= median(value), \"Above\", \"Below\")) |>",
    "#   ggplot(aes(x = value, y = name, color = grp)) +",
    "#   geom_segment(aes(x = 0, xend = value, yend = name),",
    "#                linewidth = 0.7, alpha = 0.5) +",
    "#   geom_point(size = 3.5) +",
    "#   scale_color_manual(values = c(Above = \"#861F41\", Below = \"#E5751F\")) +",
    "#   labs(title = \"[Chart title]\", x = \"[Metric]\", y = NULL, color = NULL) +",
    "#   vvn_source(\"[Dataset]\") + remove_ticks()",
    "# save_fig(p4, \"lollipop\", height = 7)",
    "",
    "# ── COUNTY MAP (leaflet + static PNG) ───────────────────────────────────────",
    "# library(leaflet); library(mapshot2)",
    "# m <- leaflet(va_counties) |>",
    "#   vvn_map_style(data = va_counties, value_col = \"[var]\", title = \"[title]\")",
    "# mapshot2(m, file = sprintf(\"figures/%02d_map.png\", .n + 1L))",
    "# .n <<- .n + 1L",
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
