library(rvest)
library(pbapply)
library(TTR)
library(dygraphs)
library(lubridate)

# Get amazon data
amzn <- get_stock_hist(stock = "amzn")

amzn$timestamp <- ymd(amzn$timestamp)

amzn <- amzn[order(amzn$timestamp),]
head(amzn)



# Plot amzn
plot(amzn$timestamp, amzn$close)

# Basic Trading Strategy
# 
# Moving average
# Buy when 50-day moving average is below the 200-day moving average
# Sell when 50-day moving average is above the 200-day moving average
amzn$sma_200 <- SMA(amzn$close, n = 200)
amzn$sma_50  <- SMA(amzn$close, n = 50)

head(amzn)
