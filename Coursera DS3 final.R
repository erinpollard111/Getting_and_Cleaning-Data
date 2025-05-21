library(dplyr)
filename <- "Coursera_DS3_Final.zip"

# Download file from the internet
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#Assigning each file to a data frame

feature <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge data

x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)
project_data <- cbind(subject, x_data, y_data)

#check work
view(project_data)

#select means, standard dev, and subject
selected_data <- project_data %>% select(subject, contains("mean"), contains("std")) 

#check work
view(selected_data)

#add in labels
selected_data$code <- activity[selected_data$code, 2]

#rename variables to friendly names

names(selected_data)[2] = "activity"
names(selected_data)<-sub("Acc", "accelerometer", names(selected_data))
names(selected_data)<-sub("Gyro", "gyroscope", names(selected_data))
names(selected_data)<-sub("BodyBody", "body", names(selected_data))
names(selected_data)<-sub("Mag", "magnitude", names(selected_data))
names(selected_data)<-sub("^t", "time", names(selected_data))
names(selected_data)<-sub("^f", "frequency", names(selected_data))
names(selected_data)<-sub("tBody", "timeBody", names(selected_data))
names(selected_data)<-sub("-mean()", "mean", names(selected_data), ignore.case = TRUE)
names(selected_data)<-sub("-std()", "standard deviation", names(selected_data), ignore.case = TRUE)
names(selected_data)<-sub("-freq()", "frequency", names(selected_data), ignore.case = TRUE)
names(selected_data)<-sub("angle", "angle", names(selected_data))
names(selected_data)<-sub("gravity", "gravity", names(selected_data))

#Create a grouped dataset


final_data <- selected_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

#Check
view(final_data)

write.table(final_data, "tidySet.txt", row.names = FALSE)





