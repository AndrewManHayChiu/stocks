# Download historical data
# Save data in separate CSV files

# Data can be updated with new data using the updateData.R script

# library(zoo)
library(quantmod)

# source("src/functions.R")
# source("src/tickers.R")

asx300 <- readr::read_csv("data/20200401-asx300.csv", skip = 1)

path <- "data"

# TODO: Download data in batches:
# https://cran.r-project.org/web/packages/BatchGetSymbols/vignettes/BatchGetSymbols-vignette.html

# Download daily data
for (ticker in asx300$Code) {
  
  tryCatch({
    
    # data <- get_alphavantage(stock = tickers[i], outputsize = "full")
    
    df_stock <- data.frame(ticker = ticker, 
                           getSymbols(ticker,
                                      src = 'yahoo',
                                      from = Sys.Date() - 365,
                                      to = Sys.Date(),
                                      auto.assign = FALSE)
                           )
    
    df_stock$timestamp <- rownames(df_stock)
    
    readr::write_csv(df_stock, paste0(path, "/daily/", ticker, ".csv"))
    
    readr::write_csv(df_stock, paste0("apps/dashboard/data/daily/", ticker, ".csv"))
    
    print(paste(ticker, ":", "Successfully downloaded", sep = " "))
    
  }, 
  
  # TODO
  warning = {},
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
}

# Download Intraday data

# for (i in 1) {
#   
#   tryCatch({
#     print(tickers[i])
#     
#     data <- get_alphavantage(stock = tickers[1], series = "TIME_SERIES_INTRADAY", outputsize = "full", interval = "5min")
#     
#     filePath <- paste0(path, "/intraday/", tickers[i], ".csv")
#     
#     write.zoo(data, filePath, sep = ",", row.names = F)
#   }, 
#   
#   error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
#   )
# }