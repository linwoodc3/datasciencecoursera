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


# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == 𝟶𝟼𝟶𝟹𝟽). Which city has seen greater changes over time in motor vehicle emissions?

###############################################################################
# Comparing motor vehicle pollutant sources in Baltimore Cit and Los Angeles from 1999-2008
###############################################################################

# Using chained dplyr workflow to select data from SCC; REALLY FAST!!!

motorvehicle.index <- SCC %>%
        filter(grepl("[ ]?Veh+[ ]?[^ ]?",Short.Name))%>%
        select(SCC)

# Index the values for both cities and bind the data frame together at the rows
balt.n.los_data <- rbind_list(filter(NEI, SCC %in% motorvehicle.index[,1] & fips=="24510"),
filter(NEI, SCC %in% motorvehicle.index[,1] & fips == "06037"))

# Build a summarized dataset
final_balt.n.los_data <- balt.n.los_data%>%
        group_by(year, fips)%>%
        summarise(total.ems=sum(Emissions,na.rm=TRUE),
                  average.ems=mean(Emissions))
# Get the absolute value of the changes every year by city
diff_balt.n.los_data <- final_balt.n.los_data%>%
        group_by(fips)%>%
        mutate(emissions.diff_magnitude = abs(total.ems-lag(total.ems)),emissions.diff = total.ems-lag(total.ems))

###############################################################################
# Plotting code
###############################################################################

comparison <- ggplot(diff_balt.n.los_data,aes(x=year,y=emissions.diff,fill=fips))

plot6 <-comparison+geom_bar(stat="identity", position='dodge')+
        scale_fill_brewer(palette = "Reds")+facet_grid(.~fips)+
        theme_economist() + scale_colour_economist()+
        geom_smooth(col="red")+
        scale_fill_discrete(guide_legend(title.position="right",title='City'),
                              labels = c("Los Angeles, CA","Baltimore City, MD"))+
        scale_x_continuous(breaks=c(2002,2005,2008), limits = c(2000,2010))+
        scale_y_continuous(limits = c(-700,600))+
        labs(x="Year of Measurement",y="Annual Change in Emissions",
             title="Comparing Changes in Motor Vehicle Emissions in Los Angeles and Baltimore City, MD")

print(plot6)
ggsave(plot6,file="./plot6.png")  