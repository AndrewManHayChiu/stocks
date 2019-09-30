## server.R ##
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

    output$example_plot <- renderPlot({
        ggplot(data = stock_amzn,
               aes(x = date, y = close)) +
            geom_line() +
            labs(title = "Amazon (USD)")
    })
})
