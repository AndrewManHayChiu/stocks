## global.R ##

library(readr)
library(dplyr)
library(stringr)

source("../../src/functions.R")

anz <- get_stock_hist(stock = "ASX:ANZ")

# stock_amzn <- read_csv("http://sharpsightlabs.com/wp-content/uploads/2017/09/AMZN_stock.csv")

# colnames(stock_amzn) <- colnames(stock_amzn) %>% str_to_lower()
