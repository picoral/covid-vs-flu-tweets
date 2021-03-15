# load libraries
library(tidyverse)
library(rtweet)

covid_tweets <- search_tweets("covid", n = 18000,
                              retryonratelimit = TRUE,
                              include_rts = FALSE,
                              lang = "en")

saveRDS(covid_tweets, file = "raw-data/covid-tweets.rds")

flu_tweets <- search_tweets("flu", n = 18000,
                            retryonratelimit = TRUE,
                            include_rts = FALSE,
                            lang = "en")

saveRDS(flu_tweets, file = "raw-data/flu-tweets.rds")
