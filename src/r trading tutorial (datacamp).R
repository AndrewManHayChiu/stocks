library(rvest)
library(pbapply)
library(TTR)
library(dygraphs)
library(lubridate)

# Get amazon data
amzn <- get_stock_hist(stock = "amzn")

amzn$timestamp <- ymd(amzn$timestamp)

head(amzn)


# Plot amzn
plot(amzn$timestamp, amzn$close)

dygraph(amzn$close) %>%
  dyRangeSelector(dateWindow = c("2013-12-18", "2016-12-30"))