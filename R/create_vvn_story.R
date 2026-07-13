# =============================================================================
# VVN Project Scaffolding - Data Story
# =============================================================================

#' Create a VVN Insights data story project
#'
#' Scaffolds a Quarto project with VVN branding that renders to a
#' self-contained HTML page. Equivalent to creating a new Urban Institute
#' analysis project.
#'
#' @param name   Project folder name (use snake_case, e.g. `"childcare_cost"`).
#' @param path   Parent directory. Default: current working directory.
#' @param title  Story title for YAML front matter and README.
#' @param author Author name(s).
#'
#' @return Invisibly the project path (character).
#' @export
#'
#' @examples
#' \dontrun{
#' create_vvn_story("childcare_cost",
#'                   title  = "Childcare Cost in Rural Virginia",
#'                   author = "VVN Research Team")
#' # Renders to HTML:
#' quarto::quarto_render("childcare_cost/index.qmd")
#' }
create_vvn_story <- function(name,
                              path   = ".",
                              title  = name,
                              author = "Visualizing Virginia Numbers") {

  proj <- fs::path(path, name)
  if (fs::dir_exists(proj)) cli::cli_abort("Directory {.path {proj}} already exists.")

  # Create directory structure
  for (d in c("data/raw", "data/processed", "figures", "scripts")) {
    fs::dir_create(fs::path(proj, d))
  }

  # Copy bundled templates
  tmpl <- system.file("templates", "story", package = "vvnthemes")
  if (nzchar(tmpl) && fs::dir_exists(tmpl)) {
    fs::file_copy(fs::dir_ls(tmpl), proj, overwrite = FALSE)
  } else {
    .write_story_stubs(proj)
  }

  # Inject title & author
  qmd <- fs::path(proj, "index.qmd")
  if (fs::file_exists(qmd)) {
    lines <- readLines(qmd, warn = FALSE)
    lines <- gsub("VVN_TITLE",  title,  lines, fixed = TRUE)
    lines <- gsub("VVN_AUTHOR", author, lines, fixed = TRUE)
    writeLines(lines, qmd)
  }

  # README
  .write_readme(proj, name, title,
    body = paste0(
      "## Render to HTML\n\n",
      "```r\n",
      "quarto::quarto_render(\"index.qmd\")\n",
      "```\n\n",
      "Output: `index.html` (self-contained, ready to publish)\n\n",
      "## Structure\n\n",
      "```\n",
      name, "/\n",
      "\u251c\u2500\u2500 index.qmd        \u2190 Edit this file\n",
      "\u251c\u2500\u2500 _quarto.yml\n",
      "\u251c\u2500\u2500 styles.scss      \u2190 VVN brand SCSS\n",
      "\u251c\u2500\u2500 data/raw/\n",
      "\u251c\u2500\u2500 data/processed/\n",
      "\u251c\u2500\u2500 figures/\n",
      "\u2514\u2500\u2500 scripts/\n",
      "```\n"
    )
  )

  cli::cli_h1("VVN Story: {name}")
  cli::cli_alert_success("Created at {.path {proj}}")
  cli::cli_bullets(c(
    "*" = "Edit {.path index.qmd} to write your story",
    "*" = "Place data in {.path data/raw/}",
    "*" = "Render: {.code quarto::quarto_render(\"index.qmd\")}"
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
  qmd <- fs::path(path, "index.qmd")
  if (!fs::file_exists(qmd)) cli::cli_abort("No {.path index.qmd} in {.path {path}}.")

  txt      <- paste(readLines(qmd, warn = FALSE), collapse = "\n")
  required <- c("Overview", "Background", "Findings", "Conclusion",
                 "theme_vvn", "vvn_source")
  missing  <- required[!vapply(required, grepl, logical(1), x = txt, fixed = TRUE)]

  if (length(missing) == 0) {
    cli::cli_alert_success("All required VVN sections present.")
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
