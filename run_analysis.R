library(dplyr)


## Downloading and unzipping the dataset if not already downloaded:
dataset <- "UCI HAR Dataset.zip"
if (!file.exists(dataset)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, dataset, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(dataset)
}

## Reading all files:
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
features[,2] <- as.character(features[,2])
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
activity_labels[,2] <- as.character(activity_labels[,2])
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Merging all the datasets:
x_datasets <- rbind(x_train, x_test)
y_datasets <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
Merged_dataset <- cbind(subject, x_datasets, y_datasets)

## Extract only the measurements with mean and standard deviation:
Merged_dataset <- Merged_dataset %>% select(subject, code, contains("mean"), contains("std"))
Merged_dataset$code <- activity_labels[Merged_dataset$code, 2]

## Use descriptive activity names to name the activities in the dataset:
names(Merged_dataset)[1] <- "Subject"
names(Merged_dataset)[2] <- "Activity"
names(Merged_dataset) <- gsub("Acc", "Accelerometer", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("Gyro", "Gyroscope", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("BodyBody", "Body", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("Mag", "Magnitude", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("^t", "Time", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("^f", "Frequency", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("tBody", "TimeBody", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("-mean()", "Mean", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("-std()", "STD", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("-freq()", "Frequency", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("angle", "Angle", names(Merged_dataset), ignore.case = TRUE)
names(Merged_dataset) <- gsub("gravity", "Gravity", names(Merged_dataset), ignore.case = TRUE)

## Making a second tidy dataset:
Tidy_dataset <- Merged_dataset %>%
  group_by(Subject, Activity) %>%
  summarise_all((mean))
write.table(Tidy_dataset, "Tidy_dataset.txt", row.name=FALSE)
