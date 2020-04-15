library(quantmod)

files <- list.files("data/daily")

data <- readr::read_csv(paste0("data/daily/", files[1]))

# Convert data to an xts (extensible time series) object 
data <- xts(data[, -1], order.by = data$timestamp)  # timestamp is at column 1

# Changes in price (open and close)
OpCl(data)
OpOp(data)

# Lags
Lag(data$close, c(1, 2, 3))

# SUbsetting is easy usint xts
data["2020"]
data["2019-11::2020-01"]

last(data, "3 weeks")
last(data, "2 months")

# Aggregate to lower frequency data
to.weekly(data)
to.monthly(data)

# How much data is there?
ndays(data); nweeks(data); nyears(data)

# Returns
dailyReturn(data)[1:5]
allReturns(data)[1:5]


# Plotting ----------------------------------------------------------------

barChart(data)

candleChart(data, subset = "2019-11::2020",
            theme = "white", type = "candles")

# Technical analysis from package TTR can be added

chartSeries(data, theme = "white", TA = "addSMA(); addBBands()")
