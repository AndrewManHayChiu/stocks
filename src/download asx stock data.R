library(dplyr)
library(tidyr)

source("src/functions.R")

# stocks <- read.csv("data/asx tickers.csv", stringsAsFactors = F)

# randomise stocks
# set.seed(123)
# stocks <- stocks[sample(1:nrow(stocks)), ]

# tickers <- stocks$Code

blue  <- c("BHP", "QAN", "TLS", "CSL", "WOW", "MQG", "CBA", "NAB", "WES")
mid   <- c("NEC", "BKW", "NXT", "CTW", "BKL", "WEB")
small <- c("IDX", "VRL", "MYR", "AKP", "KMD", "MVF")
micro <- c("AVZ", "AYS", "4DS", "TWD", "CCV", "SSG")



tickers <- data.frame(blue, mid, small, micro) %>%
  gather(tier, ticker)

# Initiate empty data frame to store stock data
df <- data.frame()

for (i in 11:15) {
  
  tryCatch({
    print(paste(tickers$ticker[i], ":", i, "of", length(tickers$ticker)))
    
    data <- get_alphavantage(stock = tickers$ticker[i], outputsize = "full") %>%
      mutate(code = tickers$ticker[i])
    
    df <- rbind(df, data)
  }, error = function(e){cat("ERROR :", conditionMessage(e), "\n")})
  
}

write.csv(df, "data/stocks.csv", row.names = F)
