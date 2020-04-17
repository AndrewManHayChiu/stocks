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

# consumer_key <- "Kd73j91fK92S3zE9FGRzSUhV5"
# consumer_secret <- "TTJtzDJEvMJh5U5qdo77DomD1NizybPACIrtYhDpREmUiZ1kKa"
# access_token <- "918349387436142592-ilRsc6nL7NeB10dwYf1NE6r9lTFmrKh"
# access_secret <- "zokmIkiTkAxLoVZ2e0fqNboUSW3HKK45x2tWYISP2HXKe"


df <- read.csv("stocks.csv", stringsAsFactors = F)

df$timestamp <- lubridate::ymd(df$timestamp)

code_list <- as.list(unique(df$code))

# Load high volume stock data
files <- list.files("data")

data <- data.frame()

for (i in 1:length(files)) {
  temp <- read_csv(paste0("data/", files[i])) %>%
    mutate(ticker = strsplit(files[i], ".csv")[[1]])
  data <- rbind(data, temp)
}

data <- filter(data,
               week == max(week))