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

list.of.packages <- c("dplyr", "tidyr", "RColorBrewer","ggthemes")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RColorBrewer)
library(dplyr)
library(tidyr)
library(ggthemes)

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


# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad
#  variable, which of these four sources have seen decreases in emissions from 1999–2008 for 
#  Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting 
#  system to make a plot answer this question.

###############################################################################
# Basic plot to compare emissions from 1999-2008
###############################################################################

# Using chained dplyr workflow to select data; REALLY FAST!!!

bmore_grouped <- NEI %>%
        
        filter(fips =='24510') %>%
        group_by(type,year) %>%
        summarise(total.ems=sum(Emissions,na.rm=TRUE))


# Using ggplot2 to plot different panels for comparison; use color palette
# Also used the "Economist" theme to get a polished look
plot3 <- ggplot(bmore_grouped,aes(year,total.ems, fill=type))+
        geom_bar(stat='identity', position="dodge")+
        scale_fill_brewer(palette = "Paired")+facet_grid(.~type) +
        scale_x_continuous(breaks=c(1999,2002,2005,2008))+
        labs(x="Year of Measurement",y="Magnitude fo PM2.5 Emissions", title="In 10 years, how well is Baltimore City,MD doing at reducing pollutants?")+
        theme_economist() + scale_colour_economist()+geom_smooth(color="red")

#Printing the answer
print("As can be seen in the graphic, \"POINT\" source had a spike in 2005 while other years have
a consistent downward trend")

ggsave(plot3,file="./plot3.png")


