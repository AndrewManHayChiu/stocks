library(dplyr)
library(tidyr)

source("src/functions.R")

df <- readr::read_csv("data/stocks.csv")

# stocks <- read.csv("data/asx tickers.csv", stringsAsFactors = F)

# randomise stocks
# set.seed(123)
# stocks <- stocks[sample(1:nrow(stocks)), ]

# tickers <- stocks$Code

# stock tickers, grouped by type of stock
blue  <- c("BHP", "QAN", "TLS", "CSL", "WOW", "MQG", "CBA", "NAB", "WES")
mid   <- c("NEC", "BKW", "NXT", "CTW", "BKL", "WEB")
small <- c("IDX", "VRL", "MYR", "AKP", "KMD", "MVF")
micro <- c("AVZ", "AYS", "4DS", "TWD", "CCV", "SSG")

tickers <- data.frame(tier = c(rep("blue", length(blue)),
                               rep("mid", length(mid)),
                               rep("small", length(small)),
                               rep("micro", length(micro))),
                      ticker = c(blue, mid, small, micro))

# Initiate empty data frame to store stock data
# df <- data.frame()

# tickers not already in df
new_tickers <- setdiff(unique(tickers$ticker), unique(df$code))

# Download daily data
for (i in 5:9) {
  
  tryCatch({
    print(new_tickers[i])
    
    data <- get_alphavantage(stock = new_tickers[i], outputsize = "full") %>%
      mutate(code = new_tickers[i])
    
    df <- rbind(df, data)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
  
}

readr::write_csv(df, "data/stocks.csv")

# Intraday data
# Because intraday activity can tell a lot about what's happening
