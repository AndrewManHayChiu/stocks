# https://blogs.rstudio.com/tensorflow/posts/2017-12-20-time-series-forecasting-with-recurrent-neural-networks/

# Core Tidyverse
library(tidyverse)
library(glue)
library(forcats)
library(readr)

# Time Series
library(timetk)
library(tidyquant)
library(tibbletime)

# Visualization
library(cowplot)
library(ggplot2)

# Preprocessing
library(recipes)

# Sampling / Accuracy
library(rsample)
library(yardstick) 

# Modeling
library(keras)
library(tfruns)


# Load data ---------------------------------------------------------------

# load stock data already downloaded
xjo <- read_csv("data/xjo.csv")

xjo



# Visualise the data ------------------------------------------------------

p1 <- xjo %>%
  filter(close != 0) %>%
  ggplot(aes(timestamp, close)) +
  geom_point(color = palette_light()[[1]], alpha = 0.5) +
  theme_tq() +
  labs(title = "2000 - Now",
       x = "",
       y = "Close")

p2 <- xjo %>%
  filter(close != 0,
         timestamp > as.Date("2019/01/01")) %>%
  ggplot(aes(timestamp, close)) +
  geom_line(color = palette_light()[[1]], alpha = 0.5) +
  geom_point(color = palette_light()[[1]]) +
  geom_smooth(method = "loess", span = 0.2, se = FALSE) +
  theme_tq() +
  labs(title = "2019",
       x = "",
       y = "Close")

p_title <- ggdraw() + 
  draw_label("XJO - ASX 200", size = 18, fontface = "bold", 
             colour = palette_light()[[1]])

plot_grid(p_title, p1, p2, ncol = 1, rel_heights = c(0.1, 1, 1))


# Data generator function -------------------------------------------------

generator <- function(data, lookback, delay, min_index, max_index,
                      shuffle = FALSE, batch_size = 128, step = 6) {
  if (is.null(max_index))
    max_index <- nrow(data) - delay - 1
  i <- min_index + lookback
  function() {
    if (shuffle) {
      rows <- sample(c((min_index+lookback):max_index), size = batch_size)
    } else {
      if (i + batch_size >= max_index)
        i <<- min_index + lookback
      rows <- c(i:min(i+batch_size-1, max_index))
      i <<- i + length(rows)
    }
    
    samples <- array(0, dim = c(length(rows),
                                lookback / step,
                                dim(data)[[-1]]))
    targets <- array(0, dim = c(length(rows)))
    
    for (j in 1:length(rows)) {
      indices <- seq(rows[[j]] - lookback, rows[[j]]-1,
                     length.out = dim(samples)[[2]])
      samples[j,,] <- data[indices,]
      targets[[j]] <- data[rows[[j]] + delay,2]
    }           
    list(samples, targets)
  }
}


# Prepare data ------------------------------------------------------------

data <- data.matrix(xjo[, -1]) # remove timestamp

# scale each variable using train data (as you wouldn't have future data)
train_data <- data[1:4000, ]
mean <- apply(train_data, 2, mean)
sd <- apply(train_data, 2, sd)
data <- scale(data, center = mean, scale = sd)

lookback   <- 60 # days
steps      <- 6
delay      <- 20  # predict 20 business days in the future
batch_size <- 32

train_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 1,
  max_index = 4000,
  shuffle = TRUE,
  step = step, 
  batch_size = batch_size
)

val_gen = generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 4001,
  max_index = 4500,
  step = step,
  batch_size = batch_size
)

test_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 4500,
  max_index = NULL,
  step = step,
  batch_size = batch_size
)

# How many steps to draw from val_gen in order to see the entire validation set
val_steps <- (4500 - 4001 - lookback) / batch_size

# How many steps to draw from test_gen in order to see the entire test set
test_steps <- (nrow(data) - 4500 - lookback) / batch_size


# Basic approach ----------------------------------------------------------

library(keras)
evaluate_naive_method <- function() {
  batch_maes <- c()
  for (step in 1:val_steps) {
    c(samples, targets) %<-% val_gen()
    preds <- samples[,dim(samples)[[2]],2]
    mae <- mean(abs(preds - targets))
    batch_maes <- c(batch_maes, mae)
  }
  print(mean(batch_maes))
}

evaluate_naive_method()
