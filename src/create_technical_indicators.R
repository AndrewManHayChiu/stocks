library(dplyr)
library(smooth)

library(quantmod)
library(zoo)
library(xts)

ven <- df[df$code == "VEN", 1:6]

ven <- as.data.frame(ven)

row.names(ven) <- ven$timestamp

ven <- as.xts(ven[, 2:6])

ven

class(ven)

head(ven)

plot(ven$close, main = "VEN")

candleChart(ven, up.col = "black", dn.col = "red")
