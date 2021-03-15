# quick visualization
# term frequency
token_count %>%
  anti_join(stop_words) %>%
  group_by(search_string) %>%
  top_n(10, wt = tf) %>%
  ggplot(aes(y = reorder_within(word, tf, search_string),
             x = tf,
             fill = search_string)) +
  geom_col() +
  facet_wrap(~search_string, scales = "free_y") +
  scale_y_reordered() 


# range
token_count %>%
  anti_join(stop_words) %>%
  group_by(search_string) %>%
  top_n(10, wt = range) %>%
  ggplot(aes(y = reorder_within(word, range, search_string),
             x = range,
             fill = search_string,
             label = range)) +
  geom_col() +
  geom_label() +
  facet_wrap(~search_string, scales = "free") +
  scale_y_reordered() +
  scale_x_continuous(expand = expansion(mult = c(.1, .1)))

# tf-idf (this doesn't work because corpora are too similar)
token_count %>%
  anti_join(stop_words) %>%
  filter(range > 10) %>%
  group_by(search_string) %>%
  top_n(10, wt = tf_idf) %>%
  ggplot(aes(y = reorder_within(word, tf_idf, search_string),
             x = tf_idf,
             fill = search_string)) +
  geom_col() +
  facet_wrap(~search_string, scales = "free_y") +
  scale_y_reordered() 
