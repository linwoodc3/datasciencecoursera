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

# From the steps above, we get the indexes of the subsetted "std" measurements
g <- grep("std",features$V2); # This gives us a 33 by 2 dataframe using "dim"; 1:33 is our target range to apply column names

# Let's do a quick check to see if we are matching indexes correctly, we want to get 33 in the end
# We will extract the variable names, strip the "V", convert to numeric, and then "intersect" to see if all match

names(descriptivedat[1:33]); # this extracts variable names with indexes that match "std" subset indexes from features 
gsub("V","",names(descriptivedat[1:33])); # this strips the "V" from the names; we have character class
f <- as.numeric(gsub("V","",names(descriptivedat[1:33]))); # this converts characters to numeric data class
length(intersect(f,g)); # This should match the length of g above, if so, we can now add the column names

if (length(g)==length(f)) {
        test <- descriptivedat[1:33]
        names(test) <- tolower(features[grep("std",features$V2),][,2])
        
} else {
        warning("The dimensions of the indexes do not match up")
}

# Now we do the same for the "mean" measurements
g <- grep("mean",features$V2); # This gives us a by 2 dataframe using "dim"; 1:33 is our target range to apply column names
names(descriptivedat[34:79]); # this extracts variable names with indexes that match "std" subset indexes from features 
gsub("V","",names(descriptivedat[34:79])); # this strips the "V" from the names; we have character class
f <- as.numeric(gsub("V","",names(descriptivedat[34:79]))); # this converts characters to numeric data class
length(intersect(f,g)); # This should match the length of g above, if so, we can now add the column names

if (length(g)==length(f)) {
        test2 <- descriptivedat[34:79]
        names(test2) <- tolower(features[grep("mean",features$V2),][,2])
        
} else {
        warning("The dimensions of the indexes do not match up")
}

# combine the newly renamed columns and placeholder files
descriptivedat <- bind_cols(test,test2,descriptivedat["action"],subject[,1])

# cleaning up variable names to be descriptive; remove punctuation, expand shortened names
names(descriptivedat) <- gsub("-", "", names(descriptivedat))
names(descriptivedat) <-gsub("acc", "Accelerometer", names(descriptivedat))
names(descriptivedat) <-gsub("gyro", "Gyroscope", names(descriptivedat))
names(descriptivedat) <-gsub("mag", "Magnitude", names(descriptivedat))
names(descriptivedat) <-gsub("^t", "Time", names(descriptivedat))
names(descriptivedat) <-gsub("^f|freq", "Frequency", names(descriptivedat))
names(descriptivedat) <-gsub("\\(\\)", "", names(descriptivedat))
names(descriptivedat) <-gsub("x$", "inXdirection", names(descriptivedat))
names(descriptivedat) <-gsub("y$", "inYdirection", names(descriptivedat))
names(descriptivedat) <-gsub("z$", "inZdirection", names(descriptivedat))
names(descriptivedat) <-gsub("std", "StandardDeviation", names(descriptivedat))
names(descriptivedat) <-gsub("mean", "Mean", names(descriptivedat))
names(descriptivedat) <-gsub("bodybody|body", "Body", names(descriptivedat))
names(descriptivedat) <-gsub("gravity", "Gravity", names(descriptivedat))
names(descriptivedat) <-gsub("jerk", "Jerk", names(descriptivedat))

# adding descriptive values to remaining columns; removing a leftove column
descriptivedat$V1 <- NULL
descriptivedat$subject <- subject$V1 # append participant to the subject number
names(descriptivedat)[80:81] <- c("AssessedActivity","NumberofParticipatingSubject")

# Pass info to console
print(paste0("The data has descriptive variable names. Proceeding.... "))

###############################################################################
# Task 5, Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
###############################################################################

# Summarize multiple columsn in R using dplyr
# Help came from this link: http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr

tidydata <- descriptivedat %>% group_by(NumberofParticipatingSubject, AssessedActivity) %>% summarise_each(funs(mean,"mean",mean(.,na.rm=TRUE)))
write.table(tidydata, "~/projects/datasciencecoursera/cleaningdata/courseproject/tidydata.txt", sep=",", row.names = FALSE)


print(paste0("The tidy data set was created. Script complete."))

