###############################################################################
# Information
###############################################################################

# Created by Linwood Creekmore III
# Started Feb 2016
# For Johns Hopkins University Data Scinece Certification track; Exploratory Data Analysis
# Github = https://github.com/linwoodc3

#### Code. ####

###############################################################################
# Check for required packages and load 
###############################################################################

# Checks the local R library(ies) to see if the required package(s) is/are installed or not. If the 
# package(s) is/are not installed, then the package(s) will be installed along with the required 
# dependency(ies).

if("chron" %in% rownames(installed.packages()) == FALSE) {install.packages("chron")}
library("chron")

###############################################################################
# Looking for locations of files
###############################################################################

# Checks to see if the UCI file is in the local directory; if not downloads and unzips 
if (!file.exists("household_power_consumption.txt")){
        temp <- tempfile()
        download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip",temp)
        unzip(temp)
}


###############################################################################
# Core exploratory plotting code
###############################################################################


# Read in the table
data <- read.table('./household_power_consumption.txt',sep=';',header=TRUE, stringsAsFactors = FALSE, na.strings = c("?"))

# Convert date column to date class (reads as a double)
data$Date <- as.Date(strptime(data$Date,"%d/%m/%Y"))

# Subset the data to 02-01-2007 and 02-02-2007
plotdata <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")

# Convert the time to a time class (reads as a double)
plotdata$Time <- chron(times = plotdata$Time)


# convert all character columns to numeric
# http://stackoverflow.com/questions/22772279/converting-multiple-columns-from-character-to-numeric-format-in-r
plotdata[,3:9] <- (sapply(plotdata[,3:9],as.double))

# Add new column with date and time combined
plotdata$newdate <- with(plotdata, as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M"))

# Send plot to png file in local directory
png(file = "./plot2.png", width = 480, height = 480,bg = "white")

# set outer margins
par(oma=c(0,0,2,0))

# Create the line plot
plot( plotdata$newdate, plotdata$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab= "", type="l", main="")

# Add text to top left corner
mtext("Plot 2",adj=0, outer = TRUE)

# Return plotting device to default
dev.off()
