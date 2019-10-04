## ui.R ##

library(shinydashboard)
library(plotly)

width <- 175

header <- dashboardHeader(title = "",
                          titleWidth = width)

sidebar <- dashboardSidebar(
    
    tags$head(tags$style(HTML('
                              /* sidebar */
                              {
                              background-color: #ffffff;
                              }
                              '))),
    
    width = width,
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"),
                 badgeLabel = "new", badgeColor = "green"),
        menuItem("Sentiments", tabName = "sentiments",
                 icon = icon("laugh-squint"),
                 badgeLabel = "empty", badgeColor = "black"),
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
                              background-color: #ffffff;
                              }
                              
                              /* main sidebar */
                              .skin-blue .main-sidebar {
                              background-color: #ffffff;
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
                    valueBox(value = "6,493, (-2.21%)", subtitle = "ASX 200", icon = icon("chart-line"), color = "red"),
                    
                    valueBox(value = "1 : 0.67", subtitle = "AUD/USD", icon = icon("dollar-sign"), color = "yellow"),
                    
                    valueBox(value = "Normal", subtitle = "VIX Index", color = "green")
                ),
                
                h2("Dashboard"),
                selectInput(inputId = "select",
                            label = h4("Select a stock"), 
                            choices = code_list,
                            selected = 1),
                plotlyOutput("example_plotly")
                ),
        
        tabItem(tabName = "sentiments",
                h2("Sentiment"),
                br(),
                textInput("stringSearch", label = h3("Search twitter"), value = "ASX"),
                hr(),
                tableOutput("searchResults")),
        
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

dashboardPage(header, sidebar, body, skin = "black")