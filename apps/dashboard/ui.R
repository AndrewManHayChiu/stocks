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
    tabItems(
        tabItem(tabName = "dashboard",
                h2("Dashboard"),
                plotlyOutput("example_plotly"))
    )
)

dashboardPage(header, sidebar, body, skin = "yellow")