library(data.table)
library(dplyr)

filenameandpath <- ".\\data\\har_dataset.zip"

# Download the .zip file; uncomment this code to run it if required
# fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileURL,filenameandpath)

# Read the features.txt file - we will use this later on to map from column number to meaningful column names
features <- read.table(unz(filenameandpath,"UCI HAR Dataset/features.txt"),header=FALSE,col.names=c("column_number","column_name"))

# Get the activity_labels.txt file - we will use this later on to map from activity_id to meaningful activity_name values
activity_name <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/activity_labels.txt"),header=FALSE,col.names=c("activity_id","activity_name")))
setkey(activity_name, activity_id)

# Load the test subject, activity, and core variable data tables
subject <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/test/subject_test.txt"),header=FALSE,col.names=c("subject_id")))
activity <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/test/y_test.txt"),header=FALSE,col.names=c("activity_id")))
x <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/test/X_test.txt")))
# Merge the test subject, activity, and core variable data tables together, so we have the variables/observations, plus the test subject_id and the activity_id that they relate to
x <- cbind(x,subject,activity)
rm("subject","activity")

# Load the train subject, activity, and core variable data tables
subject_train <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/train/subject_train.txt"),header=FALSE,col.names=c("subject_id")))
activity_train <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/train/y_train.txt"),header=FALSE,col.names=c("activity_id")))
x_train <- data.table(read.table(unz(filenameandpath,"UCI HAR Dataset/train/X_train.txt")))
# Merge the train subject, activity, and core variable data tables together, so we have the variables/observations, plus the test subject_id and the activity_id that they relate to
x_train <- cbind(x_train,subject_train,activity_train)
rm("subject_train","activity_train")

# Merge the test and the train combined data tables into one
x <- rbind(x,x_train)
rm("x_train")

# Subset only the mean columns, std columns, and the activity_id and subject_id columns, using column numbers derived from the features.txt file
# The majority of the columns are subset by index (returned by the grep); activity_id and subject_id are subset by name.
mean_std <- select(x,grep("(mean\\(\\))|(std\\(\\))",features$column_name),activity_id,subject_id)

# Replace the defaulted column names with meaningful ones, derived from the features.txt file, and modified to make them valid in R and easier to type
# Remove all ( and ) characters
# Replace all - and , with _
colnamelist <- tolower(sub("\\)","",sub("\\(","",gsub("-","_",gsub(",","_",grep("(mean\\(\\))|(std\\(\\))",features$column_name,value=TRUE))))))
colnamelist <- append(colnamelist,c("activity_id","subject_id"),length(colnamelist))
colnames(mean_std) <- colnamelist

# Add the activity_name variable, merging using the activity_id variable
setkey(mean_std, activity_id)
mean_std <- merge(mean_std,activity_name)

# Create the summary data set, with the average of all variables for each subject_id, activity_id and activity_name combination.
# PLEASE NOTE - activity_id and activity_name are of course related. We group by them both/output them both to ease with lookup and interpretation of data.
summary <- group_by(mean_std,subject_id,activity_id,activity_name)
summary <- summarize(summary,tbodyacc_mean_x_mean = mean(tbodyacc_mean_x),
          tbodyacc_mean_y_mean = mean(tbodyacc_mean_y),
          tbodyacc_mean_z_mean = mean(tbodyacc_mean_z),
          tbodyacc_std_x_mean = mean(tbodyacc_std_x),
          tbodyacc_std_y_mean = mean(tbodyacc_std_y),
          tbodyacc_std_z_mean = mean(tbodyacc_std_z),
          tgravityacc_mean_x_mean = mean(tgravityacc_mean_x),
          tgravityacc_mean_y_mean = mean(tgravityacc_mean_y),
          tgravityacc_mean_z_mean = mean(tgravityacc_mean_z),
          tgravityacc_std_x_mean = mean(tgravityacc_std_x),
          tgravityacc_std_y_mean = mean(tgravityacc_std_y),
          tgravityacc_std_z_mean = mean(tgravityacc_std_z),
          tbodyaccjerk_mean_x_mean = mean(tbodyaccjerk_mean_x),
          tbodyaccjerk_mean_y_mean = mean(tbodyaccjerk_mean_y),
          tbodyaccjerk_mean_z_mean = mean(tbodyaccjerk_mean_z),
          tbodyaccjerk_std_x_mean = mean(tbodyaccjerk_std_x),
          tbodyaccjerk_std_y_mean = mean(tbodyaccjerk_std_y),
          tbodyaccjerk_std_z_mean = mean(tbodyaccjerk_std_z),
          tbodygyro_mean_x_mean = mean(tbodygyro_mean_x),
          tbodygyro_mean_y_mean = mean(tbodygyro_mean_y),
          tbodygyro_mean_z_mean = mean(tbodygyro_mean_z),
          tbodygyro_std_x_mean = mean(tbodygyro_std_x),
          tbodygyro_std_y_mean = mean(tbodygyro_std_y),
          tbodygyro_std_z_mean = mean(tbodygyro_std_z),
          tbodygyrojerk_mean_x_mean = mean(tbodygyrojerk_mean_x),
          tbodygyrojerk_mean_y_mean = mean(tbodygyrojerk_mean_y),
          tbodygyrojerk_mean_z_mean = mean(tbodygyrojerk_mean_z),
          tbodygyrojerk_std_x_mean = mean(tbodygyrojerk_std_x),
          tbodygyrojerk_std_y_mean = mean(tbodygyrojerk_std_y),
          tbodygyrojerk_std_z_mean = mean(tbodygyrojerk_std_z),
          tbodyaccmag_mean_mean = mean(tbodyaccmag_mean),
          tbodyaccmag_std_mean = mean(tbodyaccmag_std),
          tgravityaccmag_mean_mean = mean(tgravityaccmag_mean),
          tgravityaccmag_std_mean = mean(tgravityaccmag_std),
          tbodyaccjerkmag_mean_mean = mean(tbodyaccjerkmag_mean),
          tbodyaccjerkmag_std_mean = mean(tbodyaccjerkmag_std),
          tbodygyromag_mean_mean = mean(tbodygyromag_mean),
          tbodygyromag_std_mean = mean(tbodygyromag_std),
          tbodygyrojerkmag_mean_mean = mean(tbodygyrojerkmag_mean),
          tbodygyrojerkmag_std_mean = mean(tbodygyrojerkmag_std),
          fbodyacc_mean_x_mean_mean = mean(fbodyacc_mean_x),
          fbodyacc_mean_y_mean_mean = mean(fbodyacc_mean_y),
          fbodyacc_mean_z_mean_mean = mean(fbodyacc_mean_z),
          fbodyacc_std_x_mean_mean = mean(fbodyacc_std_x),
          fbodyacc_std_y_mean = mean(fbodyacc_std_y),
          fbodyacc_std_z_mean = mean(fbodyacc_std_z),
          fbodyaccjerk_mean_x_mean = mean(fbodyaccjerk_mean_x),
          fbodyaccjerk_mean_y_mean = mean(fbodyaccjerk_mean_y),
          fbodyaccjerk_mean_z_mean = mean(fbodyaccjerk_mean_z),
          fbodyaccjerk_std_x_mean = mean(fbodyaccjerk_std_x),
          fbodyaccjerk_std_y_mean = mean(fbodyaccjerk_std_y),
          fbodyaccjerk_std_z_mean = mean(fbodyaccjerk_std_z),
          fbodygyro_mean_x_mean = mean(fbodygyro_mean_x),
          fbodygyro_mean_y_mean = mean(fbodygyro_mean_y),
          fbodygyro_mean_z_mean = mean(fbodygyro_mean_z),
          fbodygyro_std_x_mean = mean(fbodygyro_std_x),
          fbodygyro_std_y_mean = mean(fbodygyro_std_y),
          fbodygyro_std_z_mean = mean(fbodygyro_std_z),
          fbodyaccmag_mean_mean = mean(fbodyaccmag_mean),
          fbodyaccmag_std_mean = mean(fbodyaccmag_std),
          fbodybodyaccjerkmag_mean_mean = mean(fbodybodyaccjerkmag_mean),
          fbodybodyaccjerkmag_std_mean = mean(fbodybodyaccjerkmag_std),
          fbodybodygyromag_mean_mean = mean(fbodybodygyromag_mean),
          fbodybodygyromag_std_mean = mean(fbodybodygyromag_std),
          fbodybodygyrojerkmag_mean_mean = mean(fbodybodygyrojerkmag_mean),
          fbodybodygyrojerkmag_std_mean = mean(fbodybodygyrojerkmag_std))

# Output the run_analysis_summary.TXT file - the data summarised by subject_id, activity_id, and activity_name, with the mean (average) of each variable for each combination
write.table(summary,".\\data\\run_analysis_summary.txt",sep="\t",row.name=FALSE)
