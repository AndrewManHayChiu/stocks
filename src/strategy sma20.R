stocks <- read.csv("data/stocks.csv")

head(stocks)
table(stocks$code)

bhp <- stocks[stocks$code == "BHP",]

bhp <- bhp[nrow(bhp):1, ]

library(smooth)

sma(bhp$close, h = 20, silent = FALSE)

library(dplyr)
library(zoo)
library(ggplot2)

bhp %>%
  mutate(timestamp = lubridate::ymd(timestamp),
         sma20 = lag(rollapply(close, 20, mean, align = "right", fill = NA), 1)) %>%
  filter(timestamp > lubridate::ymd("2018-01-01")) %>%
  ggplot() +
  geom_line(aes(x = timestamp, y = close)) +
  geom_line(aes(x = timestamp, y = sma20))

# Buy if above sma
# Sell if below sma

temp <- bhp %>%
  mutate(timestamp = lubridate::ymd(timestamp),
         sma20 = lag(rollapply(close, 20, mean, align = "right", fill = NA), 1)) %>%
  filter(!is.na(sma20),
         close > 0) %>%
  mutate(buy = ifelse(high > sma20, 1, 0),
         sell = ifelse(high < sma20, 1, 0),
         close.1 = lag(close, 1),
         long.return = close / close.1 - 1,
         return = ifelse(buy == 1, long.return, 0))

mean(temp$return, na.rm = T) * 100

qan <- stocks[stocks$code == "QAN",]

qan <- qan[nrow(qan):1, ]

qan %>%
  mutate(timestamp = lubridate::ymd(timestamp),
         sma20 = lag(rollapply(close, 20, mean, align = "right", fill = NA), 1)) %>%
  filter(timestamp > lubridate::ymd("2018-01-01")) %>%
  ggplot() +
  geom_line(aes(x = timestamp, y = close)) +
  geom_line(aes(x = timestamp, y = sma20))

temp <- qan %>%
  mutate(timestamp = lubridate::ymd(timestamp),
         sma20 = lag(rollapply(close, 20, mean, align = "right", fill = NA), 1)) %>%
  filter(!is.na(sma20),
         close > 0) %>%
  mutate(buy = ifelse(high > sma20, 1, 0),
         sell = ifelse(high < sma20, 1, 0),
         close.1 = lag(close, 1),
         long.return = close / close.1 - 1,
         return = ifelse(buy == 1, long.return, 0))

mean(temp$return, na.rm = T) * 100
sum(temp$return, na.rm = T) / sum(temp$buy) * 100

#10k, 10$ transaction cost
(10000 * (1.001712181) ^ 64 - 4 * 10) / 10000 - 1
