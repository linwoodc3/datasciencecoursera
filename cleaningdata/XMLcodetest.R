if (!file.exists('data')) {
    dir.create('data')
}

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternalNodes = TRUE)
scores <- xpathSApply(doc,"//li[@class='score']",xmlValue)
scores