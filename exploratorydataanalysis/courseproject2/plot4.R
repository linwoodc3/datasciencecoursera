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

list.of.packages <- c("dplyr", "tidyr", "RColorBrewer","ggthemes","ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RColorBrewer)
library(dplyr)
library(tidyr)
library(ggthemes)
library(ggplot2)

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


# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

###############################################################################
# Basic plot to compare emissions from coal combustion-related source from 1999-2008
###############################################################################

# Using chained dplyr workflow to select data from SCC; REALLY FAST!!!

coalcomb.index <- SCC %>%
        filter(grepl("[ ]?Comb+[ ]?[^ ]?",Short.Name))%>%
        filter(grepl("[ ]?Coal+[ ]?[^ ]?",Short.Name))%>%
        select(SCC)

# Now extract relevant values from NEI
combust_data <- NEI[NEI$SCC %in% coalcomb.index$SCC,]

# Chain with dplyr again
summed_combust.data <- combust.data%>%
        group_by(year, type)%>%
        summarise(total.ems=sum(Emissions,na.rm=TRUE),mean= mean(Emissions,na.rm=TRUE))

# Use ggplot2 to make a pretty graphic comparing NonPoint to Point
coal <- ggplot(summed_combust.data, aes(x=year,y=mean))+
        geom_area(aes(group=type,fill=type))

plot4 <- coal+scale_x_continuous(breaks=c(1999,2002,2005,2008))+
        scale_fill_brewer(palette = "Accent")+
        theme_economist() + scale_colour_economist()+
        scale_fill_discrete(guide_legend(title=""),
                            breaks = c("NONPOINT","POINT"),
                            labels = c("NonPoint","Point"))+
        labs(x="Year of Measurement",y="Average emissions (tons of PM2.5)",
             title="Coal Combustion-related Emissions for Direct Producers Reduce Over 10 Years")

print(plot4)
ggsave(plot4,file="./plot4.png")        
        
    