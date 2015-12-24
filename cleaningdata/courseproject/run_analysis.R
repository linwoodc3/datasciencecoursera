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
# Download the zip file
###############################################################################

# downloading the raw zip file and saving as a temporary file or, just passing step if file exists
temp <- tempfile()
if (!file.exists('./data/files/UCI HAR Dataset')) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
        unzip(temp,exdir = './data/files')
        print(paste0("You did not have the file; download complete. Proceeding.... "))
} else {
        print(paste0("You have the target zip file. Proceeding.... "))        
        }
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
#unzip(temp,exdir = './data/files')

###############################################################################
# Task 1, Downloading and Merging the test and train data sets
###############################################################################

#downloading the training sets
X_train = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/train/X_train.txt')))
y_train = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/train/y_train.txt')))
subject_train = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/train/subject_train.txt')))

#downloading the test sets
y_test = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/test/y_test.txt')))
X_test = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/test/X_test.txt')))
subject_test = tbl_df(data.frame(read.table('./data/files/UCI HAR Dataset/test/subject_test.txt')))

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

# Send notification to console
print(paste0("The data merge (Task1) is complete. Proceeding.... "))

###############################################################################
# Task 2, Extract only the measurements on the mean and standard deviation 
###############################################################################

# we get the expected outcome in one elegant line of code
meanstddat <- bind_cols(dat[grep("std",features$V2)],dat[grep("mean",features$V2)])

# but here are the individual steps
grep("std",features$V2); # Used to pattern match feature with "std" in the string name
grep("mean",features$V2); # Used to pattern match feature with "mean" in the string name
dat[grep("std",features$V2)]; # Used to subset the combined data set to pull out only std measurements
dat[grep("mean",features$V2)]; # Used to subset the combined data set to pull out only mean measurements
bind_cols(dat[grep("std",features$V2)],dat[grep("mean",features$V2)]); # Use bind_cols from dplyr to join the datasets

# Send notification to console
print(paste0("Measurements for mean and std have been extracted (Task2). Proceeding.... "))

###############################################################################
# Task 3, Use descriptive activity names to name the activities in the data set 
###############################################################################

# Add description of activities to the data set
y <- mutate( y, action = ifelse(y$V1 ==1,"WALKING",ifelse(y$V1 ==2,"WALKING_UPSTAIRS",ifelse(y$V1==3,"WALKING_DOWNSTAIRS",ifelse(y$V1==4,"SITTING",ifelse(y$V1 ==5,"STANDING",ifelse(y$V1 == y,"LAYING")))))))
colnames(y[2]) <- "activity"
descriptivedat <- bind_cols(meanstddat,y[2])
descriptivedat$action <- tolower(descriptivedat$action)

# Send notification to console
print(paste0("Descriptive activity names were appeneded to the dataframe (Task 3). Proceeding.... "))

###############################################################################
# Task 4, Appropriately labels the data set with descriptive variable names. 
###############################################################################

# Adding variable names
#colnames(X) <- features[,2]
#colnames(y) <- "activity"
#colnames(subject) <- "subject"

# Clean workspace

#print(paste0("The data merge is complete. Proceeding.... "))

# Graveyard

# first, we remember how to convert the variable names to all lowercase, Week 4, video 1 "Editing Text Variables"
#colnames(dat)<- tolower(names(dat))

# create a list of column names that only have "std" and "mean", then subset dat by this list
#test <- grep("std",tolower(names(dat)),value = TRUE)
#stdtest <- dat[test]

#test <- grep("mean",tolower(names(dat)),value = TRUE)
#meantest <- dat[test]

# bind the columsn, creating a data set with only mean and standard deviation measurements
#meanstddat <- bind_cols(stdtest,meantest)
