library(dplyr)

source("src/functions.R")

stocks <- read.csv("data/asx tickers.csv", stringsAsFactors = F)

# randomise stocks
set.seed(123)
stocks <- stocks[sample(1:nrow(stocks)), ]

tickers <- stocks$Code

# Initiate empty data frame to store stock data
df <- data.frame()

for (i in 1:length(tickers[1:5])) {
  
  tryCatch({
    print(paste(tickers[i], ":", i, "of", length(tickers)))
    
    data <- get_alphavantage(stock = tickers[i]) %>%
      mutate(code = tickers[i])
    
    df <- rbind(df, data)
  }, error = function(e){cat("ERROR :", conditionMessage(e), "\n")})
  
}

write.csv(df, "data/stocks.csv", row.names = F)
