# Download Historical Data
# October 2019

# Download historical data, and store each ticker's data in its own CSV file
# Data can be updated with new data using the updateData.R script

# library(dplyr)
# library(tidyr)
library(zoo)

source("src/functions.R")
source("src/listOfTickers.R")

path <- "data/"

# df <- readr::read_csv("data/stocks.csv")

# stocks <- read.csv("data/asx tickers.csv", stringsAsFactors = F)

# randomise stocks
# set.seed(123)
# stocks <- stocks[sample(1:nrow(stocks)), ]

# tickers <- stocks$Code

# stock tickers, grouped by type of stock
# blue  <- c("BHP", "QAN", "TLS", "CSL", "WOW", "MQG", "CBA", "NAB", "WES")
# mid   <- c("NEC", "BKW", "NXT", "CTW", "BKL", "WEB")
# small <- c("IDX", "VRL", "MYR", "AKP", "KMD", "MVF")
# micro <- c("AVZ", "AYS", "4DS", "TWD", "CCV", "SSG")
# 
# tickers <- data.frame(tier = c(rep("blue", length(blue)),
#                                rep("mid", length(mid)),
#                                rep("small", length(small)),
#                                rep("micro", length(micro))),
#                       ticker = c(blue, mid, small, micro))

# Initiate empty data frame to store stock data
# df <- data.frame()

# tickers not already in df
# new_tickers <- setdiff(unique(tickers$ticker), unique(df$code))

# Download daily data
# 5 at a time with free account from AlphaVantage
for (i in 6:10) {
  
  tryCatch({
    print(tickers[i])
    
    data <- get_alphavantage(stock = tickers[i], outputsize = "full")
    
    filePath <- paste0(path, "/daily/",tickers[i], ".csv")
    
    write.zoo(data, filePath, sep = ",", row.names = F)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
  
}

# Download Intraday data
# Because intraday activity can tell a lot about what's happening

for (i in 6:10) {
  
  tryCatch({
    print(tickers[i])
    
    data <- get_alphavantage(stock = tickers[1], series = "TIME_SERIES_INTRADAY", outputsize = "full", interval = "5min")
    
    filePath <- paste0(path, "/intraday/", tickers[i], ".csv")
    
    write.zoo(data, filePath, sep = ",", row.names = F)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
  
}


