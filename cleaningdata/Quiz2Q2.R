if (!file.exists("data")){
    dir.create('data')
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl,destfile = "./data/comsurv.csv")
list.files('./data/')

dateDownloaded <- date()
dateDownloaded

acs <- read.table('./data/comsurv.csv',sep=',',header=TRUE)