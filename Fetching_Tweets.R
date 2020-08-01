install.packages("rtweet")
library (rtweet)
library(syuzhet)

library(xlsx)
library (jsonlite)
library(dplyr)
library(syuzhet)
library(tidyr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(reshape2)
library(reshape)
library(radarchart)
library(data.table)

library(readr)


api_key <- "2rxDrVunPNAcDia4xBQrLjEVy"
api_secret_key <- "4N2mIFJm2yUP271LunvYSYsXkDLm5y9V1MMTvyrH0m7Pyc8M8C"
access_token <- "1478793870-6VOfCpmjUYFLgLkqLOoKhKLYQTZWdPggzh8xEPj"
access_token_secret <- "mjvomHex3BMo49WySOb9HLomU3nT4LzsLYAf6JWtGnJYb"




## authenticate via web browser
token <- create_token(
  app = "Dublin City Bike",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)

DuBikes <- search_tweets("dublinbikes", n=1000, include_rts=FALSE, lang="en")
View(DublinBikes)

DuBikes <- data.frame(user_id= DuBikes$user_id,
                          status_id= DuBikes$status_id,
                          created_at= DuBikes$created_at,
                          screen_name= DuBikes$screen_name, 
                          text= DuBikes$text,
                          source= DuBikes$source,
                          display_text_width=DuBikes$display_text_width)

#Export file 
write_csv(DuBikes, path = "DublinBikes12.csv", append=FALSE)











