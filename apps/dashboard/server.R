## server.R ##
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

    output$example_plot <- renderPlot({
        ggplot(data = anz,
               aes(x = date, y = close)) +
            geom_line() +
            labs(title = "stock price")
    })
})
