## global.R ##

library(readr)
library(dplyr)
library(stringr)

source("functions.R")

apt <- get_stock_hist(stock = "ASX:APT")