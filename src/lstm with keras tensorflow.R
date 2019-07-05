library(keras)
library(BatchGetSymbols)
library(ggplot2)

tickers <- c("%5EIBEX")
first.date <- Sys.Date() - 360*2
last.date <- Sys.Date()

myts <- BatchGetSymbols(tickers = tickers,
                        first.date = first.date,
                        last.date = last.date,
                        cache.folder = file.path(tempdir(), "BGS_Cache"))

print(myts$df.control)

y = myts$df.tickers$price.close
myts <- data.frame(index = myts$df.tickers$ref.date,
                   price = y,
                   vol = myts$df.tickers$volume)
myts <- myts[complete.cases(myts), ]
# myts <- myts[-seq(nrow(myts))]

head(myts)

ggplot(myts, aes(x = index, y = price)) +
  geom_point(aes(colour = vol))

acf(myts$price, lag.max = 500)


# standardise data --------------------------------------------------------

msd.price <- c(mean(myts$price), sd(myts$price))
msd.vol <- c(mean(myts$vol), sd(myts$vol))
myts$price = (myts$price - msd.price[1]) / msd.price[2]
myts$vol = (myts$vol - msd.vol[1]) / msd.vol[2]

summary(myts)

# Use forst 400 days for training, and last 102 for test

datalags <- 10
train <- myts[seq(400 + datalags), ]
test  <- myts[400 + datalags + seq(10 + datalags), ]
batch.size = 50


# Data for LSTM -----------------------------------------------------------

x.train = array(data = lag(cbind(train$price, train$vol), datalags)[-(1:datalags), ], dim = c(nrow(train) - datalags, datalags, 2))
y.train = array(data = train$price[-(1:datalags)], dim = c(nrow(train)-datalags, 1))

x.test = array(data = lag(cbind(test$vol, test$price), datalags)[-(1:datalags), ], dim = c(nrow(test) - datalags, datalags, 2))
y.test = array(data = test$price[-(1:datalags)], dim = c(nrow(test) - datalags, 1))


# Keras -------------------------------------------------------------------

model <- keras_model_sequential()

model %>%
  layer_lstm(units = 100,
             input_shape = c(datalags, 2),
             batch_size = batch.size,
             return_sequences = TRUE,
             stateful = TRUE) %>%
  layer_dropout(rate = 0.5) %>%
  layer_lstm(units = 50,
             return_sequences = FALSE,
             stateful = TRUE) %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 1)

model %>%
  compile(loss = 'mae', optimizer = 'adam')

model

for(i in 1:100){
  model %>% fit(x = x.train,
                y = y.train,
                batch_size = batch.size,
                epochs = 1,
                verbose = 0,
                shuffle = FALSE)
  model %>% reset_states()
}

pred_out <- model %>% predict(x.test, batch_size = batch.size) %>% .[,1]


# plot --------------------------------------------------------------------


