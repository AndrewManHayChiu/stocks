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
    

# Stock page --------------------------------------------------------------
    
    # stock data
    stock_df <- reactive({
      stocks[stocks$ticker == input$selected_ticker &
               stocks$timestamp > input$date_slider[1] &
               stocks$timestamp < input$date_slider[2], ]
    })
    
    # xts version of stock_df
    stock_xts <- reactive({
      xts(stock_df()[, -c(1, 2)], order.by = stock_df()$timestamp)
      
    })
    
    output$quantmod_chart <- renderPlot({
      chartSeries(stock_xts(),
                  theme = "white",
                  TA = "addVo(); addSMA()",
                  name = input$selected_ticker)
    })
    
    # output$selected_ticker <- renderText({
    #   input$selected_ticker
    # })
    
    output$company_name <- renderText({
      as.character(asx300[asx300$Code == input$selected_ticker, ]$Company)
    })
    
    output$company_sector <- renderText({
      asx300[asx300$Code == input$selected_ticker, ]$Sector
    })
    
    output$min_date <- renderText({
      as.character(min(stock_df()$timestamp))
    })
    
    output$stock_data_table <- renderDataTable({
      stock_df()
    })
    
    output$download_data <- downloadHandler(
      filename = function() {
        paste(input$selected_ticker, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(stock_df(), file, row.names = FALSE)
      }
    )

# High Vol Stocks page -------------------------------------------------
    
    # Table for stock volume ratio
    output$table_stock_volumes <- renderDataTable({
      data
    })
    
    

})
