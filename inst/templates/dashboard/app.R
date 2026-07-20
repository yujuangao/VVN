# ==============================================================================
# VVN Dashboard Template — app.R
# VVN_TITLE
# VVN_AUTHOR · Visualizing Virginia Numbers · Virginia Tech
#
# WORKFLOW:
#   Step 1 — Load your data in R/data_prep.R
#   Step 2 — Build charts in scripts/analysis.R, then source it
#             (figures are auto-numbered and saved to figures/)
#   Step 3 — Replace every [placeholder] in this file with your content
#   Step 4 — Run: shiny::runApp()
#   Step 5 — Deploy: rsconnect::deployApp()
#
# Charts are static PNGs built in scripts/analysis.R and displayed here.
# Interactive components (KPI cards, table, map) are reactive to filters.
# ==============================================================================

# ── Libraries ─────────────────────────────────────────────────────────────────
library(shiny)
library(bslib)
library(bsicons)
library(dplyr)
library(vvnthemes)          # VVN brand theme, colors, and UI components
# library(leaflet)          # Uncomment for interactive county maps
# library(sf)               # Uncomment for spatial data (required with leaflet)
# library(DT)               # Uncomment for interactive data tables
# library(gt)               # Uncomment for styled summary tables
# library(readr)            # Uncomment if loading CSV data in data_prep.R

# ── Load data ─────────────────────────────────────────────────────────────────
# data_prep.R loads your data from data/processed/ into app_data (and
# optionally va_counties for the map tab).
source("R/data_prep.R", local = TRUE)

# ==============================================================================
# UI
# ==============================================================================
ui <- bslib::page_navbar(

  # ── Page title ───────────────────────────────────────────────────────────────
  title = "VVN_TITLE",                   # <-- Replace with your dashboard title
  id    = "main_nav",

  # ── VVN theme — no setup needed, provided by vvnthemes ──────────────────────
  theme          = vvn_bs_theme(),        # VT Maroon + Orange, Bootstrap 5
  navbar_options = bslib::navbar_options(bg = "#861F41", fg = "#FFFFFF"),

  # ── Browser tab title and stylesheet ─────────────────────────────────────────
  header = tagList(
    tags$head(
      tags$link(rel = "stylesheet", href = "vvn.css"),
      tags$title("VVN_TITLE · Visualizing Virginia Numbers")
    )
  ),

  # ── Page footer ──────────────────────────────────────────────────────────────
  footer = tags$footer(
    class = "text-center text-muted small py-2 border-top mt-3",
    "Visualizing Virginia Numbers · Virginia Tech · ",
    tags$a("vvn.vt.edu", href = "https://vvn.vt.edu", target = "_blank")
  ),

  # ============================================================================
  # Tab 1 — Overview
  #   Sidebar filters + 3 KPI cards + static chart PNGs from figures/
  # ============================================================================
  bslib::nav_panel(
    title = tagList(bsicons::bs_icon("house-fill"), " Overview"),
    value = "overview",

    bslib::layout_sidebar(

      # ── Sidebar ─────────────────────────────────────────────────────────────
      sidebar = bslib::sidebar(
        title = "Filters",
        width = 260,
        bg    = "#F7F7F7",

        # ── Categorical filter (e.g., region, group, race/ethnicity) ─────────
        # Uncomment and fill in your choices:
        #
        # vvn_filter(
        #   inputId  = "group_sel",
        #   label    = "[Group Label]",           # <-- e.g., "Region"
        #   choices  = c("All" = "All",
        #                "[Choice A]" = "a",      # <-- label = display, value = data value
        #                "[Choice B]" = "b"),
        #   selected = "All",
        #   multiple = TRUE
        # ),

        # ── Year range slider ────────────────────────────────────────────────
        # Uncomment and set min/max to your data's year range:
        #
        # vvn_slider(
        #   inputId = "year_range",
        #   label   = "Year Range",
        #   min     = [start year],               # <-- e.g., 2018
        #   max     = [end year],                 # <-- e.g., 2023
        #   value   = c([start year], [end year])
        # ),

        # ── Second categorical filter (e.g., variable to display) ────────────
        # Uncomment to let users switch between variables:
        #
        # vvn_filter(
        #   inputId = "variable_sel",
        #   label   = "Variable",
        #   choices = c("[Label A]" = "col_a",    # <-- label = display, value = column name
        #               "[Label B]" = "col_b")
        # ),

        tags$hr(),

        # ── Apply and Reset buttons ──────────────────────────────────────────
        # Remove bindEvent() in the server to apply filters instantly instead.
        #
        # vvn_button("apply_btn", "Apply Filters",
        #             icon  = bsicons::bs_icon("funnel-fill"),
        #             style = "primary"),
        # tags$br(), tags$br(),
        # vvn_button("reset_btn", "Reset",
        #             icon  = bsicons::bs_icon("arrow-counterclockwise"),
        #             style = "outline")
      ),

      # ── Main panel ──────────────────────────────────────────────────────────
      bslib::layout_columns(
        col_widths = 12,
        gap        = "1rem",

        # ── KPI row: 3 metric cards (maroon · orange · navy) ─────────────────
        # KPI values are reactive — computed from filtered data in the server.
        bslib::layout_columns(
          col_widths = c(4, 4, 4),
          gap        = "0.75rem",
          uiOutput("kpi_1"),
          uiOutput("kpi_2"),
          uiOutput("kpi_3")
        ),

        # ── Chart A: static PNG from figures/ (built by scripts/analysis.R) ──
        # Update the filename after running analysis.R.
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            class = "vvn-card-header d-flex align-items-center justify-content-between",
            "[Chart A Title]",                      # <-- Replace
            bslib::popover(
              bsicons::bs_icon("info-circle"),
              "[Describe what this chart shows.]",  # <-- Replace
              title     = "About this chart",
              placement = "left"
            )
          ),
          bslib::card_body(uiOutput("chart_a"))
        ),

        # ── Chart B and C: side by side ────────────────────────────────────────
        bslib::layout_columns(
          col_widths = c(6, 6),
          gap        = "0.75rem",

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("[Chart B Title]",        # <-- Replace
                                class = "vvn-card-header"),
            bslib::card_body(uiOutput("chart_b"))
          ),

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("[Chart C Title]",        # <-- Replace
                                class = "vvn-card-header"),
            bslib::card_body(uiOutput("chart_c"))
          )
        )

        # ── Chart D: optional extra chart (uncomment to add) ──────────────────
        # bslib::card(
        #   full_screen = TRUE,
        #   bslib::card_header("[Chart D Title]", class = "vvn-card-header"),
        #   bslib::card_body(uiOutput("chart_d"))
        # )
      )
    )
  ),

  # ============================================================================
  # Tab 2 — Map
  #   Interactive Leaflet county choropleth (requires leaflet + sf)
  # ============================================================================
  bslib::nav_panel(
    title = tagList(bsicons::bs_icon("map-fill"), " Map"),
    value = "map",

    bslib::card(
      full_screen = TRUE,
      bslib::card_header("[Map Title]", class = "vvn-card-header"),   # <-- Replace
      bslib::card_body(

        # ── Option A: Interactive Leaflet map ─────────────────────────────────
        # Requires: library(leaflet) and library(sf) uncommented above.
        # Requires: va_counties loaded in R/data_prep.R.
        # Uncomment leafletOutput() and the matching renderLeaflet() in server.
        #
        # leaflet::leafletOutput("county_map", height = "580px")

        # ── Option B: Static map PNG from figures/ ────────────────────────────
        # If you saved a static map PNG in scripts/analysis.R, display it here:
        #
        # uiOutput("map_static")

        # Placeholder until map is set up:
        div(
          style = paste(
            "height:580px; display:flex; flex-direction:column;",
            "align-items:center; justify-content:center;",
            "background:#F7F7F7; border-radius:6px; gap:.75rem;"
          ),
          tags$p(style = "color:#861F41; font-weight:700; font-size:1.1rem; margin:0;",
                 "Map Placeholder"),
          tags$p(style = "color:#666; font-size:.85rem; text-align:center;
                          max-width:420px; margin:0; white-space:pre-line;",
                 paste(
                   "Option A — Interactive Leaflet map:",
                   "  1. Place county shapefile in data/processed/va_counties.geojson",
                   "  2. Uncomment va_counties in R/data_prep.R",
                   "  3. Uncomment library(leaflet), library(sf), and leafletOutput() above",
                   "  4. Uncomment renderLeaflet() in the server",
                   "",
                   "Option B — Static PNG from scripts/analysis.R:",
                   "  Uncomment uiOutput('map_static') above and",
                   "  the matching renderUI('map_static') in the server",
                   sep = "\n"
                 ))
        )
      )
    )
  ),

  # ============================================================================
  # Tab 3 — Data Table
  #   Paginated, searchable table with CSV / Excel download
  # ============================================================================
  bslib::nav_panel(
    title = tagList(bsicons::bs_icon("table"), " Data"),
    value = "data",

    bslib::card(
      bslib::card_header("[Data Table Title]", class = "vvn-card-header"),   # <-- Replace
      bslib::card_body(

        # ── Option A: Interactive DT table (recommended for large data) ────────
        # Uncomment and remove the placeholder p() below:
        # DT::dataTableOutput("dt_table")

        # ── Option B: Styled GT table (recommended for small summary tables) ───
        # Uncomment and remove the placeholder p() below:
        # gt::gt_output("gt_table")

        # Placeholder:
        p(style = "color:#888; padding:2rem;",
          "Uncomment DT::dataTableOutput(\"dt_table\") or gt::gt_output(\"gt_table\") above,",
          "then fill in the matching render function in the server.")
      )
    )
  ),

  # ============================================================================
  # Tab 4 — About
  #   Project description, data sources, methods, contact
  # ============================================================================
  bslib::nav_panel(
    title = tagList(bsicons::bs_icon("info-circle"), " About"),
    value = "about",

    bslib::card(
      bslib::card_body(
        tags$h3("About This Dashboard"),
        tags$p("[1–2 sentences describing what this dashboard shows and who it is for.]"),  # <-- Replace
        tags$h4("Data Sources"),
        tags$ul(
          tags$li("[Data source 1: Agency, Dataset, Year]"),   # <-- Replace
          tags$li("[Data source 2: Agency, Dataset, Year]")    # <-- Replace
        ),
        tags$h4("Methods"),
        tags$p("[Describe your data processing steps and any analytical methods.]"),        # <-- Replace
        tags$h4("Contact"),
        tags$p(
          "Built by ",
          tags$a("Visualizing Virginia Numbers (VVN)",
                 href = "https://vvn.vt.edu", target = "_blank"),
          " at Virginia Tech. Questions? ",
          tags$a("vvn@vt.edu", href = "mailto:vvn@vt.edu")
        )
      )
    )
  )
)


# ==============================================================================
# Server
# ==============================================================================
server <- function(input, output, session) {

  # Serve figures/ folder so chart PNGs can be displayed in the browser.
  shiny::addResourcePath("figures", "figures")

  # ── Reactive: filter app_data based on sidebar inputs ────────────────────────
  # Replace [your_group_col], [your_year_col] with your column names.
  # Use bindEvent() so filtering runs only when "Apply Filters" is clicked;
  # remove bindEvent() for instant updates.
  #
  # filtered <- reactive({
  #   d <- app_data
  #
  #   # Filter by categorical group (from vvn_filter "group_sel"):
  #   # if (!("All" %in% (input$group_sel %||% "All"))) {
  #   #   d <- d |> filter([your_group_col] %in% input$group_sel)
  #   # }
  #
  #   # Filter by year range (from vvn_slider "year_range"):
  #   # d <- d |> filter(
  #   #   [your_year_col] >= input$year_range[1],
  #   #   [your_year_col] <= input$year_range[2]
  #   # )
  #
  #   d
  # }) |> bindEvent(input$apply_btn, ignoreNULL = FALSE)

  # ── Reset button: restore filter inputs to their defaults ────────────────────
  # observeEvent(input$reset_btn, {
  #   updateSelectInput(session, "group_sel",    selected = "All")
  #   updateSliderInput(session, "year_range",   value    = c([start year], [end year]))
  #   updateSelectInput(session, "variable_sel", selected = "col_a")
  # })


  # ── KPI card 1 (maroon) ───────────────────────────────────────────────────────
  # Reactive: computed from filtered data. Replace with your own metric.
  #
  # output$kpi_1 <- renderUI({
  #   vvn_kpi_card(
  #     value        = "[statistic]",         # e.g., nrow(filtered()) or a computed value
  #     label        = "[KPI Label]",         # e.g., "Total Counties"
  #     color_scheme = "maroon"
  #   )
  # })

  # ── KPI card 2 (orange) ───────────────────────────────────────────────────────
  # output$kpi_2 <- renderUI({
  #   vvn_kpi_card(
  #     value        = "[statistic]",
  #     label        = "[KPI Label]",
  #     trend        = "up",                  # "up", "down", or NULL — shows arrow
  #     trend_text   = "[+X% vs last year]",  # short trend annotation
  #     color_scheme = "orange"
  #   )
  # })

  # ── KPI card 3 (navy) ────────────────────────────────────────────────────────
  # output$kpi_3 <- renderUI({
  #   vvn_kpi_card(
  #     value        = "[statistic]",
  #     label        = "[KPI Label]",
  #     color_scheme = "navy"
  #   )
  # })


  # ── Chart A: display static PNG from figures/ ─────────────────────────────────
  # Update the filename to match the file saved by scripts/analysis.R.
  # The file.exists() guard shows a helpful message if the chart is not yet built.
  #
  # output$chart_a <- renderUI({
  #   f <- "figures/01_[name].png"    # <-- Replace 01_[name].png with your filename
  #   if (file.exists(f)) {
  #     tags$img(src   = f,
  #              style = "width:100%; display:block;",
  #              alt   = "[Describe the chart for screen readers]")
  #   } else {
  #     tags$p(style = "color:#888; padding:1rem; font-size:.85rem;",
  #            "Chart not found. Run scripts/analysis.R first, then refresh.")
  #   }
  # })

  # ── Chart B ───────────────────────────────────────────────────────────────────
  # output$chart_b <- renderUI({
  #   f <- "figures/02_[name].png"    # <-- Replace with your filename
  #   if (file.exists(f)) {
  #     tags$img(src   = f,
  #              style = "width:100%; display:block;",
  #              alt   = "[Alt text for Chart B]")
  #   } else {
  #     tags$p(style = "color:#888; padding:1rem; font-size:.85rem;",
  #            "Chart not found. Run scripts/analysis.R first, then refresh.")
  #   }
  # })

  # ── Chart C ───────────────────────────────────────────────────────────────────
  # output$chart_c <- renderUI({
  #   f <- "figures/03_[name].png"    # <-- Replace with your filename
  #   if (file.exists(f)) {
  #     tags$img(src   = f,
  #              style = "width:100%; display:block;",
  #              alt   = "[Alt text for Chart C]")
  #   } else {
  #     tags$p(style = "color:#888; padding:1rem; font-size:.85rem;",
  #            "Chart not found. Run scripts/analysis.R first, then refresh.")
  #   }
  # })

  # ── Chart D (optional) ────────────────────────────────────────────────────────
  # output$chart_d <- renderUI({
  #   f <- "figures/04_[name].png"    # <-- Replace with your filename
  #   if (file.exists(f)) {
  #     tags$img(src   = f,
  #              style = "width:100%; display:block;",
  #              alt   = "[Alt text for Chart D]")
  #   } else {
  #     tags$p(style = "color:#888; padding:1rem; font-size:.85rem;",
  #            "Chart not found. Run scripts/analysis.R first, then refresh.")
  #   }
  # })


  # ── Static map PNG (Option B — uncomment if using a saved map PNG) ───────────
  # output$map_static <- renderUI({
  #   f <- "figures/05_[name].png"    # <-- Replace with your map filename
  #   if (file.exists(f)) {
  #     tags$img(src   = f,
  #              style = "width:100%; max-height:580px; object-fit:contain;",
  #              alt   = "[Describe the map for screen readers]")
  #   } else {
  #     tags$p(style = "color:#888; padding:1rem; font-size:.85rem;",
  #            "Map not found. Run scripts/analysis.R first, then refresh.")
  #   }
  # })

  # ── Interactive Leaflet map (Option A) ───────────────────────────────────────
  # Requires: library(leaflet) and library(sf) uncommented above.
  # Requires: va_counties loaded in R/data_prep.R.
  # vvn_map_style() applies VVN Leaflet theme (maroon_seq palette, tooltip).
  #
  # output$county_map <- leaflet::renderLeaflet({
  #   leaflet::leaflet(va_counties) |>
  #     vvn_map_style(
  #       data      = va_counties,
  #       value_col = "[your_value_column]",   # <-- numeric column to map
  #       title     = "[Map Legend Title]"     # <-- e.g., "Poverty Rate (%)"
  #     )
  # })


  # ── DT interactive table — Option A ──────────────────────────────────────────
  # Good for large datasets. Users can search, sort, and download.
  # Uncomment DT::dataTableOutput("dt_table") in the UI above first.
  #
  # output$dt_table <- DT::renderDataTable({
  #   filtered() |>
  #     select([col_1], [col_2], [col_3]) |>   # <-- choose columns to display
  #     arrange(desc([your_year_col])) |>
  #     DT::datatable(
  #       rownames   = FALSE,
  #       class      = "stripe hover compact",
  #       extensions = "Buttons",
  #       options    = list(
  #         pageLength = 15,
  #         scrollX    = TRUE,
  #         dom        = "Bfrtip",
  #         buttons    = c("csv", "excel")    # CSV and Excel download buttons
  #       )
  #     )
  # })


  # ── GT styled table — Option B ────────────────────────────────────────────────
  # Good for small summary tables. vvn_table() applies VVN maroon header style.
  # Uncomment gt::gt_output("gt_table") in the UI above first.
  #
  # output$gt_table <- gt::render_gt({
  #   filtered() |>
  #     group_by([your_group_col]) |>
  #     summarise(
  #       `[Column 1]` = round(mean([col_1], na.rm = TRUE), 1),
  #       `[Column 2]` = round(mean([col_2], na.rm = TRUE), 1),
  #       .groups = "drop"
  #     ) |>
  #     arrange(desc(`[Column 1]`)) |>
  #     gt::gt() |>
  #     vvn_table(
  #       title       = "[Table Title]",
  #       source_note = "Source: [Agency, Dataset, Year]. VVN Analysis."
  #     )
  # })

}

# ── Launch ─────────────────────────────────────────────────────────────────────
shinyApp(ui, server)
