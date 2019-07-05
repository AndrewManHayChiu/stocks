library(httr)
library(ggplot2)


# announcements -----------------------------------------------------------

announcements <- data.frame(stock = c("tgo", "twd", "emr", "pyc", "s2r", "ara", 
                                      "ovt", "cyp", "dme", "dcn", "rmy", "emn", 
                                      "as1", "avg"),
                            date = c("29/3/2019", "18/4/2019", "19/12/2018",
                                     "30/11/2018", "9/5/2019", "19/12/2018",
                                     "27/11/2018", "25/9/2018", "17/12/2018",
                                     "6/11/2018", "28/11/2018", "3/10/2018",
                                     "20/9/2018", "25/9/2018")) %>%
  mutate(date = lubridate::dmy(date))


# functions ---------------------------------------------------------------

get_stock_hist <- function(stock, outputsize = "full") {
  
  base <- "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=ASX:"
  
  call <- paste0(base, 
                 stock, 
                 "&outputsize=", outputsize,
                 "&datatype=", "csv",
                 "&apikey=", "THQF7WMIM25XDVCP")
  
  df <- read.csv(call)
  
  df$timestamp <- lubridate::ymd(df$timestamp)
  
  return(df)
}

plot_stock <- function(data.frame, ticker) {
  data.frame %>%
    filter(timestamp > today() - 365) %>%
    ggplot(aes(x = timestamp, y = close)) +
    geom_line(colour = "grey30", size = 1) +
    # geom_col(aes(x = timestamp, y = volume)) +
    # scale_y_continuous(sec.axis = sec_axis(~ / 100, name = "Volume")) +
    scale_x_date(limits = c())+
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")], 
               colour = "red") +
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")] - 7, 
               colour = "grey45") +
    geom_vline(xintercept = announcements[announcements$stock == ticker, c("date")] + 60, 
               colour = "blue") +
    theme_minimal() +
    theme(panel.grid = element_blank()) +
    labs(title = toupper(ticker),
         x = "",
         y = "Close")
}

get_and_plot <- function(stock, outputsize = "full") {
  df <- get_stock_hist(stock)
  plot_stock(df, stock)
}


# -------------------------------------------------------------------------

get_and_plot("xao")

# Download data -----------------------------------------------------------

tgo <- get_stock_hist("tgo")
twd <- get_stock_hist("twd")
emr <- get_stock_hist("emr")
pyc <- get_stock_hist("pyc")
s2r <- get_stock_hist("s2r")
ara <- get_stock_hist("ara")
ovt <- get_stock_hist("ovt")
cyp <- get_stock_hist("cyp")
dme <- get_stock_hist("dme")
dcn <- get_stock_hist("dcn")
rmy <- get_stock_hist("rmy")
as1 <- get_stock_hist("as1")
avg <- get_stock_hist("avg")
emn <- get_stock_hist("emn")
xao <- get_stock_hist("xjo")


# Metrics -----------------------------------------------------------------


# save data ---------------------------------------------------------------

# tgo <- write_csv(tgo, "C:/Users/09492659/Documents/stock/tgo.csv")
# twd <- write_csv(twd, "C:/Users/09492659/Documents/stock/twd.csv")
# emr <- write_csv(emr, "C:/Users/09492659/Documents/stock/emr.csv")
# pyc <- write_csv(pyc, "C:/Users/09492659/Documents/stock/pyc.csv")
# s2r <- write_csv(s2r, "C:/Users/09492659/Documents/stock/s2r.csv")
# ara <- write_csv(ara, "C:/Users/09492659/Documents/stock/ara.csv")
# ovt <- write_csv(ovt, "C:/Users/09492659/Documents/stock/ovt.csv")
# cyp <- write_csv(cyp, "C:/Users/09492659/Documents/stock/cyp.csv")
# dme <- write_csv(dme, "C:/Users/09492659/Documents/stock/dme.csv")
# dcn <- write_csv(dcn, "C:/Users/09492659/Documents/stock/dcn.csv")
# rmy <- write_csv(rmy, "C:/Users/09492659/Documents/stock/rmy.csv")
# as1 <- write_csv(as1, "C:/Users/09492659/Documents/stock/as1.csv")
# avg <- write_csv(avg, "C:/Users/09492659/Documents/stock/avg.csv")
# emn <- write_csv(emn, "C:/Users/09492659/Documents/stock/avg.csv")
xao <- write_csv(xao, "C:/Users/09492659/Documents/stock/xao.csv")

# plot --------------------------------------------------------------------

plot_stock(tgo, "tgo")
plot_stock(twd, "twd")
plot_stock(emr, "emr")
plot_stock(pyc, "pyc")
plot_stock(s2r, "s2r")
plot_stock(ara, "ara")
plot_stock(ovt, "ovt")
plot_stock(cyp, "cyp")
plot_stock(dme, "dme")
plot_stock(dcn, "dcn")
plot_stock(rmy, "rmy")
plot_stock(as1, "as1")
plot_stock(avg, "avg")
