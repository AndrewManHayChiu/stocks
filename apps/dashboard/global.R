## global.R ##

library(readr)
library(dplyr)
library(stringr)

source("functions.R")

rdf <- get_intraday("RDF", outputsize = "full") %>% as_tibble()
rdf_sma <- get_sma("RDF") %>% as_tibble()
rdf <- rdf %>% left_join(rdf_sma, by = c("timestamp" = "time")) %>% as.data.frame()