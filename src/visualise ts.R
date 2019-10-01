library(quantmod)
library(dplyr)
library(ggplot2)
library(plotly)

source("src/functions.R")

apt <- get_stock_hist("ASX:APT") %>% as_tibble()
stx <- get_stock_hist("ASX:STX") %>% as_tibble()

# Note the latest value is in the first row
head(apt)


# simple line chart for closing price
line_plot <- ggplot(data = apt[1:280, ],
       aes(x = timestamp, y = close)) +
  geom_line(colour = "blue") +
  theme_minimal() +
  scale_y_continuous(breaks = seq(0, 40, by = 5)) +
  theme(panel.grid = element_blank()) +
  labs(x = "", y = "$")

# line_plot

ggplotly(line_plot)

plot_ly(data = apt[1:280, ],
        x = ~timestamp, y = ~close, 
        mode = "lines")

# simple bar chart for volume
bar_plot <- ggplot(data = apt[1:280, ],
       aes(x = timestamp, y = volume)) +
  geom_col() +
  theme_minimal() +
  scale_y_continuous() +
  theme(panel.grid = element_blank()) +
  labs(x = "", y = "Volume")

# bar_plot

ggplotly(bar_plot)

plot_ly(data = apt[1:280, ], 
        x = ~timestamp, y = ~volume,
        type = "bar")


# OHLC chart

plot_ly(data = apt[1:280, ],
        x = ~timestamp, type = "ohlc",
        open = ~open, close = ~close,
        high = ~high, low = ~low)

# Combined charts
p <- plot_ly(data = apt,
        x = ~timestamp, y = ~close, 
        mode = "lines", name = "Price") %>%
  layout(yaxis = list(title = "Price"))
pp <- plot_ly(data = apt, 
              x = ~timestamp, y = ~volume,
              type = "bar", name = "Volume") %>%
  layout(yaxis = list(title = "Volume"))
# Create range selector buttons
rs <- list(visible = TRUE, x = 0.5, y = -0.055,
           xanchor = 'center', yref = 'paper',
           font = list(size = 9),
           buttons = list(
             list(count=1,
                  label='RESET',
                  step='all'),
             list(count=1,
                  label='1 YR',
                  step='year',
                  stepmode='backward'),
             list(count=3,
                  label='3 MO',
                  step='month',
                  stepmode='backward'),
             list(count=1,
                  label='1 MO',
                  step='month',
                  stepmode='backward')
           ))

# Subplot with shared axis
p <- subplot(p, pp, heights = c(0.7, 0.2), nrows = 2,
             shareX = TRUE, titleY = TRUE) %>%
  layout(title = "APT",
         xaxis = list(rangeslider = rs),
         legend = list(orientation = "h", x = 0.5, y = 1,
                       xanchor = "center", yref = "paper",
                       bgcolor = "transparent"))
p
