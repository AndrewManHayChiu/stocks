## ui.R ##

library(shinydashboard)
library(plotly)

width <- 175

header <- dashboardHeader(title = "Dashboard",
                          titleWidth = width)

sidebar <- dashboardSidebar(
    width = width,
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"),
                 badgeLabel = "new", badgeColor = "green")
    )
)

body <- dashboardBody(
    
    tags$head(tags$style(HTML('
                              /* body */
                              .content-wrapper, .right-side {
                              background-color: #ffffff;
                              }
                              '))),
    
    tabItems(
        tabItem(tabName = "dashboard",
                h2("Dashboard"),
                selectInput(inputId = "select",
                            label = h4("Select a stock"), 
                            choices = code_list,
                            selected = 1),
                plotlyOutput("example_plotly")
                )
    )
)

dashboardPage(header, sidebar, body, skin = "yellow")