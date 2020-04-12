# Update csv files with new stock data

source("src/functions.R")

# csv files already downloaded
files <- list.files("data/daily")

# TODO wrap this into a loop for all files
data <- readr::read_csv(paste0("data/daily/", files[1]))

ticker <- strsplit(files[1], split = ".csv")[[1]]

last_timestamp <- data$timestamp[1]

today <- Sys.Date()

requires_update <- last_timestamp < today

if (requires_update == TRUE) {
  tryCatch({
    new_data <- get_alphavantage(stock = tickers[i], outputsize = "full")
    new_data$timestamp <- as.Date(new_data$timestamp)
    
    new_data <- rbind(new_data, data)
    
    new_data <- unique(new_data)
    
    filepath <- paste0("data/daily/", ticker, ".csv")
    
    readr:write_csv(new_data, filepath)
  }, 
  
  error = function(e) {cat("ERROR :", conditionMessage(e), "\n")}
  )
}