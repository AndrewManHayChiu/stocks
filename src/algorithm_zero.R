# https://malloryanalytics.com/2017/11/30/writing-your-first-trading-algorithm-in-r/

library(dplyr)

# Get data ----------------------------------------------------------------

dailyFiles <- list.files("data/daily", pattern = ".csv")

data <- read.csv(paste0("data/daily/", dailyFiles[2]))

# Filter data to post-2015
data$timestamp <- as.Date(data$timestamp)
data <- data[data$timestamp > as.Date("2015-01-01"), ]

# Flip the data so the latest data is on the bottom
data <- data[nrow(data):1, ]

# Calculate daily gain
data %>%
  mutate(percent.increase = close / lag(close, 1) - 1) %>%
  head()



# Algorithm ---------------------------------------------------------------

# Intuition behind algorithm:
# Buy if the percentage.increase the day before was positive
# Sell if the percentage.increase the day before was negative
# If no change, do nothing

zero_strategy <- function(data) {
  
  data$signal   <- ""  # Buy/Sell/Hold signal
  position <- 0   # Indicate whether stock was bought, sold or no change; start at NULL
  nrows <- nrow(data)
  
  for (i in 3:nrows) {
    if (data$percentage.increase[i - 1] > 0 & position == 0) {
      data$signal[i] <- "buy"
      position       <- 1     # We are now in a bought position
    } 
    else if (y) {
      sell
    } else {
      do_nothing
    }
  }
  
}



# Backtesting -------------------------------------------------------------

# The next step in creating the algorithm is to backtest it.
# To backtest, we need to run the algorithm (function) row by row
# to execute the hypothetical buys and sells.

