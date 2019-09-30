## ui.R ##

library(shinydashboard)

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
                plotOutput("example_plot"))
    )
)

dashboardPage(header, sidebar, body, skin = "yellow")