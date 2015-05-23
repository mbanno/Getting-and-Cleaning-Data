#call dplyr library
library(dplyr)

#Conbine train data and test data row-wise to create one dataset
df_X_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", header = F, sep="")
df_y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", header = F, sep="")
df_subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header = F, sep="")
df_test <- cbind(df_subject_test, df_y_test, df_X_test)

df_X_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", header = F, sep="")
df_y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", header = F, sep="")
df_subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header = F, sep="")
df_train <- cbind(df_subject_train, df_y_train, df_X_train)

df_merged <- rbind(df_test, df_train)

#obtain & clean feature(column) name
features <- read.csv('./UCI HAR Dataset/features.txt',header=F,sep=" ")
valid_feature_names <- make.names(names=features$V2, unique=TRUE, allow_ = TRUE)
valid_feature_names <- gsub("\\.+$","",valid_feature_names)
valid_feature_names <- gsub("\\.{2,}","\\.",valid_feature_names)
colnames(df_merged) <- c("subject", "activity_labels_index", valid_feature_names)

#obtain the table that describe the link between class labels and their activity name
activities <- read.csv('./UCI HAR Dataset/activity_labels.txt', header=F, sep=" ")
colnames(activities) <- c("activity_labels_index", "activity")

#Merge the dataset and activity table to assign activity names to each row
#and create subsetted table
df_tidy <- df_merged %>% left_join(activities, by="activity_labels_index") %>%
 select(subject, activity, contains(".mean."),contains(".std."),ends_with(".mean"),ends_with(".std"))

#Group the table by subject and activity 
#and summarise the table to create tidy table with the average of each variable 
#for each activity and each subject
df_tidy_mean <-  df_tidy %>% group_by(subject, activity) %>% summarise_each(funs(mean))

#Create output file
write.table(df_tidy_mean, "tidydata.txt", row.name=FALSE)

