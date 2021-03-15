# load libraries
library(tidyverse)
library(tidytext)

# load data
covid_tweets <- readRDS("raw-data/covid-tweets.rds")
flu_tweets <- readRDS("raw-data/flu-tweets.rds")

# combine data
covid_tweets_selected <- covid_tweets %>%
  select(user_id, status_id, created_at, screen_name, 
         text, source, display_text_width) %>%
  mutate(search_string = "covid")

flu_tweets_selected <- flu_tweets %>%
  select(user_id, status_id, created_at, screen_name, 
         text, source, display_text_width) %>%
  mutate(search_string = "flu")

all_tweets <- bind_rows(covid_tweets_selected,
                        flu_tweets_selected)

all_tweets %>%
  count(search_string)

# remove urls and mentions from text
all_tweets_clean <- all_tweets %>%
  mutate(clean_text = gsub("https://t.co/[A-Za-z0-9\\/\\.]+\\s?|@[A-Za-z0-9_]+\\s", "", text))

write_tsv(all_tweets_clean, "processed-data/all_tweets_clean.tsv")

# keep only text, to remove repeated tweets
all_tweet_text <- all_tweets_clean %>%
  select(status_id, clean_text, search_string) %>%
  filter(grepl("(flu|covid)", clean_text)) %>%
  unique()

all_tweet_text %>%
  count(search_string)

# tokenize data
tokenized_tweets <- all_tweet_text %>%
  unnest_tokens(word, clean_text)

token_count <- tokenized_tweets %>%
  count(search_string, word) 

token_count <- token_count %>%
  bind_tf_idf(word, search_string, n)

# calculate range
token_range <- tokenized_tweets %>%
  distinct(status_id, search_string, word) %>%
  count(word) %>%
  rename(range = n)

# add range to token count
token_count <- token_count %>%
  left_join(token_range)
