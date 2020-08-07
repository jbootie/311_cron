
##load in libraries and set the directory you want to work in

library(data.table)
library(stringr)
library(tidyverse)
library(emayili)

setwd("/your/working/directory/")


##make the queries to open data portal

d1 <- Sys.Date()-1

d2 <- Sys.Date()-365


yesterday <-fread(paste0("https://data.cityofnewyork.us/api/id/erm2-nwe9.csv?$query=select%20*,%20complaint_type%20||%27:%27||%20descriptor%20where%20(created_date%20%3E%3D%20'",
d1,"T00%3A00%3A00'","%20and%20created_date%20%3C%3D%20'",d1,"T23%3A59%3A59'",")","%20limit%209999999999"))

lastyear <-fread(paste0("https://data.cityofnewyork.us/api/id/erm2-nwe9.csv?$query=select%20*,%20complaint_type%20||%27:%27||%20descriptor%20where%20(created_date%20%3E%3D%20'",
d2,"T00%3A00%3A00'","%20and%20created_date%20%3C%3D%20'",d2,"T23%3A59%3A59'",")","%20limit%209999999999"))

##makes some new columns and format the data

created_date_new <- substring(yesterday$created_date,1,10)
created_date_new <- as.Date(created_date_new)
yesterday$created_date_new <- created_date_new
week <- strftime(yesterday$created_date_new, format = "%V")
yesterday$week <-week

created_date_new <- substring(lastyear$created_date,1,10)

created_date_new <- as.Date(created_date_new)

lastyear$created_date_new <- created_date_new

week <- strftime(lastyear$created_date_new, format = "%V")

lastyear$week <-week


#create names and numbers for the days of the week

yesterday$ndat <- as.character(yesterday$created_date_new)
yesterday$nwk <- weekdays(yesterday$created_date_new)

#make a column with week num day name

week_dayname <- paste0(yesterday$week,"-",yesterday$nwk)
yesterday$week_dayname <-week_dayname
yesterday$year <- substring(yesterday$created_date_new,1,4)


lastyear$ndat <- as.character(lastyear$created_date_new)
lastyear$nwk <- weekdays(lastyear$created_date_new)
week_dayname <- paste0(lastyear$week,"-",lastyear$nwk)
lastyear$week_dayname <-week_dayname
lastyear$year <- substring(lastyear$created_date_new,1,4)


##make tables of queried data, and data frame of the tabled data.

recent <- yesterday


old <- lastyear

recenttab <- table(recent$complaint_type_descriptor)


recenttab <- as.data.frame(recenttab) 

recenttab$Var <- as.character(recenttab$Var)



oldtab <- table(old$complaint_type_descriptor)


oldtab <- as.data.frame(oldtab)

oldtab$Var <- as.character(oldtab$Var)

recval <-c()
oldval <-c()
dif <-c()
match <-c()

for(i in 1:nrow(recenttab))
{
for(j in 1:nrow(oldtab))
{
if(length(which(recenttab$Var[i]==oldtab$Var[j]))>0)
{
match[i] <-recenttab$Var[i]
recval[i] <-recenttab$Freq[i]
oldval[i] <-oldtab$Freq[j]
dif[i]<-recenttab$Freq[i]-oldtab$Freq[j]
}else{
match[i] <-recenttab$Var[i]
recval[i] <-recenttab$Freq[i]
}
}
}

v <- cbind(match,recval,oldval,dif)

v <- as.data.frame(v)

v$dif <-as.numeric(as.character(v$dif))


v <- v[order(-v$dif),]


v$recval <- as.numeric(as.character(v$recval))

perdif <- v$dif/v$recval

v$perdif <-perdif

##rename the columns so they make sense to the user

colnames(v)[1] <-"complaint_type_descriptor"
colnames(v)[2] <-"complaints_yesterday"
colnames(v)[3] <-"complaints_same_day_last_year"
colnames(v)[4] <-"difference"
colnames(v)[5] <-"percent_difference"


##include a time stamp so you have an idea of when you wrote the file
v$time_stamp <- Sys.time()

##write the file

write.csv(v,"311_Analysis_YtoY.csv")


###############Yesterday compared to 2 Days Ago#####################################

d1 <- Sys.Date()-1

d2 <- Sys.Date()-2


yesterday <-fread(paste0("https://data.cityofnewyork.us/api/id/erm2-nwe9.csv?$query=select%20*,%20complaint_type%20||%27:%27||%20descriptor%20where%20(created_date%20%3E%3D%20'",
d1,"T00%3A00%3A00'","%20and%20created_date%20%3C%3D%20'",d1,"T23%3A59%3A59'",")","%20limit%209999999999"))

twodaysago <-fread(paste0("https://data.cityofnewyork.us/api/id/erm2-nwe9.csv?$query=select%20*,%20complaint_type%20||%27:%27||%20descriptor%20where%20(created_date%20%3E%3D%20'",
d2,"T00%3A00%3A00'","%20and%20created_date%20%3C%3D%20'",d2,"T23%3A59%3A59'",")","%20limit%209999999999"))


created_date_new <- substring(yesterday$created_date,1,10)
created_date_new <- as.Date(created_date_new)
yesterday$created_date_new <- created_date_new
week <- strftime(yesterday$created_date_new, format = "%V")
yesterday$week <-week

created_date_new <- substring(twodaysago$created_date,1,10)

created_date_new <- as.Date(created_date_new)

twodaysago$created_date_new <- created_date_new

week <- strftime(twodaysago$created_date_new, format = "%V")

twodaysago$week <-week


#create names and numbers for the days of the week

yesterday$ndat <- as.character(yesterday$created_date_new)
yesterday$nwk <- weekdays(yesterday$created_date_new)

#make a column with week num day name

week_dayname <- paste0(yesterday$week,"-",yesterday$nwk)
yesterday$week_dayname <-week_dayname
yesterday$year <- substring(yesterday$created_date_new,1,4)


twodaysago$ndat <- as.character(twodaysago$created_date_new)
twodaysago$nwk <- weekdays(twodaysago$created_date_new)
week_dayname <- paste0(twodaysago$week,"-",twodaysago$nwk)
twodaysago$week_dayname <-week_dayname
twodaysago$year <- substring(twodaysago$created_date_new,1,4)



###########################################################################


recent <- yesterday

old <- twodaysago

recenttab <- table(recent$complaint_type_descriptor)

recenttab <- as.data.frame(recenttab) 

recenttab$Var <- as.character(recenttab$Var)

oldtab <- table(old$complaint_type_descriptor)

oldtab <- as.data.frame(oldtab)

oldtab$Var <- as.character(oldtab$Var)

recval <-c()
oldval <-c()
dif <-c()
match <-c()


for(i in 1:nrow(recenttab))
{
for(j in 1:nrow(oldtab))
{
if(length(which(recenttab$Var[i]==oldtab$Var[j]))>0)
{
match[i] <-recenttab$Var[i]
recval[i] <-recenttab$Freq[i]
oldval[i] <-oldtab$Freq[j]
dif[i]<-recenttab$Freq[i]-oldtab$Freq[j]
}else{
match[i] <-recenttab$Var[i]
recval[i] <-recenttab$Freq[i]
}
}
}

v <- cbind(match,recval,oldval,dif)

v <- as.data.frame(v)

v$dif <-as.numeric(as.character(v$dif))


v <- v[order(-v$dif),]


v$recval <- as.numeric(as.character(v$recval))

perdif <- v$dif/v$recval

v$perdif <-perdif


colnames(v)[1] <-"complaint_type_descriptor"
colnames(v)[2] <-"complaints_yesterday"
colnames(v)[3] <-"complaints_two_days_ago"
colnames(v)[4] <-"difference"
colnames(v)[5] <-"percent_difference"

v$time_stamp <- Sys.time()

write.csv(v,"twodaycompare.csv")


########################Email Files to Yourself##################################

#email <- envelope() %>%
#  from("your email") %>%
#  to("your email") %>%
#  subject("some subject")%>%
#message("Test email body")%>%
#attachment(c("/yourpath/311_Analysis_YtoY.csv"))%>%
#attachment(c("/yourpath/twodaycompare.csv"))


#smtp <- server(host = "smtp.gmail.com",
#               port = a port number,
#               username = "your email address",
#               password = "your email password")

#smtp(email, verbose = TRUE)


