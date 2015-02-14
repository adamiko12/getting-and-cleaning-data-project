##set working directory
setwd("D:/אדם/datasciencecoursera/datascience - getting and cleaning data")
##set directory for the zip file
if(!file.exists("./data")){dir.create("./data")}
##download the zip file 
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./data/Dataset.zip")
##extract the zip file
unzip(zipfile="./data/Dataset.zip",exdir="./data")


##1.Merges the training and the test sets to create one data set
xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subtest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subtrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
# Combines data table (train, test) by rows
xall <- rbind(xtrain, xtest)
yall <- rbind(ytrain, ytest)
suball <- rbind(subtrain, subtest)


##2.Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("./data/UCI HAR Dataset/features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])


##3.Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
yall_names <- activities[yall[, 1], 2]
names(yall) <- "Activity"
xall <- xall[, mean_and_std_features]
names(xall) <- features[mean_and_std_features, 2]


##4.Appropriately labels the data set with descriptive variable names
names(suball) <- "ID"
all <- cbind(suball, yall, xall)


##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
averages_data <- ddply(all, .(ID, Activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)

