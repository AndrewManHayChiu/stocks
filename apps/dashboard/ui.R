## ui.R ##

library(shinydashboard)
library(plotly)

width <- 250

header <- dashboardHeader(title = "Stock Dashboard",
                          titleWidth = width)

sidebar <- dashboardSidebar(
    
    tags$head(tags$style(HTML('
                              /* sidebar */
                              {
                              background-color: #000000;
                              }
                              '))),
    
    width = width,
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"),
                 badgeLabel = "empty", badgeColor = "black"),
        
        menuItem("Stock", tabName = "stock", icon = icon("chart-line"),
                 badgeLabel = "new", badgeColor = "green"),
        
        menuItem("High Vol Stocks", tabName = "hv_stocks", icon = icon("chart-bar"),
                 badgeLabel = "new", badgeColor = "green"),
        
        menuItem("Research", tabName = "research",
                 icon = icon("user-graduate"), 
                 badgeLabel = "empty", badgeColor = "black"),
        
        menuItem("Disclaimer", tabName = "disclaimer",
                 icon = icon("question"))
    )
)

body <- dashboardBody(
    
    tags$head(tags$style(HTML('
                              /* navbar */
                              .skin-blue .main-header .navbar {
                              background-color: #000000;
                              }
                              
                              /* main sidebar */
                              .skin-blue .main-sidebar {
                              background-color: #000000;
                              }
                              
                              /* body */
                              .content-wrapper, .right-side {
                              background-color: #ffffff;
                              }
                              '))),
    
    tabItems(
        tabItem(tabName = "dashboard",
                
                # Value boxes
                fluidRow(
                    valueBox(value = "X,XXX, (X.XX%)", subtitle = "ASX 200", icon = icon("chart-line"), color = "red"),
                    
                    valueBox(value = "1 : 0.XX", subtitle = "AUD/USD", icon = icon("dollar-sign"), color = "yellow"),
                    
                    valueBox(value = "X", subtitle = "VIX Index", color = "green")
                ),
                
                h2("Dashboard")
                ),
        
        tabItem(tabName = "stock",
                h2("Stock"),
                selectInput(inputId = "selected_ticker",
                            label = h4("Select a stock"), 
                            # choices = code_list,
                            choices = ticker_list,
                            selected = 1),
                # plotlyOutput("example_plotly")
                
                plotOutput("quantmod_chart"),
                sliderInput(inputId = "date_slider",
                            # min = as.Date("2019-01-01"),
                            min = as.Date(Sys.Date() - 365),
                            max = as.Date(Sys.Date()),
                            value = c(as.Date(Sys.Date() - 365), as.Date(Sys.Date())),
                            label = "Select date range",
                            width = "100%"),
                br(),
                dataTableOutput("stock_data_table"),
                downloadButton("download_data", "Download as CSV")
                
                ),
        
        tabItem(tabName = "hv_stocks",
                
                h2("Stock volumes"),
                dataTableOutput("table_stock_volumes")
                
                ),
        
        tabItem(tabName = "research",
                h2("Research"),
                br(),
                p("Research on trading strategies will be found here.")),
        
        tabItem(tabName = "disclaimer",
                h2("Disclaimer"),
                br(),
                p("This site contains out-of-date ASX market data."),
                br(),
                p("All content is provided 'as is' and not for trading purposes"),
                br(),
                p("No information should be considered financial advice or used to make an investment decision.")
                )
    )
)

dashboardPage(header, sidebar, body, skin = "yellow")