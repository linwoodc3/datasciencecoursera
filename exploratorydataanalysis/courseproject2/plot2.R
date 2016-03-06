###############################################################################
# Information
###############################################################################

# Created by Linwood Creekmore III
# Started Mar 2016
# For Johns Hopkins University Data Scinece Certification track; Getting and Cleaning Data
# Github = https://github.com/linwoodc3

#### Code. ####

###############################################################################
# Check for required packages and load 
###############################################################################

list.of.packages <- c("dplyr", "tidyr", "RColorBrewer")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RColorBrewer)
library(dplyr)
library(tidyr)

###############################################################################
# Looking for locations of files
###############################################################################

if (!file.exists('data')) {
        dir.create('data')}
if (!file.exists('./data/files')) {
        dir.create('./data/files')}



###############################################################################
# Download the zip file
###############################################################################

# downloading the raw zip file and saving as a temporary file or, just passing step if file exists
temp <- tempfile()
if (!file.exists('./data/files/summarySCC_PM25.rds')) {
        print(paste0("You did not have the file; downloading.... "))        
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
        unzip(temp,exdir = './data/files')
        print(paste0("You did not have the file; download complete. Proceeding.... "))
} else {
        print(paste0("You have the target zip file. Proceeding.... "))        
}

###############################################################################
# Load the data
###############################################################################


# Condtional that tests if variable exists in environment; if not, loads with feedback
if (exists("NEI")) {
        print(paste0("The data set is already loaded! Continue"))
} else {
        # Adding timer just for fun!
        ptm <- proc.time()
        print(paste0("Loading the data..."))
        NEI <- readRDS('./data/files/summarySCC_PM25.rds')
        
        timer <- proc.time() - ptm
        if (timer > 10){
                print(paste0("The load finished but...you have a slow computer"))
        } else {
                print(paste0("Load complete! Nice computer hardware; that went fast!"))
        }
}

# Same as above, tests if table is loaded and keeps user informed.
if (exists("SCC")) {
        print(paste0("The code table is already loaded! Continue"))
} else {
        ptm <- proc.time()
        print(paste0("Loading the table..."))
        SCC <- readRDS('./data/files/Source_Classification_Code.rds')
        
        timer <- proc.time() - ptm
        if (timer > 2){
                print(paste0("The load finished but...you have a slow computer"))
        } else {
                print(paste0("Load complete! Nice computer hardware; that went fast!"))
        }
}


# Have total emissions from PM2.5 decreased in the Baltimore City,
# Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

###############################################################################
# Basic plot to compare emissions from 1999-2008
###############################################################################

# Create a subset of Baltimore only data

bmore <- subset(bmore,bmore$fips=='24510')

print(dim(bmore))

# Sending plot to png file  
png(file = "./plot2.png", width = 480, height = 480, bg="white")

# Setting the margins
par(mar=c(4,4,3,1))

# Look at "total" emissions over 1999-2008; I assume this is a histogram to 
# display magnitude or total value over time.

# Building the base plot, with logarithmic scale, without tick marks

df.bar <- barplot(apply(years,1,function(x) sum(bmore$Emissions[bmore$year == x])),
                  col=brewer.pal(4,"Reds"), ylim = c(0,max(apply(years,1,function(x) sum(bmore$Emissions[bmore$year == x])))+1000))

# making sure the graph prints to the device
df.bar

# Adding the line showing the trend of the data through the years
lines(x=df.bar,y=apply(years,1,function(x) sum(bmore$Emissions[bmore$year == x])),lwd=3, col = "orange")
points(x=df.bar,y=apply(years,1,function(x) sum(bmore$Emissions[bmore$year == x])), pch=19,col='dark orange',cex=1.3)

# Annotating and labeling
title(main = "Baltimore, MD Total Emission Trends - 1999-2008",
      xlab="Year of Measurement",ylab="Emissions")

# Add custom tick marks for years
axis(1,at=c(0.7,1.9,3.1,4.3),labels=c(1999,2002,2005,2008))

# Return tPrinting the answer
print("No! PM2.5 levels in Baltimore, MD have not decreased every year, 
      but has an overall downward trend in the data used for this project.")

#o base plotting device
dev.off()