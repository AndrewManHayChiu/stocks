library(httr)
library(ggplot2)


# Download stock data -----------------------------------------------------

get_stock_hist <- function(stock, outputsize = "full") {
  # Download ASX stock data from AlphaVantage
  # 
  # Args:
  #   stock: ticker for stock
  #   outputsize:
  #     - "compact" to get the last 100 days' data
  #     - "full" to get all of the stock's history
  # 
  # Returns:
  #   A data frame of stock data
  
  base <- "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol="
  call <- paste0(base, 
                 stock, 
                 "&outputsize=", outputsize,
                 "&datatype=", "csv",
                 "&apikey=", "THQF7WMIM25XDVCP")
  
  df <- read.csv(call)
  
  df$timestamp <- lubridate::ymd(df$timestamp)
  
  return(df)
}

plot_stock <- function(data.frame, ticker) {
  data.frame %>%
    filter(timestamp > today() - 365) %>%
    ggplot(aes(x = timestamp, y = close)) +
    geom_line(colour = "grey30", size = 1) +
    # geom_col(aes(x = timestamp, y = volume)) +
    # scale_y_continuous(sec.axis = sec_axis(~ / 100, name = "Volume")) +
    scale_x_date(limits = c())+
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")], 
               colour = "red") +
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")] - 7, 
               colour = "grey45") +
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")] + 60, 
               colour = "blue") +
    theme_minimal() +
    theme(panel.grid = element_blank()) +
    labs(title = toupper(ticker),
         x = "",
         y = "Close")
}

get_and_plot <- function(stock, outputsize = "full") {
  df <- get_stock_hist(stock)
  plot_stock(df, stock)
}