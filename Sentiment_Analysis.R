install.packages("rtweet")

library (rtweet)
library(syuzhet)
library(ggplot2)
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
#library(CASdatasets)

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

DublinBikes <- search_tweets("Dublin_Bikes", n=10, include_rts=FALSE, lang="en")
#Cleaning Dataset
DublinBikes$text <-  gsub("https\\S*", "", DublinBikes$text)
DublinBikes$text <-  gsub("@\\S*", "", DublinBikes$text) 
DublinBikes$text  <-  gsub("amp", "", DublinBikes$text) 
DublinBikes$text  <-  gsub("[\r\n]", "", DublinBikes$text)
DublinBikes$text  <-  gsub("[[:punct:]]", "", DublinBikes$text)



# Converting tweets to ASCII to trackle strange characters
tweets <- iconv(DublinBikes$text, from="UTF-8", to="ASCII", sub="")


# Gathering the Newspaper Data

content <- fromJSON("http://newsapi.org/v2/everything?q=Dublin%20AND%20Bikes&from=2020-07-30&sortBy=publishedAt&apiKey=c9040948cf114c4cbd5a1c5d6727f23c",flatten = TRUE)
content <- as.data.frame(content)
#View(content)

NewsResponse <- content
#View(NewsResponse)

NewsResponse$articles.publishedAt <- as.Date(NewsResponse$articles.publishedAt)
Newsyear <- month(NewsResponse$articles.publishedAt)
#str(NewsResponse)



NewsResponse$articles.description <- trimws((gsub("<.*?>","",NewsResponse$articles.description)))
mysentiment_Classification <- get_nrc_sentiment(NewsResponse$articles.description)
head(mysentiment_Classification)
#
#
#Combining the both Data and applying the NRC Model

ew_sentiment<-get_nrc_sentiment((DublinBikes$text))
head(ew_sentiment)

BothSentiments <- rbind(mysentiment_Classification,ew_sentiment)
head(BothSentiments)


sentimentscores<-data.frame(colSums(BothSentiments[,]))
names(sentimentscores) <- "Score"
sentimentscores <- cbind("sentiment"=rownames(sentimentscores),sentimentscores)

rownames(sentimentscores) <- NULL
ggplot(data=sentimentscores,aes(x=sentiment,y=Score))+
  geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("Scores")+
  ggtitle("Total sentiment based on scores")+
  theme_minimal()


#
#
#Both sentiment(tweets+Newspaper) output assignment to a varaible

mysentiment_Classification_Radar <- data.frame(Newsyear,mysentiment_Classification)
View(mysentiment_Classification_Radar)


#Sentiment_ID <- seq(1:nrow(mysentiment_Classification))
#View(mysentiment_Classification)
#mysentiment_Classification <- cbind(Sentiment_ID, mysentiment_Classification)
#head(mysentiment_Classification)

# Applying the Molten model

MoltenSentiments <- melt(mysentiment_Classification_Radar, id=c("Newsyear"))
head(MoltenSentiments,id=3)

abc <- aggregate(value ~ variable+Newsyear, MoltenSentiments, sum)
View(abc)


RR <- reshape(data=abc,idvar="variable",
              v.names = "value",
              timevar = "Newsyear",
              direction="wide")
head(RR)

colnames(RR) <- c("Sentiments","July")
RR %>%
  chartJSRadar(showToolTipLabel = TRUE,
               main = "NRC Years Radar")





