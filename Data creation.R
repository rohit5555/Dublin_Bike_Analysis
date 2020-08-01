setwd("~/Desktop/R Code dataset")

library(lubridate)
library (plyr)
library(dplyr)

DB1 <- read.csv(file = 'dublinbikes_20190101_20190401.csv', stringsAsFactors = FALSE, header = TRUE)
head(DB1)
DB1$TIME <-  as_datetime(DB1$TIME)

aa1 <- minute(DB1$TIME)
DB1 <- subset(DB1, minute(DB1$TIME)==0)
View(DB1)
DB1$TIME <- format(as.POSIXct(DB1$TIME, "%Y-%m-%d %H:%M:%S", tz = ""), format = "%Y-%m-%d %H:%M")


###############

DB2 <- read.csv(file = 'dublinbikes_20190401_20190701.csv',stringsAsFactors = FALSE, header = TRUE)
View(DB2)
str(DB2)
DB2$TIME <- dmy_hm(DB2$TIME,tz="")

DB2$TIME <-  as_datetime(DB2$TIME)

aa2 <- minute(DB2$TIME)
DB2 <- subset(DB2, minute(DB2$TIME)==0)
View(DB2)
DB2$TIME <- format(as.POSIXct(DB2$TIME, "%Y-%m-%d %H:%M:%S", tz = ""), format = "%Y-%m-%d %H:%M")


head(DB2)
head(DB1)
str(DB1)
str(DB2)

DB <-  rbind(DB1,DB2)
View(DB)
head(DB)

#############

weather <- read.csv(file = 'Dublin Weather Hourly Data.csv', stringsAsFactors = FALSE, header = TRUE)
head(weather)
str(weather)

weather$date <- format(as.POSIXct(weather$date, "%d-%m-%Y %H:%M", tz = ""), format = "%Y-%m-%d %H:%M")
head(weather)
#######################################################################################
names(weather)[names(weather) == 'date'] <- 'TIME'

identical(DB,weather)


dplr <- left_join(DB, weather, by=c("TIME"))

View(dplr)


dropList <- c("ind","ind.1","ind.2","wetb","dewpt","msl","ind.3","ind.4","wddir","w")
dplr <- dplr[, !colnames(dplr) %in% dropList]

head(dplr)

write.csv(dplr,"dplr.csv", row.names = FALSE)

