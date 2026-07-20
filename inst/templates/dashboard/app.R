# ==============================================================================
# VVN Dashboard Template — app.R
# VVN_TITLE
# VVN_AUTHOR · Visualizing Virginia Numbers · Virginia Tech
#
# QUICK START:
#   1. Load your data in R/data_prep.R
#   2. Replace every [placeholder] with your content
#   3. Uncomment the components you need
#   4. Run: shiny::runApp()
#   5. Deploy: rsconnect::deployApp()
# ==============================================================================

# ── Libraries ─────────────────────────────────────────────────────────────────
library(shiny)
library(bslib)
library(bsicons)
library(ggplot2)
library(dplyr)
library(vvnthemes)          # VVN brand theme, colors, and UI components
# library(leaflet)          # Uncomment for interactive county maps
# library(sf)               # Uncomment for spatial data (required with leaflet)
# library(DT)               # Uncomment for interactive data tables
# library(gt)               # Uncomment for styled summary tables
# library(plotly)           # Uncomment for interactive/hoverable charts
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
  #   Sidebar filters + 3 KPI cards + trend line + bar chart + histogram
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
        bslib::layout_columns(
          col_widths = c(4, 4, 4),
          gap        = "0.75rem",
          uiOutput("kpi_1"),
          uiOutput("kpi_2"),
          uiOutput("kpi_3")
        ),

        # ── Chart A: Trend line ───────────────────────────────────────────────
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            class = "vvn-card-header d-flex align-items-center justify-content-between",
            "[Trend Chart Title]",                  # <-- Replace
            bslib::popover(
              bsicons::bs_icon("info-circle"),
              "[Describe what this chart shows.]",  # <-- Replace tooltip text
              title     = "About this chart",
              placement = "left"
            )
          ),
          bslib::card_body(plotOutput("trend_chart", height = "310px"))
        ),

        # ── Chart B and C: Bar + Histogram (side by side) ─────────────────────
        bslib::layout_columns(
          col_widths = c(7, 5),
          gap        = "0.75rem",

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("[Bar Chart Title]",          # <-- Replace
                                class = "vvn-card-header"),
            bslib::card_body(plotOutput("bar_chart", height = "270px"))
          ),

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("[Distribution Title]",       # <-- Replace
                                class = "vvn-card-header"),
            bslib::card_body(plotOutput("hist_chart", height = "270px"))
          )
        )

        # ── Chart D: Scatter plot (optional — uncomment to add) ───────────────
        # bslib::card(
        #   full_screen = TRUE,
        #   bslib::card_header("[Scatter Title]", class = "vvn-card-header"),
        #   bslib::card_body(plotOutput("scatter_chart", height = "300px"))
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

        # Uncomment when leaflet + sf + your county shapefile are ready:
        # leaflet::leafletOutput("county_map", height = "580px")

        # Placeholder shown until the map is set up:
        div(
          style = paste(
            "height:580px; display:flex; flex-direction:column;",
            "align-items:center; justify-content:center;",
            "background:#F7F7F7; border-radius:6px; gap:.75rem;"
          ),
          tags$p(style = "color:#861F41; font-weight:700; font-size:1.1rem; margin:0;",
                 "County Map Placeholder"),
          tags$p(style = "color:#666; font-size:.85rem; text-align:center;
                          max-width:420px; margin:0; white-space:pre-line;",
                 paste(
                   "To enable the map:",
                   "1. Place your county shapefile in data/processed/va_counties.geojson",
                   "2. Uncomment va_counties in R/data_prep.R",
                   "3. Uncomment library(leaflet) and library(sf) at the top of app.R",
                   "4. Uncomment leafletOutput() above and renderLeaflet() in the server",
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

  # ── Reactive: filter app_data based on sidebar inputs ────────────────────────
  # Replace [your_group_col], [your_year_col], [your_value_col] with your
  # actual column names from app_data. Use bindEvent() so filtering runs only
  # when the user clicks "Apply Filters"; remove it for instant updates.
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
  #   # Select display variable (from vvn_filter "variable_sel"):
  #   # d <- d |> mutate(display_value = .data[[input$variable_sel]])
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
  # Replace value and label with your own metric.
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


  # ── Chart A: Trend line ───────────────────────────────────────────────────────
  # theme_vvn()        — applies the VVN ggplot2 theme
  # scale_color_vvn()  — VVN brand colors for lines/points
  #
  # output$trend_chart <- renderPlot({
  #   req(nrow(filtered()) > 0)
  #   filtered() |>
  #     group_by([your_year_col], [your_group_col]) |>
  #     summarise(v = mean([your_value_col], na.rm = TRUE), .groups = "drop") |>
  #     ggplot(aes(x = [your_year_col], y = v,
  #                color = [your_group_col], group = [your_group_col])) +
  #     geom_line(linewidth = 1.3) +
  #     geom_point(size = 2.8, alpha = 0.9) +
  #     scale_color_vvn("main") +             # palette options: "main", "accessible", "brand"
  #     theme_vvn() +                          # VVN ggplot2 theme
  #     labs(
  #       title    = "[Chart Title]",          # Headline case (capitalize major words)
  #       subtitle = "[Geography · Year range]", # Sentence case
  #       x        = "[X-axis label]",
  #       y        = "[Y-axis label]",
  #       color    = "[Legend title]",
  #       caption  = "Source: [Agency, Dataset, Year]."
  #     )
  # }, res = 110)


  # ── Chart B: Horizontal bar chart ─────────────────────────────────────────────
  # Good for latest-year comparisons or rankings across groups.
  # scale_fill_vvn() fills bars with VVN brand colors.
  #
  # output$bar_chart <- renderPlot({
  #   req(nrow(filtered()) > 0)
  #   filtered() |>
  #     filter([your_year_col] == max([your_year_col])) |>
  #     group_by([your_group_col]) |>
  #     summarise(v = mean([your_value_col], na.rm = TRUE), .groups = "drop") |>
  #     arrange(v) |>
  #     mutate([your_group_col] = factor([your_group_col], levels = [your_group_col])) |>
  #     ggplot(aes(x = v, y = [your_group_col], fill = [your_group_col])) +
  #     geom_col(width = 0.65, show.legend = FALSE) +
  #     geom_text(aes(label = round(v, 1)), hjust = -0.2, size = 3.2, color = "#3D3D3D") +
  #     scale_fill_vvn("main") +
  #     scale_x_continuous(expand = expansion(mult = c(0, .18))) +
  #     theme_vvn(grid = "x") +
  #     labs(
  #       title    = "[Bar Chart Title]",
  #       subtitle = paste("Latest year:", max(filtered()$[your_year_col])),
  #       x        = "[X-axis label]",
  #       y        = NULL,
  #       caption  = "Source: [Agency, Dataset, Year]."
  #     )
  # }, res = 110)


  # ── Chart C: Histogram / distribution ────────────────────────────────────────
  # Shows the distribution of a variable across all rows in filtered data.
  # The orange dashed line marks the mean.
  #
  # output$hist_chart <- renderPlot({
  #   req(nrow(filtered()) > 0)
  #   m <- mean(filtered()$[your_value_col], na.rm = TRUE)
  #   ggplot(filtered(), aes(x = [your_value_col])) +
  #     geom_histogram(bins = 20, fill = "#861F41", color = "#FFFFFF", alpha = 0.85) +
  #     geom_vline(xintercept = m, color = "#E5751F", linewidth = 1.2,
  #                linetype = "dashed") +
  #     annotate("text", x = m, y = Inf, vjust = 2, hjust = -0.1, size = 3,
  #              label = paste0("Mean: ", round(m, 1)), color = "#E5751F") +
  #     theme_vvn() +
  #     labs(
  #       title   = "[Distribution Title]",
  #       x       = "[Variable label]",
  #       y       = "Count",
  #       caption = "Source: [Agency, Dataset, Year]."
  #     )
  # }, res = 110)


  # ── Chart D: Scatter plot (optional) ─────────────────────────────────────────
  # Shows the relationship between two continuous variables.
  # Add color = [your_group_col] to color points by group.
  #
  # output$scatter_chart <- renderPlot({
  #   req(nrow(filtered()) > 0)
  #   ggplot(filtered(), aes(x = [x_col], y = [y_col], color = [your_group_col])) +
  #     geom_point(size = 2.5, alpha = 0.75) +
  #     geom_smooth(method = "lm", se = FALSE, linewidth = 1, linetype = "dashed",
  #                 color = "#3D3D3D") +
  #     scale_color_vvn("main") +
  #     theme_vvn() +
  #     labs(
  #       title    = "[Scatter Title]",
  #       subtitle = "[Describe what the two axes show]",
  #       x        = "[X-axis label]",
  #       y        = "[Y-axis label]",
  #       color    = "[Group label]",
  #       caption  = "Source: [Agency, Dataset, Year]."
  #     )
  # }, res = 110)


  # ── Map: Leaflet county choropleth (optional) ─────────────────────────────────
  # Requires: library(leaflet) and library(sf) uncommented above.
  # Requires: va_counties loaded in R/data_prep.R.
  # vvn_map_style() applies the VVN Leaflet theme (maroon_seq palette, tooltip).
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
  # Uncomment DT::dataTableOutput("dt_table") in the UI above.
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
  # Uncomment gt::gt_output("gt_table") in the UI above.
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
