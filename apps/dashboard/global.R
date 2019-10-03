## global.R ##

library(readr)
library(dplyr)
library(stringr)

source("functions.R")

df <- read.csv("stocks.csv", stringsAsFactors = F)

df$timestamp <- lubridate::ymd(df$timestamp)

code_list <- as.list(unique(df$code))
