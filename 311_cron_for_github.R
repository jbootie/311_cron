library(cronR)

cmd <- cron_rscript("yourpath/311_cron2.R")

cron_add(command = cmd, frequency = 'the frequency you want it run like daily', at='a time you want it run', id = 'the name for the cron job')









