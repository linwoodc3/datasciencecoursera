if(!file.exists("./data/textvariables")){dir.create("./data/textvariables")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl,destfile = "./data/textvariables/cameras.csv",method="curl")
cameraData <- read.csv("./data/textvariables/cameras.csv")
names(cameraData)

firstelement <- function(x){x[1]}
sapply(splitNames,firstelement)

fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl12<- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile = "./data/textvariables/reviews.csv",method="curl")
download.file(fileUrl2,destfile = "./data/textvariables/solutions.csv",method="curl")
reviews <- read.csv("./data/textvariables/reviews.csv"); solutions <- read.csv("./data/textvariables/solutions.csv")
head(reviews,2)