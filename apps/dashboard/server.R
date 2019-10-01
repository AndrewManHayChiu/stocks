## server.R ##
library(shiny)
library(ggplot2)
library(plotly)

shinyServer(function(input, output) {

    output$example_plot <- renderPlot({
        ggplot(data = anz,
               aes(x = date, y = close)) +
            geom_line() +
            labs(title = "stock price")
    })
    
    output$example_plotly <- renderPlotly({
      p <- plot_ly(data = apt,
                   x = ~timestamp, y = ~close, 
                   mode = "lines", name = "Price") %>%
        layout(yaxis = list(title = "Price"))
      pp <- plot_ly(data = apt, 
                    x = ~timestamp, y = ~volume,
                    type = "bar", name = "Volume") %>%
        layout(yaxis = list(title = "Volume"))
      # Create range selector buttons
      rs <- list(visible = TRUE, x = 0.5, y = -0.055,
                 xanchor = 'center', yref = 'paper',
                 font = list(size = 9),
                 buttons = list(
                   list(count=1,
                        label='RESET',
                        step='all'),
                   list(count=1,
                        label='1 YR',
                        step='year',
                        stepmode='backward'),
                   list(count=3,
                        label='3 MO',
                        step='month',
                        stepmode='backward'),
                   list(count=1,
                        label='1 MO',
                        step='month',
                        stepmode='backward')
                 ))
      
      # Subplot with shared axis
      p <- subplot(p, pp, heights = c(0.7, 0.2), nrows = 2,
                   shareX = TRUE, titleY = TRUE) %>%
        layout(title = "APT",
               xaxis = list(rangeslider = rs),
               legend = list(orientation = "h", x = 0.5, y = 1,
                             xanchor = "center", yref = "paper",
                             bgcolor = "transparent"))
      p
    })
})
