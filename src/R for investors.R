# https://www.youtube.com/watch?v=krdgh0e2t6g&feature=youtu.be

library(dplyr)
library(tidyquant)
library(timetk)
library(tibbletime)
library(scales)
library(highcharter)
library(broom)
library(PerformanceAnalytics)

df <- read.csv("data/stocks.csv", stringsAsFactors = F)

df %>%
  filter(code == "BHP") %>%
  hchart(.,
         hcaes(x = timestamp, y = close),
         type = "line")

returns <- df %>%
  select(code, timestamp, close) %>%
  spread(code, close) %>%
  mutate(return = close/lag(close) - 1)