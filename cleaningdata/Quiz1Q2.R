if (!file.exists("data")){
    dir.create('data')
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl,destfile = "./data/natgas.xlsx",method='curl')
list.files('./data/')

dateDownloaded <- date()
dateDownloaded

library(xlsx)
natgasData <- read.xlsx('./data/natgas.xlsx',sheetIndex=1,header=TRUE)

colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx('./data/natgas.xlsx',sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)

