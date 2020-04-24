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

asx300 <- read.csv("data/20200401-asx300.csv", stringsAsFactors = FALSE, skip = 1)
asx300$Code <- paste0(asx300$Code, ".AX")

# Latest daily data
stocks <- data.frame()
for (file in list.files("data/daily")) {
  temp <- read_csv(paste0("data/daily/", file), progress = FALSE)
  temp <- select(temp, ticker, timestamp, everything())
  colnames(temp)[3:8] <- c("Open", "High", "Low", "Close", "Volume", "Adjusted")
  stocks <- rbind(stocks, temp)
}

ticker_list <- as.list(unique(stocks$ticker))

# Load high volume stock data
files <- list.files("data/volume")

data <- data.frame()

for (i in 1:length(files)) {
  temp <- read_csv(paste0("data/volume/", files[i]), progress = FALSE) %>%
    mutate(ticker = strsplit(files[i], ".csv")[[1]])
  data <- rbind(data, temp)
}

data <- filter(data,
               week == max(week))
