#download file
zipfile<-tempfile(fileext="")
options(timeout=120)
ucl_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=ucl_url,destfile=zipfile,mode="wb")
files = unzip(zipfile)
files

# READING DATA
features <- read.table("./UCI HAR Dataset/features.txt", colClasses = "character")[,2]

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features, check.names = F)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features, check.names = F)
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = c('activity'))
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c('n','text'))

# concatenate training and testing datasets
data_ucl_dup <- cbind(rbind(X_train, X_test),
                   rbind(y_train, Y_test), 
                   rbind(subject.train, subject.test))
dim(data_ucl_dup)
# remove duplicates from data
data_ucl <- data_ucl_dup[, !duplicated(colnames(data_ucl_dup))]
dim(data_ucl)

install.packages("sos")
library(sos)
install.packages("dplyr")
library(dplyr)
# select data for mean and std values only
selective_data <- select(all_data,  matches("mean\\(\\)|std\\(\\)|subject|activity"))
dim(selective_data)

# rename activities with descriptive names
descriptive <- within(selective_data, activity <- factor(activity, labels = activity_labels[,2]))

# aggregate mean values for activities and subjects
descriptive_name <- aggregate(x = descr[, -c(67,68)], 
                        by = list(descr[,'subject'], descr[, 'activity']),
                        FUN = mean)
dim(descriptive_name)

write.csv(descriptive_name, "Lab5_tidy_df.csv", row.names=TRUE)
write.csv(descr_name, "lab_5_tidy_dataset.csv", row.names=F)


