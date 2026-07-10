# =============================================================================
# VVN Dashboard Template — app.R
# VVN_TITLE
# VVN_AUTHOR · Visualizing Virginia Numbers · Virginia Tech
#
# Run: shiny::runApp()
# Deploy: rsconnect::deployApp()
# =============================================================================

# ── Dependencies ──────────────────────────────────────────────────────────────
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(vvnthemes)
# library(leaflet)   # Uncomment for interactive maps
# library(gt)        # Uncomment for styled tables
# library(DT)        # Uncomment for interactive data tables
# library(plotly)    # Uncomment for interactive charts

# ── Load data ─────────────────────────────────────────────────────────────────
source("R/data_prep.R", local = TRUE)  # defines: app_data, va_regions

# ── VVN bslib theme ───────────────────────────────────────────────────────────
vvn_bs_theme <- bslib::bs_theme(
  version      = 5,
  primary      = "#861F41",
  secondary    = "#E5751F",
  success      = "#2E7D32",
  info         = "#1B5299",
  warning      = "#E5751F",
  danger       = "#C62828",
  base_font    = bslib::font_google("Source Sans Pro", wght = c(400, 600, 700)),
  heading_font = bslib::font_google("Source Sans Pro", wght = c(700)),
  code_font    = bslib::font_google("JetBrains Mono"),
  "navbar-bg"  = "#861F41"
)

# ══════════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════════
ui <- bslib::page_navbar(
  title  = "VVN_TITLE",
  id     = "main_nav",
  bg     = "#861F41",
  fg     = "#FFFFFF",
  theme  = vvn_bs_theme,
  header = tagList(
    tags$head(
      tags$link(rel = "stylesheet", href = "vvn.css"),
      tags$title("VVN_TITLE · Visualizing Virginia Numbers")
    )
  ),
  footer = tags$footer(
    class = "text-center text-muted small py-2 border-top mt-3",
    tags$span(
      "Visualizing Virginia Numbers · Virginia Tech · ",
      tags$a("vvn.vt.edu", href = "https://vvn.vt.edu", target = "_blank")
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # Tab 1: Overview
  # ══════════════════════════════════════════════════════════════════════════
  bslib::nav_panel(
    title = tagList(bslib::bs_icon("house-fill"), " Overview"),
    value = "overview",

    bslib::layout_sidebar(
      # ── Sidebar ──────────────────────────────────────────────────────────
      sidebar = bslib::sidebar(
        title = "Filters",
        width = 260,
        open  = TRUE,
        bg    = "#F7F7F7",

        vvn_filter(
          "region_sel", "Region",
          choices  = c("All" = "All",
                       "Rural"        = "Rural",
                       "Small City"   = "Small City",
                       "Suburban"     = "Suburban",
                       "Urban Fringe" = "Urban Fringe",
                       "Urban Core"   = "Urban Core"),
          selected = "All",
          multiple = TRUE
        ),

        vvn_slider("year_range", "Year Range",
                    min = 2015, max = 2023, value = c(2015, 2023)),

        vvn_filter(
          "variable_sel", "Variable",
          choices = c("Index Value"    = "value",
                       "Employment Rate" = "employment",
                       "Poverty Rate"    = "poverty")
        ),

        hr(),

        vvn_button("apply_btn", "Apply Filters",
                    icon  = bslib::bs_icon("funnel-fill"),
                    style = "primary"),
        tags$br(), tags$br(),
        vvn_button("reset_btn", "Reset",
                    icon  = bslib::bs_icon("arrow-counterclockwise"),
                    style = "outline")
      ),

      # ── Main panel ────────────────────────────────────────────────────────
      bslib::layout_columns(
        col_widths = 12,
        gap        = "1rem",

        # KPI row
        bslib::layout_columns(
          col_widths = c(4, 4, 4),
          gap        = "0.75rem",
          uiOutput("kpi_n"),
          uiOutput("kpi_mean"),
          uiOutput("kpi_change")
        ),

        # Chart row
        bslib::card(
          full_screen = TRUE,
          bslib::card_header(
            class = "vvn-card-header d-flex align-items-center justify-content-between",
            tags$span("Trend Over Time"),
            bslib::popover(
              bslib::bs_icon("info-circle"),
              "Annual trend for the selected variable and regions.",
              title = "About this chart",
              placement = "left"
            )
          ),
          bslib::card_body(
            plotOutput("trend_chart", height = "310px")
          )
        ),

        # Second row: bar + distribution
        bslib::layout_columns(
          col_widths = c(7, 5),
          gap        = "0.75rem",

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("Latest Year Comparison",
                                class = "vvn-card-header"),
            bslib::card_body(plotOutput("bar_chart", height = "270px"))
          ),

          bslib::card(
            full_screen = TRUE,
            bslib::card_header("Value Distribution",
                                class = "vvn-card-header"),
            bslib::card_body(plotOutput("hist_chart", height = "270px"))
          )
        )
      )
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # Tab 2: County Map
  # ══════════════════════════════════════════════════════════════════════════
  bslib::nav_panel(
    title = tagList(bslib::bs_icon("map-fill"), " Map"),
    value = "map",

    bslib::card(
      full_screen = TRUE,
      bslib::card_header("Virginia County Map", class = "vvn-card-header"),
      bslib::card_body(
        # Uncomment when sf + leaflet + county data are available:
        # leaflet::leafletOutput("county_map", height = "580px")

        # Placeholder:
        div(
          style = paste(
            "height:580px; display:flex; flex-direction:column;",
            "align-items:center; justify-content:center;",
            "background:#F7F7F7; border-radius:6px;"
          ),
          tags$p(style = "color:#861F41; font-weight:700; font-size:1.1rem;",
                 "County Map"),
          tags$p(style = "color:#AAAAAA; font-size:.9rem;",
                 "Replace this panel with:"),
          tags$pre(style = "font-size:.8rem; background:#fff; padding:.75rem;
                            border-left:3px solid #861F41; border-radius:4px;",
                   HTML(paste(
                     "library(leaflet)",
                     "library(sf)",
                     "",
                     "leaflet(va_counties) |>",
                     "  vvn_map_style(",
                     "    data      = va_counties,",
                     "    value_col = input$variable_sel,",
                     "    title     = \"Your Variable\"",
                     "  )",
                     sep = "\n"
                   ))
          )
        )
      )
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # Tab 3: Data Table
  # ══════════════════════════════════════════════════════════════════════════
  bslib::nav_panel(
    title = tagList(bslib::bs_icon("table"), " Data"),
    value = "data",

    bslib::card(
      bslib::card_header("Summary Table", class = "vvn-card-header"),
      bslib::card_body(
        # Option A — interactive DT table (default):
        DT::dataTableOutput("dt_table"),

        # Option B — styled GT table:
        # Uncomment and remove DT above:
        # gt::gt_output("gt_table")
      )
    )
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # Tab 4: About
  # ══════════════════════════════════════════════════════════════════════════
  bslib::nav_panel(
    title = tagList(bslib::bs_icon("info-circle"), " About"),
    value = "about",

    bslib::card(
      bslib::card_body(
        tags$h3("About this Dashboard"),
        tags$p(
          "Built by the ",
          tags$a("Visualizing Virginia Numbers (VVN)",
                 href = "https://vvn.vt.edu", target = "_blank"),
          " at Virginia Tech using the ",
          tags$a("vvnthemes", href = "https://github.com/vt-vvn/vvnthemes"),
          " R package."
        ),
        tags$h4("Data Sources"),
        tags$ul(
          tags$li("[Replace with your data source 1]"),
          tags$li("[Replace with your data source 2]")
        ),
        tags$h4("Methods"),
        tags$p("[Describe data processing and any analytical methods.]"),
        tags$h4("Contact"),
        tags$p(tags$a("vvn@vt.edu", href = "mailto:vvn@vt.edu"))
      )
    )
  )
)


# ══════════════════════════════════════════════════════════════════════════════
# Server
# ══════════════════════════════════════════════════════════════════════════════
server <- function(input, output, session) {

  # ── Reactive filtered data ─────────────────────────────────────────────────
  filtered <- reactive({
    req(input$year_range)
    d <- app_data
    if (!("All" %in% (input$region_sel %||% "All")) && length(input$region_sel) > 0) {
      d <- d |> filter(region %in% input$region_sel)
    }
    d |>
      filter(year >= input$year_range[1], year <= input$year_range[2]) |>
      mutate(display_value = .data[[input$variable_sel %||% "value"]])
  }) |> bindEvent(input$apply_btn, ignoreNULL = FALSE)

  # ── Reset button ────────────────────────────────────────────────────────────
  observeEvent(input$reset_btn, {
    updateSelectInput(session, "region_sel",   selected = "All")
    updateSliderInput(session, "year_range",   value    = c(2015, 2023))
    updateSelectInput(session, "variable_sel", selected = "value")
  })

  # ── KPI cards ──────────────────────────────────────────────────────────────
  output$kpi_n <- renderUI({
    n <- n_distinct(filtered()$region)
    vvn_kpi_card(paste0(n, " Region", if(n!=1)"s"), "In Selection",
                  color_scheme = "maroon")
  })

  output$kpi_mean <- renderUI({
    m <- round(mean(filtered()$display_value, na.rm = TRUE), 1)
    vvn_kpi_card(m, "Average Value", color_scheme = "orange")
  })

  output$kpi_change <- renderUI({
    d  <- filtered()
    v1 <- mean(d$display_value[d$year == min(d$year)], na.rm = TRUE)
    v2 <- mean(d$display_value[d$year == max(d$year)], na.rm = TRUE)
    ch <- round(v2 - v1, 1)
    vvn_kpi_card(
      value        = paste0(if(ch >= 0) "+" else "", ch),
      label        = paste0("Change (", min(d$year), "\u2013", max(d$year), ")"),
      trend        = if(ch >= 0) "up" else "down",
      trend_text   = paste0(abs(round(ch/v1*100)), "% vs start"),
      color_scheme = "navy"
    )
  })

  # ── Trend chart ─────────────────────────────────────────────────────────────
  output$trend_chart <- renderPlot({
    req(nrow(filtered()) > 0)

    filtered() |>
      group_by(year, region) |>
      summarise(v = mean(display_value, na.rm = TRUE), .groups = "drop") |>
      ggplot(aes(x = year, y = v, color = region, group = region)) +
      geom_line(linewidth = 1.3) +
      geom_point(size = 2.8, alpha = 0.9) +
      scale_color_vvn("main") +
      theme_vvn() +
      labs(
        title    = "Trend by Region",
        subtitle = paste0(input$year_range[1], "\u2013", input$year_range[2]),
        x        = "Year",
        y        = "Value",
        color    = "Region",
        caption  = "Source: [Replace with data source]"
      )
  }, res = 110)

  # ── Bar chart ───────────────────────────────────────────────────────────────
  output$bar_chart <- renderPlot({
    req(nrow(filtered()) > 0)

    latest <- filtered() |>
      filter(year == max(year)) |>
      group_by(region) |>
      summarise(v = mean(display_value, na.rm = TRUE), .groups = "drop") |>
      arrange(v) |>
      mutate(region = factor(region, levels = unique(region)))

    ggplot(latest, aes(x = v, y = region, fill = region)) +
      geom_col(width = 0.65, show.legend = FALSE) +
      geom_text(aes(label = round(v, 1)), hjust = -0.2, size = 3.2,
                color = "#3D3D3D") +
      scale_fill_vvn("main") +
      scale_x_continuous(expand = expansion(mult = c(0, .18))) +
      theme_vvn(grid = "x") +
      remove_ticks() +
      labs(title = paste("Comparison ·", max(filtered()$year)),
           x = "Value", y = NULL)
  }, res = 110)

  # ── Histogram ───────────────────────────────────────────────────────────────
  output$hist_chart <- renderPlot({
    req(nrow(filtered()) > 0)

    m <- mean(filtered()$display_value, na.rm = TRUE)
    ggplot(filtered(), aes(x = display_value)) +
      geom_histogram(bins = 18, fill = "#861F41", color = "#FFFFFF", alpha = 0.9) +
      geom_vline(xintercept = m, color = "#E5751F", linewidth = 1.2, linetype = "dashed") +
      annotate("text", x = m + 0.3, y = Inf, vjust = 2, hjust = 0, size = 3,
               label = paste0("Mean: ", round(m, 1)), color = "#E5751F") +
      theme_vvn() +
      labs(title = "Distribution", x = "Value", y = "Count")
  }, res = 110)

  # ── DT table ────────────────────────────────────────────────────────────────
  output$dt_table <- DT::renderDataTable({
    filtered() |>
      group_by(region, year) |>
      summarise(
        `Value`      = round(mean(display_value, na.rm = TRUE), 2),
        `Employment` = round(mean(employment,    na.rm = TRUE), 1),
        `Poverty %`  = round(mean(poverty,        na.rm = TRUE), 1),
        .groups      = "drop"
      ) |>
      arrange(desc(year), region) |>
      DT::datatable(
        rownames = FALSE,
        class    = "stripe hover compact",
        options  = list(
          pageLength = 15,
          scrollX    = TRUE,
          dom        = "Bfrtip",
          buttons    = c("csv", "excel")
        ),
        extensions = "Buttons"
      ) |>
      DT::formatStyle(
        "Value",
        background = DT::styleColorBar(range(filtered()$display_value, na.rm = TRUE),
                                        "#F5C8D4"),
        backgroundSize    = "100% 80%",
        backgroundRepeat  = "no-repeat",
        backgroundPosition = "center"
      )
  })

  # ── GT table (optional alternative) ─────────────────────────────────────────
  # output$gt_table <- gt::render_gt({
  #   filtered() |>
  #     group_by(region, year) |>
  #     summarise(Mean = round(mean(display_value, na.rm = TRUE), 1), .groups = "drop") |>
  #     gt::gt() |>
  #     vvn_table(title = "Summary by Region & Year",
  #                source_note = "Source: [Replace with data source]")
  # })

  # ── County map (optional) ────────────────────────────────────────────────────
  # output$county_map <- leaflet::renderLeaflet({
  #   leaflet::leaflet(va_counties) |>
  #     vvn_map_style(
  #       data      = va_counties,
  #       value_col = input$variable_sel,
  #       title     = switch(input$variable_sel,
  #         value      = "Index Value",
  #         employment = "Employment Rate (%)",
  #         poverty    = "Poverty Rate (%)"
  #       )
  #     )
  # })
}

# ── Launch ────────────────────────────────────────────────────────────────────
shinyApp(ui, server)
