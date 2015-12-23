###############################################################################
# Information
###############################################################################

# Created by Linwood Creekmore III
# Started Dec 2015
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




# help for codebook http://biostats.ucdavis.edu/SampleCodeBook.php

###############################################################################
# Looking for locations of files
###############################################################################

# downloading the raw zip file and saving as a temporary file or, just passing step if file exists
temp <- tempfile()
if (!file.exists('./data/files/UCI HAR Dataset')) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
        unzip(temp,exdir = './data/files')
} else {
        print(paste0("You have the target zip file. Proceeding.... "))        
        }
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
#unzip(temp,exdir = './data/files')

###############################################################################
# Task 1, Downloading and Merging the test and train data sets
###############################################################################

#downloading the training sets
X_train = data.frame(read.table('./data/files/UCI HAR Dataset/train/X_train.txt'))
y_train = data.frame(read.table('./data/files/UCI HAR Dataset/train/y_train.txt'))
subject_train = data.frame(read.table('./data/files/UCI HAR Dataset/train/subject_train.txt'))

#downloading the test sets
y_test = data.frame(read.table('./data/files/UCI HAR Dataset/test/y_test.txt'))
X_test = data.frame(read.table('./data/files/UCI HAR Dataset/test/X_test.txt'))
subject_test = data.frame(read.table('./data/files/UCI HAR Dataset/test/subject_test.txt'))

#downloading the feature names
features = data.frame(read.table('./data/files/UCI HAR Dataset/features.txt'))

#this removes the temporary file
rm('temp')

# Combining the subjects data set
subject = bind_rows(subject_train,subject_test)

# Joining train and test sets to create X and y sets 
X <- bind_rows(X_train,X_test)
y <- bind_rows(y_test,y_train)



# Combining the X and y data to one single dataframe
dat <- bind_cols(X,y, subject)

# Clean workspace

print(paste0("The data merge is complete. Proceeding.... "))
