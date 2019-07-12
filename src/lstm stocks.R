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


library(tibble)
library(dplyr)
library(readr)
library(tidyquant)
library(ggplot2)
library(cowplot)


# Load data ---------------------------------------------------------------

# load stock data already downloaded
xjo <- read_csv("data/xjo.csv")

xjo

emr <- read_csv("data/emr.csv")


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

# A function that you call repeatedly to obtain a sequence of values from.
# Generator functions maintain an internal state, so they typically
# call yet another function which returns the generator function.

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

# Convert data frame into a matrix of floating point values
# data <- data.matrix(xjo[, -1]) # remove timestamp
data <- data.matrix(emr[4300:nrow(emr), -1]) # remove timestamp

dim(data)

head(data)

# scale each variable using training data (as you wouldn't have future data)
# train_data <- data[1:4000, ] # for xjo
train_data <- data[1:500, ] # for emr
mean <- apply(train_data, 2, mean)
sd <- apply(train_data, 2, sd)
data <- scale(data, center = mean, scale = sd)

head(data)

# Data for generator 
lookback   <- 60  # days to observe
step       <- 5   # obserbvations sampled at one data point per 5 days
delay      <- 20  # predict 20 business days in the future (approximately 1 month)
batch_size <- 32

train_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  min_index = 1,
  # max_index = 4000, # xjo
  max_index = 500, # emr
  shuffle = TRUE,
  step = step, 
  batch_size = batch_size
)

val_gen = generator(
  data,
  lookback = lookback,
  delay = delay,
  # min_index = 4001, # xjo
  # max_index = 4500, # xjo
  min_index = 501, # emr
  max_index = 600, # emr
  step = step,
  batch_size = batch_size
)

test_gen <- generator(
  data,
  lookback = lookback,
  delay = delay,
  # min_index = 4500, # xjo
  min_index = 601, # emr
  max_index = NULL,
  step = step,
  batch_size = batch_size
)

# How many steps to draw from val_gen in order to see the entire validation set
# val_steps <- (4500 - 4001 - lookback) / batch_size # xjo
val_steps <- (600 - 501 - lookback) / batch_size

# How many steps to draw from test_gen in order to see the entire test set
# test_steps <- (nrow(data) - 4500 - lookback) / batch_size # xjo
test_steps <- (nrow(data) - 600 - lookback) / batch_size


# Basic approach ----------------------------------------------------------

library(keras)

# We need a baseline.
# Time-series data is continuous, so assume tomorrow's price is the same as today.
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

# The Mean Absolute Error is 35%, or 308.25 points, quite high
evaluate_naive_method() * sd[[2]]


# A basic machine learning approach ---------------------------------------

# Try a small densely connected network before computationally expensive RNNs.
# Improvements can be compared against this approach.
model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(lookback / step, dim(data)[-1])) %>% 
  layer_dense(units = 32, activation = "relu") %>% 
  layer_dense(units = 1)

model %>% 
  compile(
    optimizer = optimizer_rmsprop(),
    loss = "mae"
    )

history <- model %>% 
  fit_generator(
    train_gen,
    steps_per_epoch = 500,
    epochs = 20,
    validation_data = val_gen,
    validation_steps = val_steps
    )

# Much of the validation loss is lower than the MAE of .35.
# This shows that this approach is already better than the baseline.
# This becomes the new baseline.
plot(history)


# A first recurrent baseline ----------------------------------------------

# The basic machine learning approach simply flattened the data,
# removing the notion of time from the input data.

model <- keras_model_sequential() %>%
  layer_gru(units = 32, input_shape = list(NULL, dim(data)[[-1]])) %>%
  layer_dense(units = 1) 

model %>%
  compile(
    optimizer = optimizer_rmsprop(),
    loss = "mae"
  )

history <- model %>%
  fit_generator(
    train_gen,
    steps_per_epoch = 500,
    epochs = 20,
    validation_data = val_gen,
    validation_steps = val_steps
  )

# The starting MAE of .2257 (199 points) was better than the initial .35 (308 points)
# However, it started to significantly overfit
plot(history)


# Use recurrent dropout to fight overfitting ------------------------------

model <- keras_model_sequential() %>% 
  layer_gru(units = 32, 
            # dropout = 0.1,
            recurrent_dropout = 0.4,
            input_shape = list(NULL, dim(data)[[-1]])) %>% 
  layer_dense(units = 1)

model %>% compile(
  optimizer = optimizer_rmsprop(),
  loss = "mae"
)

history <- model %>% fit_generator(
  train_gen,
  steps_per_epoch = 500,
  epochs = 20,
  validation_data = val_gen,
  validation_steps = val_steps
)

plot(history)

# Stacking recurrent layers -----------------------------------------------


model <- keras_model_sequential() %>% 
  layer_gru(units = 32, 
            # dropout = 0.1, 
            recurrent_dropout = 0.35,
            return_sequences = TRUE,
            input_shape = list(NULL, dim(data)[[-1]])) %>% 
  layer_gru(units = 64, activation = "relu",
            # dropout = 0.1,
            recurrent_dropout = 0.35) %>% 
  layer_dense(units = 1)

model %>% compile(
  optimizer = optimizer_rmsprop(),
  loss = "mae"
)

history <- model %>% fit_generator(
  train_gen,
  steps_per_epoch = 500,
  epochs = 20,
  validation_data = val_gen,
  validation_steps = val_steps
)

plot(history)
