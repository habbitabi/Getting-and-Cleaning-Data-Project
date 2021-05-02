
library(tidyverse)

#1 Downloading the DATA
FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip " 
if (!file.exists("Project_data")) {
  dir.create("Project_data")
  download.file(url = FileUrl, destfile = "./Project_data/Raw_data.zip")
}

#2 Check on your computer the folder named Project_data put it to Desktop and unzip it

#3 Merge Train data
setwd("~/Desktop/Project_data/UCI HAR Dataset/train")
x_train <- read.table(file = "X_train.txt")
y_train <- read.table(file = "Y_train.txt")
s_train <- read.table(file = "subject_train.txt")

#4 Merge Test data
setwd("~/Desktop/Project_data/UCI HAR Dataset/test")
x_test <- read.table(file = "X_test.txt")
y_test <- read.table(file = "y_test.txt")
s_test <- read.table(file = "subject_test.txt")

#5 Merge X, Y and S
X <- rbind(x_train,x_test)
Y <- rbind(y_train, y_test)
S <- rbind(s_train, s_test)

#6 Features and Activities
setwd("~/Desktop/Project_data/UCI HAR Dataset")
Feature <- read.table(file = "features.txt")
Activity <- read.table(file = "activity_labels.txt")

colnames(X) <- as.character(Feature$V2)
colnames(Y) <- "activity_number"
colnames(S) <- "subject"
colnames(Activity) <- c("activity_number", "activity")
New_Y <- merge(Y, Activity, by = "activity_number")

#7 Full Data
Full_data <- cbind(S,New_Y$activity,X)
colnames(Full_data)[2] <- "activity"

#8 Extracting mean and sd for each measurement
Mean_Sd <- Full_data %>% select(subject, activity, contains("mean"), contains("std"))

#9 Getting tidy dataset 
Tidy_data <- Mean_Sd %>% group_by(subject, activity) %>% summarise_all(mean)


#exporting my data
setwd("~/Desktop/Project_data")
write.csv(Tidy_data, "Tidy_data.csv")
