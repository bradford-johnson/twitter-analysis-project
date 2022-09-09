# install.packages("rtweet")

library(rtweet)

auth_setup_default()

auth_has_default()

rt <- search_tweets("rocket league", n = 100, include_rts = FALSE, lang = "en")