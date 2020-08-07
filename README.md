This is code for running a cron job in R using the cronR package on a linux machine that downloads and emails you data from the 311 data set on the open data portal. 

There are 2 R scripts.

The first script called 311_code_for_github.R is the code that downloads the data and emails it to you.

The second script called 311_cron_for_github is for the cron job itself.
This script is for on linux. The set up is likely different for other operating systems.
For details see: https://www.r-bloggers.com/scheduling-r-scripts-and-processes-on-windows-and-unixlinux/


First Script:

The first script pulls data on 2 sequences. the first sequence is data for yesterday and the same day last year.
The second sequence is yesterday and the day before yesterday.
It does this so that you can compare what 311 complaints were like yesterday compared to the same day last year and to the day before.


Funny thing about the Query:

311 complaints come with descriptors, one general one like noise, and often a sub category like "loud music". 
However, not every general complaint descriptor has a sub category.
To handle this nature of the data set, the query that hits the open data api combines the general complaint category with the sub category.


Parameters and file directory for downloading an emailing the files:

you'll need to insert parameters for the email and set up a file directory for where the cron job will download files and then email them.

the paramters you'll need are: 
the email address you want to send the files from
the email address you want to send the files to
a subject for the email
a message for the email
the appropriate host for whatever email services you have.
The a port number
The email address you're sending the data from
The password for the email address you're sending the data from.


Here is the section of code for where you'll need to insert these parameters:

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



Second Script:

For the second script you'll need:

the path to the file that the cron job will run.
the parameters for the cron_add function
below is an example of waht I'm talking about.

#cmd <- cron_rscript("yourpath/311_cron2.R")

#cron_add(command = cmd, frequency = 'the frequency you want it run like daily', at='a time you want it run', id = 'the name for the cron job')
















