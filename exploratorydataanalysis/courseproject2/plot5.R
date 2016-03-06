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

motorvehicle.index <- SCC %>%
        filter(grepl("[ ]?Veh+[ ]?[^ ]?",Short.Name))%>%
        select(SCC)

motorvehicle_data <- filter(NEI, SCC %in% motorvehicle.index[,1] & fips=="24510")

final_motodata <- motorvehicle_data%>%
        group_by(year)%>%
        summarise(total.ems=sum(Emissions,na.rm=TRUE),
                  average.ems=mean(Emissions))
        
g <- ggplot(final_motodata, aes(x=year,y=total.ems, fill=total.ems))

plot5 <-g+geom_bar(stat='identity')+
        geom_smooth(col='red')+
        scale_x_continuous(breaks=c(1999,2002,2005,2008))+
        theme_economist() + scale_colour_economist()+
        scale_fill_continuous(guide_legend(title.position="right",title='EMS level'),
                           breaks = seq(100,300,by=100),
                           labels = seq(100,300,by=100))+
        labs(x="Year of Measurement",y="Total emissions (tons of PM2.5)",
             title="Evolution of PM2.5 Emissions from Motor Vehicles in Baltimore City, MD Over 10 Years")

print(plot5)
ggsave(plot5,file="./plot5.png")        
        
        
