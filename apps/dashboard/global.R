## global.R ##

library(readr)
library(dplyr)
library(stringr)
library(quantmod)
library(twitteR)
library(tm)
library(SnowballC)
library(syuzhet)
library(data.table)
library(shiny)
library(ggplot2)
library(plotly)

source("functions.R")

# TODO: migrate this to the daily data code below
df <- read.csv("stocks.csv", stringsAsFactors = F)
df$timestamp <- lubridate::ymd(df$timestamp)
code_list <- as.list(unique(df$code))

# Latest daily data
stocks <- data.frame()
for (file in list.files("data/daily")) {
  temp <- read_csv(paste0("data/daily/", file))
  temp <- select(temp, ticker, timestamp, everything())
  colnames(temp)[3:8] <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
  stocks <- rbind(stocks, temp)
}

ticker_list <- as.list(unique(stocks$ticker))

# Load high volume stock data
files <- list.files("data/volume")

data <- data.frame()

for (i in 1:length(files)) {
  temp <- read_csv(paste0("data/volume/", files[i])) %>%
    mutate(ticker = strsplit(files[i], ".csv")[[1]])
  data <- rbind(data, temp)
}

data <- filter(data,
               week == max(week))