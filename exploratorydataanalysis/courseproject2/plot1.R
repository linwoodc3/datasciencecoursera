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

list.of.packages <- c("dplyr", "tidyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

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
if (!file.exists('./data/files/Source_Classification_Code.rds')) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",temp)
    unzip(temp,exdir = './data/files')
    print(paste0("You did not have the file; download complete. Proceeding.... "))
} else {
    print(paste0("You have the target zip file. Proceeding.... "))        
}
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
#unzip(temp,exdir = './data/files')