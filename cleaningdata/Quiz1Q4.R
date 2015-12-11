if (!file.exists("data")){
    dir.create('data')
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl,useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)

xpathSApply(rootNode,'//21231',xmlValue)