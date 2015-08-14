# uncomment to set your working dir 
# setwd("C:\\Users\\support\\Documents\\3 Getting and Cleaning Data\\course project")

# uncomment if you nead to downlod and unzip to data files
# dataPath="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# zipFileName="getdata_projectfiles_UCI HAR Dataset.zip"

dataFileFeatureLabel="UCI HAR Dataset\\features.txt"
dataFileActivityLabel="UCI HAR Dataset\\activity_labels.txt"
dataFileTrainingSet="UCI HAR Dataset\\train\\X_train.txt"
dataFileTrainingLabel="UCI HAR Dataset\\train\\y_train.txt"
dataFileTrainingSubject="UCI HAR Dataset\\train\\subject_train.txt"
dataFileTestSet="UCI HAR Dataset\\test\\X_test.txt"
dataFileTestLabel="UCI HAR Dataset\\test\\y_test.txt"
dataFileTestSubject="UCI HAR Dataset\\test\\subject_test.txt"
dataFileTrainingTotalAccX="UCI HAR Dataset\\train\\Inertial Signals\\total_acc_x_train.txt"
dataFileTrainingTotalAccY="UCI HAR Dataset\\train\\Inertial Signals\\total_acc_y_train.txt"
dataFileTrainingTotalAccZ="UCI HAR Dataset\\train\\Inertial Signals\\total_acc_z_train.txt"
dataFileTrainingBodyAccX="UCI HAR Dataset\\train\\Inertial Signals\\body_acc_x_train.txt"
dataFileTrainingBodyAccY="UCI HAR Dataset\\train\\Inertial Signals\\body_acc_y_train.txt"
dataFileTrainingBodyAccZ="UCI HAR Dataset\\train\\Inertial Signals\\body_acc_z_train.txt"
dataFileTrainingBodyGyroX="UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_x_train.txt"
dataFileTrainingBodyGyroY="UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_y_train.txt"
dataFileTrainingBodyGyroZ="UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_z_train.txt"

# uncomment this line if you nead to download Zip file
# download.file(dataPath,zipFileName,mode = "wb")
# unzip(zipFileName )

# featureLabel
featureLabel <- read.table(dataFileFeatureLabel, sep = "", header = FALSE,col.names = c("feature.id","feature.label"))
dim(featureLabel)
head(featureLabel)

# activityLabel
activityLabel <- read.table(dataFileActivityLabel, sep = "", header = FALSE,col.names = c("activity.id","activity.label"))
dim(activityLabel)
head(activityLabel)

# trainingSet
trainingSet <- read.table(dataFileTrainingSet, sep = "", header = FALSE,col.names = featureLabel$feature.label)
dim(trainingSet)
head(trainingSet)

# trainingLabel
trainingLabel <- read.table(dataFileTrainingLabel, sep = "", header = FALSE,col.names = c("activity.id"))
dim(trainingLabel)
head(trainingLabel)
unique(trainingLabel)
table(trainingLabel)

# trainingSubject
trainingSubject <- read.table(dataFileTrainingSubject, sep = "", header = FALSE,col.names = c("subject.id"))
dim(trainingSubject)
head(trainingSubject)
unique(trainingSubject)
table(trainingSubject)


# testSet
testSet <- read.table(dataFileTestSet, sep = "", header = FALSE,col.names = featureLabel$feature.label)
dim(testSet)
head(testSet)

# testLabel
testLabel <- read.table(dataFileTestLabel, sep = "", header = FALSE,col.names = c("activity.id"))
dim(testLabel)
head(testLabel)
unique(testLabel)
table(testLabel)

# testSubject
testSubject <- read.table(dataFileTestSubject, sep = "", header = FALSE,col.names = c("subject.id"))
dim(testSubject)
head(testSubject)
unique(testSubject)
table(testSubject)


# 1) Merges the training and the test sets to create one data set.
# for training data
dim(trainingSubject)
dim(trainingLabel)
dim(trainingSet)
#test and training Subject's are distinct
#trainingData <- cbind(test_training.id = "training",trainingSubject,trainingLabel,trainingSet)
trainingData <- cbind(trainingSubject,trainingLabel,trainingSet)
colnames(trainingData)
dim(trainingData)
# for test data
dim(testSubject)
dim(testLabel)
dim(testSet)
#test and training Subject's are distinct
#testData <- cbind(test_training.id = "test",testSubject,testLabel,testSet)
testData <- cbind(testSubject,testLabel,testSet)
colnames(testData)
dim(testData)
# merge
bigDataset <- rbind(trainingData,testData)
dim(bigDataset)
colnames(testData)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
dim(bigDataset)
bigDataset <- bigDataset[,unique(append(append(grep(c("[.]id"),colnames(bigDataset)) , grep(c("[.]mean[.]"),colnames(bigDataset))), grep(c("[.]std[.]"),colnames(bigDataset))))  ]
dim(bigDataset)
colnames(bigDataset)

# 3) Uses descriptive activity names to name the activities in the data set
activityLabel
install.packages("plyr")
library(plyr)
dim(bigDataset)
bigDatasetActId = data.frame(activity.id=bigDataset[,c("activity.id")])
#colnames(bigDatasetActId) =c("activity.id")
head(bigDatasetActId)
bigDatasetActId <- join(bigDatasetActId, activityLabel, "activity.id", match = "first")
bigDataset$activity.id = bigDatasetActId$activity.label
dim(bigDataset)
bigDataset[1,1:6]

# 4) Appropriately labels the data set with descriptive variable names. 
# for a easiest work on data, variable names have been set before upper on this code.

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averageByActivityAndSubject <- aggregate(bigDataset[,3:dim(bigDataset)[2]],by = list(subject=bigDataset$subject.id,activity=bigDataset$activity.id),FUN = mean, subset=bigDataset[,3:4])
dim(averageByActivityAndSubject)
head(averageByActivityAndSubject)
write.table(averageByActivityAndSubject,"averageByActivityAndSubject.txt",row.names = FALSE)
