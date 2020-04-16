#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(readr)
library(quantmod)
library(lubridate)
library(data.table)

# Load data
files <- list.files("data")

data <- data.frame()

for (i in 1:length(files)) {
    temp <- read_csv(paste0("data/", files[i])) %>%
        mutate(ticker = strsplit(files[i], ".csv")[[1]])
    data <- rbind(data, temp)
}

data <- filter(data,
               week == max(week))

# TODO: Update stock volume data nightly

# Calculate volume ratios


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Stock volumes"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            # sliderInput("bins",
            #             "Number of bins:",
            #             min = 1,
            #             max = 50,
            #             value = 30)
            
            p("IN DEVELOPMENT"),
            p("Source: Yahoo Finance")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h2("Stock volumes"),
            dataTableOutput("table_stock_volumes")
            
            # h2("Monthly trading volume"),
            # plotOutput("chart_monthly_volume"),
            # 
            # h2("Stock data"),
            # dataTableOutput("ticker_data") 
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # })
    
    output$table_stock_volumes <- renderDataTable({
        data
    })
    
    # output$ticker_data <- renderDataTable({
    #     data.frame(weekly_data) %>%
    #         mutate(week = index(weekly_data)) %>%
    #         select(week, everything()) %>%
    #         arrange(desc(week))
    # })
    
    # output$chart_monthly_volume <- renderPlot({
    #     plot(monthly_data$data.Volume,
    #          main = "Monthly Volume ($ Traded)")
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)
