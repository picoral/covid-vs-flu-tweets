# load libraries
library(tidyverse)

# load data
covid_tweets <- readRDS("raw-data/covid-tweets.rds")
flu_tweets <- readRDS("raw-data/flu-tweets.rds")

# remove urls and mentions from text
