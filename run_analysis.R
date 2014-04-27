# 1. Merges the training and the test sets to create one data set.

# Firstly, we join the data values in a single Data Frame X
X.train <- read.table("./train/X_train.txt")
X.test <- read.table("./test/X_test.txt")
X <- rbind(X.train, X.test)
remove(X.train,X.test)

# Secondly, we join the subjects ID's in a single Data Frame S
S.train <- read.table("./train/subject_train.txt")
S.test <- read.table("./test/subject_test.txt")
S <- rbind(S.train, S.test)
remove(S.train,S.test)

# Thirdly, we join the activity numbers in a single Data Frame Y
Y.train <- read.table("./train/y_train.txt")
Y.test <- read.table("./test/y_test.txt")
Y <- rbind(Y.train, Y.test)
remove(Y.train,Y.test)

# Besides:
# We get the feature names 
Features <- read.table("./features.txt")

# and the activity names
Activities <- read.table("./activity_labels.txt")

# Finally, we name all the columns for all the Data Frames
names(Features) <- c("featureId","featureName")
names(Activities) <- c("activityId","activityName")
# For X, we get the column names from the second column of Features Data Frame
names(X) <- Features$featureName
names(S)<-c("subject")
names(Y) <- c("activity")

# We merge the three data frames into only one, called Data
Data <- cbind(X, S, Y)
remove(X,S,Y,Features)

# We identify the duplicated column names
which(duplicated(names(Data)))

# Function to add a suffix to several columns
addSuffix <- function(x, suffix){
    unlist(lapply(colnames(Data)[x],function(i){paste0(i, suffix)}))
}

# We differenciate the different set of indices for adding different suffixes
xIndices <- c(303:316,382:395,461:474)
yIndices <- c(317:330,396:409,475:488)
zIndices <- c(331:344,410:423,489:502)

# And we rename those duplicated columns, adding X, Y, Z to them:
colnames(Data)[xIndices] <- addSuffix(xIndices,"X")
colnames(Data)[yIndices] <- addSuffix(yIndices,"Y")
colnames(Data)[zIndices] <- addSuffix(zIndices,"Z")

remove(xIndices,yIndices,zIndices)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.

# We get the indices for those columns with means and std
onlyMeanAndStd <- grep("-mean\\(\\)|-std\\(\\)", names(Data))
# And we reassign the Data data frame with the last two columns (Data$subject and Data$activity)
Data <- Data[,c(onlyMeanAndStd,562,563)]

remove(onlyMeanAndStd)

# 3.Uses descriptive activity names to name the activities in the data set

# We prepare the activity names to camel case format
Activities$activityName <-gsub("(_.)","\\U\\1",tolower(Activities$activityName),perl=T)
# and we remove the '_' char
Activities$activityName <-gsub("_","",Activities$activityName)

# Finally, We convert the activity numbers from Data$activity into activity names
# We get the matching from Activities$activityName
Data$activity = Activities[Data$activity, 2]

remove(Activities)

# 4.Appropriately labels the data set with descriptive activity names.

# Exchange "BodyBody" by just "Body"
colnames(Data) <- gsub("BodyBody","Body",names(Data))
# Remove the "()" from our column names
colnames(Data) <- gsub('mean\\(\\)',"Mean",names(Data))
colnames(Data) <- gsub('std\\(\\)',"Std",names(Data))
# Remove the '-' from our column names
colnames(Data) <- gsub('\\-',"",names(Data))

# Rename 't' and 'f', by "time" and "frequency"
colnames(Data) <- gsub('^t',"time",names(Data))
colnames(Data) <- gsub('^f',"frequency",names(Data))
# rename "Acc", "Gyro" and "Mag" by "Accelerometer", "Gyroscope" and "Magnitude"
colnames(Data) <- gsub('Acc',"Accelerometer",names(Data))
colnames(Data) <- gsub('Gyro',"Gyroscope",names(Data))
colnames(Data) <- gsub('Mag',"Magnitude",names(Data))

#Uncomment if you want to save the current "Data" data frame
#write.table(Data, "Data.txt",sep="\t",row.names=FALSE)
#write.csv(Data, "Data.csv",row.names=FALSE)

# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
# Data data frame is moved on a data table
dtData<- data.table(Data)
# we get the mean of all columns grouped by "subject" and "activity". The result is stored in another data.table, called meanData
meanData<- dtData[, lapply(.SD, mean), by=c("subject", "activity")]
# We order meanData data.table by increasing subjects
meanData<- meanData[order(meanData$subject),]

# Finally, we exporting meanData into a .txt file:
write.table(meanData, "AverageData.txt",sep="\t",row.names=FALSE)
# and a .csv file:
write.csv(meanData, "AverageData.csv",row.names=FALSE)
