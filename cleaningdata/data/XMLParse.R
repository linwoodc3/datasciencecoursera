if (!file.exists("data")){
    dir.create('data')
}

fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl,useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)