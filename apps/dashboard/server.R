## server.R ##


shinyServer(function(input, output, session) {
  
    
    output$example_plotly <- renderPlotly({
      p <- plot_ly(data = stock_df(),
                   x = ~timestamp, y = ~close,
                   type = "scatter",
                   mode = "lines", name = "Price") %>%
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
    
    # reactive data for selected stock
    stock_df <- reactive({
      
      stock_df <- stocks[stocks$ticker == input$selected_ticker, ]
      
      # convert to xts
      xts(stock_df[, -c(1, 2)], order.by = stock_df$timestamp)
      
    })
    
    output$quantmod_chart <- renderPlot({
      # stock_df <- stocks[stocks$ticker == input$selected_ticker, ]
      # 
      # stock_df <- xts(stock_df[, -c(1, 2)], order.by = stock_df$timestamp)
      
      chartSeries(stock_df(),
                  theme = "white",
                  TA = "addVo(); addSMA()")
    })
    
    output$selected_ticker <- renderText({input$selected_ticker})
    
    output$table_stock_volumes <- renderDataTable({
      data
    })

})
