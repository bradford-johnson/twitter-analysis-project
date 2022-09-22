# load packages
library(DBI) # to connect to database
library(RPostgres) # to connect to database
library(dplyr) # to wrangle data
library(tidytext) # wrangle text data
library(tidyverse) # meta tidyverse package
library(RColorBrewer) # for color brewing
library(widyr) # for pairwise correlation 
library(igraph) # for data visualization
library(ggraph) # for data visualization

# connect to database
con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres',
                 host = 'localhost',
                 port = 5432,
                 user = 'postgres',
                 password = 'vannah') 

# make and execute query
res <- dbSendQuery(con, "

SELECT DISTINCT(t.id_str), text, display_text_range, retweet_count, favorite_count
FROM rocketleague_text AS t
INNER JOIN rocketleague_data AS d
ON d.id_str = t.id_str

-- DISTINCT(t.id_str) eliminates duplicates 
                   
                   ")

query_df <- dbFetch(res)

# clear query and disconnect from database
dbClearResult(res)
dbDisconnect(con)

# clean data
db_new <- unnest_tokens(tbl = query_df, input = text, output = word)

stp_wrds <- get_stopwords(source = "smart")

db_new <- anti_join(db_new, stp_wrds, by = "word")

bing <- get_sentiments(lexicon = "bing")

db_bing <- inner_join(db_new, bing, by = "word")

db_bing <- count(db_bing, id_str, display_text_range, retweet_count, favorite_count, word, sentiment)

db_bing <- spread(key = sentiment, value = n, fill = 0, data = db_bing)


db_bing <- mutate(sentiment = positive - negative, .data = db_bing)

mean(db_bing$sentiment, na.rm = TRUE)




fun_color_range <- colorRampPalette(c("red", "green"))
my_colors2 <- fun_color_range(2)

db_sentiment <- db_bing %>% 
  mutate(value = case_when(sentiment > 0 ~ 'positive',
                           sentiment == 0 ~ 'neutral',
                           sentiment < 0 ~ 'negative')) %>%
  filter(value == 'positive' | value == 'negative')

rl_sentiment <- db_sentiment %>%
  group_by(id_str) %>%
  summarise( display_text_range = mean(display_text_range), Sentiment = sum(sentiment)) %>% 
  filter(display_text_range < 280) %>%
  ggplot(mapping = aes(x = display_text_range, y = Sentiment, color = Sentiment)) +
  geom_jitter(alpha = .7) + 
  scale_colour_gradientn(colors = my_colors2) +
  geom_hline(linetype = 1, yintercept = 0, size = .5) +
  geom_vline(linetype = 3, xintercept = 140, size = .5) +
  theme_classic() +
  theme(legend.position = "") + 
  labs(title = "Rocket League Tweets", x = "Number of Characters", y = "Sentiment")



# load packages
library(DBI) # to connect to database
library(RPostgres) # to connect to database
library(dplyr) # to wrangle data
library(tidytext) # wrangle text data
library(tidyverse) # meta tidyverse package
library(RColorBrewer) # for color brewing
library(widyr) # for pairwise correlation 
library(igraph) # for data visualization
library(ggraph) # for data visualization

# connect to database
con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres',
                 host = 'localhost',
                 port = 5432,
                 user = 'postgres',
                 password = 'vannah') 

# make and execute query
res <- dbSendQuery(con, "

SELECT DISTINCT(t.id_str), text, display_text_range, retweet_count, favorite_count
FROM pogo_text AS t
INNER JOIN pogo_data AS d
ON d.id_str = t.id_str

-- DISTINCT(t.id_str) eliminates duplicates 
                   
                   ")

query_df <- dbFetch(res)

# clear query and disconnect from database
dbClearResult(res)
dbDisconnect(con)

# clean data
db_new <- unnest_tokens(tbl = query_df, input = text, output = word)

stp_wrds <- get_stopwords(source = "smart")

db_new <- anti_join(db_new, stp_wrds, by = "word")

bing <- get_sentiments(lexicon = "bing")

db_bing <- inner_join(db_new, bing, by = "word")

db_bing <- count(db_bing, id_str, display_text_range, retweet_count, favorite_count, word, sentiment)

db_bing <- spread(key = sentiment, value = n, fill = 0, data = db_bing)


db_bing <- mutate(sentiment = positive - negative, .data = db_bing)

mean(db_bing$sentiment, na.rm = TRUE)




fun_color_range <- colorRampPalette(c("red", "green"))
my_colors2 <- fun_color_range(2)

db_sentiment <- db_bing %>% 
  mutate(value = case_when(sentiment > 0 ~ 'positive',
                           sentiment == 0 ~ 'neutral',
                           sentiment < 0 ~ 'negative')) %>%
  filter(value == 'positive' | value == 'negative')

pg_sentiment <- db_sentiment %>%
  group_by(id_str) %>%
  summarise( display_text_range = mean(display_text_range), Sentiment = sum(sentiment)) %>% 
  filter(display_text_range < 280) %>%
  ggplot(mapping = aes(x = display_text_range, y = Sentiment, color = Sentiment)) +
  geom_jitter(alpha = .7) + 
  scale_colour_gradientn(colors = my_colors2) +
  geom_hline(linetype = 1, yintercept = 0, size = .5) +
  geom_vline(linetype = 3, xintercept = 140, size = .5) +
  theme_classic() +
  theme(legend.position = "") + 
  labs(title = "Pokémon Go Tweets", x = "Number of Characters", y = "Sentiment")



# load packages
library(DBI) # to connect to database
library(RPostgres) # to connect to database
library(dplyr) # to wrangle data
library(tidytext) # wrangle text data
library(tidyverse) # meta tidyverse package
library(RColorBrewer) # for color brewing
library(widyr) # for pairwise correlation 
library(igraph) # for data visualization
library(ggraph) # for data visualization

# connect to database
con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres',
                 host = 'localhost',
                 port = 5432,
                 user = 'postgres',
                 password = 'vannah') 

# make and execute query
res <- dbSendQuery(con, "

SELECT DISTINCT(t.id_str), text, display_text_range, retweet_count, favorite_count
FROM tg_text AS t
INNER JOIN tg_data AS d
ON d.id_str = t.id_str

-- DISTINCT(t.id_str) eliminates duplicates 
                   
                   ")

query_df <- dbFetch(res)

# clear query and disconnect from database
dbClearResult(res)
dbDisconnect(con)

# clean data
db_new <- unnest_tokens(tbl = query_df, input = text, output = word)

stp_wrds <- get_stopwords(source = "smart")

db_new <- anti_join(db_new, stp_wrds, by = "word")

bing <- get_sentiments(lexicon = "bing")

db_bing <- inner_join(db_new, bing, by = "word")

db_bing <- count(db_bing, id_str, display_text_range, retweet_count, favorite_count, word, sentiment)

db_bing <- spread(key = sentiment, value = n, fill = 0, data = db_bing)


db_bing <- mutate(sentiment = positive - negative, .data = db_bing)

mean(db_bing$sentiment, na.rm = TRUE)




fun_color_range <- colorRampPalette(c("red", "green"))
my_colors2 <- fun_color_range(2)

db_sentiment <- db_bing %>% 
  mutate(value = case_when(sentiment > 0 ~ 'positive',
                           sentiment == 0 ~ 'neutral',
                           sentiment < 0 ~ 'negative')) %>%
  filter(value == 'positive' | value == 'negative')

tg_sentiment <- db_sentiment %>%
  group_by(id_str) %>%
  summarise( display_text_range = mean(display_text_range), Sentiment = sum(sentiment)) %>% 
  filter(display_text_range < 280) %>%
  ggplot(mapping = aes(x = display_text_range, y = Sentiment, color = Sentiment)) +
  geom_jitter(alpha = .7) + 
  scale_colour_gradientn(colors = my_colors2) +
  geom_hline(linetype = 1, yintercept = 0, size = .5) +
  geom_vline(linetype = 3, xintercept = 140, size = .5) +
  theme_classic() +
  theme(legend.position = "") + 
  labs(title = "TopGolf Tweets", x = "Number of Characters", y = "Sentiment")



# load packages
library(DBI) # to connect to database
library(RPostgres) # to connect to database
library(dplyr) # to wrangle data
library(tidytext) # wrangle text data
library(tidyverse) # meta tidyverse package
library(RColorBrewer) # for color brewing
library(widyr) # for pairwise correlation 
library(igraph) # for data visualization
library(ggraph) # for data visualization

# connect to database
con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres',
                 host = 'localhost',
                 port = 5432,
                 user = 'postgres',
                 password = 'vannah') 

# make and execute query
res <- dbSendQuery(con, "

SELECT DISTINCT(t.id_str), text, display_text_range, retweet_count, favorite_count
FROM rstats_text AS t
INNER JOIN rstats_data AS d
ON d.id_str = t.id_str

-- DISTINCT(t.id_str) eliminates duplicates 
                   
                   ")

query_df <- dbFetch(res)

# clear query and disconnect from database
dbClearResult(res)
dbDisconnect(con)

# clean data
db_new <- unnest_tokens(tbl = query_df, input = text, output = word)

stp_wrds <- get_stopwords(source = "smart")

db_new <- anti_join(db_new, stp_wrds, by = "word")

bing <- get_sentiments(lexicon = "bing")

db_bing <- inner_join(db_new, bing, by = "word")

db_bing <- count(db_bing, id_str, display_text_range, retweet_count, favorite_count, word, sentiment)

db_bing <- spread(key = sentiment, value = n, fill = 0, data = db_bing)


db_bing <- mutate(sentiment = positive - negative, .data = db_bing)

mean(db_bing$sentiment, na.rm = TRUE)




fun_color_range <- colorRampPalette(c("red", "green"))
my_colors2 <- fun_color_range(2)

db_sentiment <- db_bing %>% 
  mutate(value = case_when(sentiment > 0 ~ 'positive',
                           sentiment == 0 ~ 'neutral',
                           sentiment < 0 ~ 'negative')) %>%
  filter(value == 'positive' | value == 'negative')

r_sentiment <- db_sentiment %>%
  group_by(id_str) %>%
  summarise( display_text_range = mean(display_text_range), Sentiment = sum(sentiment)) %>% 
  filter(display_text_range < 280) %>%
  ggplot(mapping = aes(x = display_text_range, y = Sentiment, color = Sentiment)) +
  geom_jitter(alpha = .7) + 
  scale_colour_gradientn(colors = my_colors2) +
  geom_hline(linetype = 1, yintercept = 0, size = .5) +
  geom_vline(linetype = 3, xintercept = 140, size = .5) +
  theme_classic() +
  theme(legend.position = "") + 
  labs(title = "#rstats Tweets", x = "Number of Characters", y = "Sentiment")
r_sentiment


library(patchwork)
rl_sentiment + pg_sentiment + tg_sentiment + r_sentiment
