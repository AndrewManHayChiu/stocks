library(quantmod)
library(dplyr)
library(readr)

# Load data
files <- list.files("data/daily")

# TODO: Check whether there are any inconsistencies in the files

for (i in 1:length(files)) {
  df_stock <- read_csv(paste0("data/daily/", files[i]))
  
  # Reorder columns
  df_stock <- select(df_stock, timestamp, ticker, everything())
  
  # Remove ticker-specific words in column names
  names(df_stock)[3:ncol(df_stock)] <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
  
  ticker <- df_stock$ticker[1]
  
  # Convert data to an xts (extensible time series) object 
  df_stock <- xts(df_stock[, -c(1, 2)], order.by = df_stock$timestamp)
  
  weekly_data  <- to.weekly(df_stock)
  monthly_data <- to.monthly(df_stock)
  
  stock_volumes <- data.frame(ticker = ticker,
                              week = index(weekly_data)[nrow(weekly_data)],
                              volume = as.numeric(weekly_data[nrow(weekly_data), ]$df_stock.Volume))
  tryCatch(
    expr = {
      stock_volumes <- stock_volumes %>%
        mutate(volume_last_month = as.numeric(monthly_data[nrow(monthly_data) - 1, ]$df_stock.Volume),
               volume_to_last_month = as.numeric(volume / volume_last_month))
      
      zoo::write.zoo(weekly_data, paste0("data/weekly/", ticker))
      # zoo::write.zoo(weekly_data, paste0("apps/dashboard/data/weekly/", ticker))
      zoo::write.zoo(monthly_data, paste0("data/monthly/", ticker))
      # zoo::write.zoo(monthly_data, paste0("apps/dashboard/data/monthly/", ticker))
      readr::write_csv(stock_volumes, paste0("apps/dashboard/data/volume/", ticker, ".csv"))
    },
    
    error = function(e) {
      message("There may be NA values in the latest data")
    },
    
    finally = {
      message("Moving onto the next ticker")
    }
  )
  
}