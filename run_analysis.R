# Load Data & Explore
```{r}
library(plyr)
library(data.table)


## Load the Data
setwd("~/Documents/R Working Directory/Course_3_Getting_and_Cleaning_Data") ## Set the Working Directory

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" ### Provide the URL of where to get the file from 

download.file(fileUrl,destfile="./data/Dataset.zip",method="curl") ### Download the file and place it in a directory for analysis
unzip(zipfile="./data/Dataset.zip",exdir="./data") ### Unzip the ZIP file with the built in module

###Load the individual data files

setwd("~/Documents/R Working Directory/Course_3_Getting_and_Cleaning_Data/data/UCI HAR Dataset")
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

Activity  = read.table('./activity_labels.txt',header=FALSE) ## Load the Activity Labels
Features = read.table('./features.txt',header=FALSE) ## Load the Feature Description 

# Clean & Transform Data
xDataSet <- rbind(xTrain, xTest) ## Aggregate the X-Data
yDataSet <- rbind(yTrain, yTest) ## Aggregate the Y-Data
subjectDataSet <- rbind(subjectTrain, subjectTest) ## Aggregate the Subject Data

##Extract only the measurements on the mean and standard deviation for each measurement

xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", Features[, 2])]
names(xDataSet_mean_std) <- Features[grep("-(mean|std)\\(\\)", Features[, 2]), 2] 

##Apply descriptive activity names to name the activities in the data set

yDataSet[, 1] <- Activity[yDataSet[, 1], 2]
names(yDataSet) <- c("Activity")
yDataSet[1:5,]
names(subjectDataSet) <- c("Subject")

## Create a single data set
AggregatedDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

## Label the Columns with more descriptive names based on the information contained in the FEATURES.TXT File
names(AggregatedDataSet) <-gsub('tBodyAcc-',"Time_Domain_Body_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tGravityAcc-',"Time_Domain_Gravity_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyAccJerk-',"Time_Domain_Linear_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyGyro-',"Time_Domain_Angulaur_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyGyroJerk-',"Time_Domain_Angulaur_Acceleration_Velocity_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyAccMag-',"Time_Domain_Body_Acceleration_Magintude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tGravityAccMag-',"Time_Domain_Gravity_Acceleration_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyAccJerkMag-',"Time_Domain_Linear_Acceleration_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyGyroMag-',"Time_Domain_Angulaur_Acceleration_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('tBodyGyroJerkMag-',"Time_Domain_Angulaur_Acceleration_Velocity_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyGyroJerkMag-',"Frequency_Domain_Angulaur_Acceleration_Velocity_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyAccJerkMag-',"Frequency_Domain_Linear_Acceleration_Magnitude_",names(AggregatedDataSet))                             
names(AggregatedDataSet) <-gsub('fBodyGyroMag-',"Frequency_Domain_Angulaur_Acceleration_Magnitude_",names(AggregatedDataSet))                                       
names(AggregatedDataSet) <-gsub('fBodyGyroJerkMag-',"Frequency_Domain_Angulaur_Acceleration_Velocity_Magnitude_",names(AggregatedDataSet))    
names(AggregatedDataSet) <-gsub('fBodyAccJerk-',"Frequency_Domain_Linear_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyAccJerkMag-',"Frequency_Domain_Linear_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyGyroMag-',"Frequency_Domain_Angulaur_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyAccMag-',"Frequency_Domain_Body_Acceleration_Magintude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyGyro-',"Frequency_Domain_Angulaur_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyAcc-',"Frequency_Domain_Body_Acceleration_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyBodyAccJerk-',"Frequency_Domain_Linear_Acceleration_",names(AggregatedDataSet))                            
names(AggregatedDataSet) <-gsub('fBodyBodyGyroMag-', "Frequency_Domain_Angulaur_Acceleration_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('fBodyBodyGyroJerkMag-',"Frequency_Domain_Angulaur_Acceleration_Velocity_Magnitude_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('mean',"Mean_",names(AggregatedDataSet))
names(AggregatedDataSet) <-gsub('std',"Standard_Deviation_",names(AggregatedDataSet))

## Create a second, independent tidy data set with the average of each variable for each activity and each subject.

FinalDataSet<-aggregate(. ~Subject + Activity, AggregatedDataSet, mean)  ## Create a new data set that finds the average for each of the different Subjects and Activities
write.table(FinalDataSet, file = "./tidydata.txt",row.name=FALSE)

