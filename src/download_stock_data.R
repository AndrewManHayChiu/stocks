# Download historical data
# Save data in separate CSV files

# Data can be updated with new data using the updateData.R script

library(zoo)

source("src/functions.R")
source("src/tickers.R")

path <- "data"

# Download daily data
# 5 at a time with free account from AlphaVantage
for (i in 1) {
  
  tryCatch({
    print(tickers[i])
    
    data <- get_alphavantage(stock = tickers[i], outputsize = "full")
    
    filepath <- paste0(path, "/daily/",tickers[i], ".csv")
    
    readr::write_csv(data, filepath)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
}

# Download Intraday data

for (i in 1) {
  
  tryCatch({
    print(tickers[i])
    
    data <- get_alphavantage(stock = tickers[1], series = "TIME_SERIES_INTRADAY", outputsize = "full", interval = "5min")
    
    filePath <- paste0(path, "/intraday/", tickers[i], ".csv")
    
    write.zoo(data, filePath, sep = ",", row.names = F)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
}