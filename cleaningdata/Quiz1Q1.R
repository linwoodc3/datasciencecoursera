if (!file.exists("data")){
    dir.create('data')
}

fileUrl <- "https://d396qusza409rc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile = "./data/microdata06.csv",method='curl')
list.files('./data/')

dateDownloaded <- date()
dateDownloaded

microdata06 <- read.table('./data/microdata06.csv',sep=',',header=TRUE)