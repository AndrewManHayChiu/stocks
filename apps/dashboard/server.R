## server.R ##
library(shiny)
library(ggplot2)
library(plotly)

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

shinyServer(function(input, output, session) {
    
    # reactive data for selected stock
    stock_df <- reactive({
      df[df$code == input$select, ]
    })
    
    output$example_plotly <- renderPlotly({
      p <- plot_ly(data = stock_df(),
                   x = ~timestamp, y = ~close,
                   type = "scatter",
                   mode = "lines", name = "Price") %>%
        # add_trace(x = ~timestamp, type = "ohlc",
        #           open = ~open, close = ~close,
        #           high = ~high, low = ~low) %>%
        # add_trace(y = ~SMA, name = "SMA", line = list(dash = "dash")) %>%
        layout(yaxis = list(title = "Price"))
      pp <- plot_ly(data = stock_df(),
                    x = ~timestamp, y = ~volume,
                    type = "bar", name = "Volume") %>%
        layout(yaxis = list(title = "Volume"))
      ppp <- plot_ly(data = stock_df(),
                     x = ~timestamp, type = "ohlc",
                     open = ~open, close = ~close,
                     high = ~high, low = ~low) %>%
        layout(yaxis = list(title = "Price"))

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
      p <- subplot(p, pp, ppp, heights = c(0.4, 0.2, 0.4), nrows = 3,
                   shareX = TRUE, titleY = TRUE) %>%
        layout(title = input$select,
               xaxis = list(rangeslider = rs, title = ""),
               legend = list(orientation = "h", x = 0.5, y = 1,
                             xanchor = "center", yref = "paper",
                             bgcolor = "transparent"))
      p

    })
    
    
    tweets_df <- reactive({
      tweets <- searchTwitter(input$stringSearch, n = 25)
      
      twListToDF(tweets)
    })
    
    output$searchResults <- renderTable({
      
      tweets_df()[, c(1, 11, 12)]
      
    })

})
