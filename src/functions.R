library(httr)
library(ggplot2)


# Download stock data -----------------------------------------------------

get_intraday <- function(stock, outputsize = "compact", interval = "5min") {
  # Download intraday stock data from AlphaVantage
  # 
  # Args:
  #   stock: ticker for stock
  #   outputsize:
  #     - "compact" to get the last 100 days' data
  #     - "full" to get all of the stock's history
  # 
  # Returns:
  #   A data frame of stock data
  base <- "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY"
  call <- paste0(base,
                 "&symbol=", "ASX:", stock,
                 "&interval=", interval,
                 "&outputsize=", outputsize,
                 "&apikey=", "THQF7WMIM25XDVCP",
                 "&datatype=", "csv"
                 )
  
  df <- read.csv(call)
  
  df$timestamp <- lubridate::ymd_hms(df$timestamp)
  
  # Return
  df
}

get_sma <- function(stock, interval = "5min", time_period = "20", series_type = "close") {
  base <- "https://www.alphavantage.co/query?function=SMA"
  call <- paste0(base,
                 "&symbol=", "ASX:", stock,
                 "&interval=", interval,
                 "&time_period=", time_period,
                 "&series_type=", series_type,
                 "&apikey=", "THQF7WMIM25XDVCP",
                 "&datatype=", "csv"
                 )
  
  df <- read.csv(call)
  
  df$time <- lubridate::ymd_hm(df$time)
  
  # Return
  df
}

get_alphavantage <- function(stock, series = "TIME_SERIES_DAILY", outputsize = "compact", interval = "5min") {
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
  
  base <- "https://www.alphavantage.co/query?"
  
  if (series == "TIME_SERIES_DAILY") {
    call <- paste0(base, 
                   "function=", series,
                   "&symbol=", "ASX:", stock, 
                   "&outputsize=", outputsize,
                   "&datatype=", "csv",
                   "&apikey=", "THQF7WMIM25XDVCP")
  } else if (series == "TIME_SERIES_INTRADAY") {
    call <- paste0(base, 
                   "function=", series,
                   "&symbol=", "ASX:", stock, 
                   "&outputsize=", outputsize,
                   "&datatype=", "csv",
                   "&interval=", interval,
                   "&apikey=", "THQF7WMIM25XDVCP")
  }

  
  read.csv(call)

}
