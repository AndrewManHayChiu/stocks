#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Sentiments")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("About", tabName = "about", icon = icon("question"))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "dashboard",
                h2("TEST"),
                textInput("stringSearch", label = h3("Search twitter"), value = "Hong Kong"),
                hr(),
                tableOutput("searchResults")
                ),
        
        tabItem(tabName = "about",
                h2("About"))
    )
)

dashboardPage(header, sidebar, body)