# CodeBook for Getting and Cleaning Data Peer Assesment

The original data can be downloaded from this link:
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .
The original description and files are in this other link:
  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The R script, here attached, that is called **"run_analysis.R"** performs the following steps in order to clean up and summarize the data:

## 1. Merges the training and test sets to create one data set, i.e

It merges the data values found in *".train/X_train.txt"* and *"./test/X_test.txt"*, having as a result a 10299 x 561 data frame (called *X* in my script), such as is defined in the original description (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where it is said to be a *"Number of Instances"* of 10299 and a *"Number of Attributes"* of 561;

it merges the subjects identifiers that appears in *"train/subject_train.txt and test/subject_test.txt"*, having as a result a data frame of 10299 rows and just one column with the subjects identifiers (called *S* in my script);

it merges the activity ID values (number values) that appears in *"train/y_train.txt and test/y_test.txt"*, having also a result of a 10299 x 1 data frame with activity ID values (called *Y* in my script).

Additionally, I extract the feature code and names that are in *"./features.txt"*, having a data frame of 561 rows and 2 column (called *Features* in my script). Besides, I extract the activity numbers and names from *"./activity_labels.txt"*, having a 6x2 data frame (called *Activities* in my script).

In the last part of this stage, I name all the columns of the different data frames, previously commented:

* For *Features*, I call "featureId" and "featureName" to the two columns
* For *Activities*, I call "activityId" and "activityName" to the wo columns
* For *S*, I call *subject* to its single column
* For *Y*, I call *activity* to its single column
* For *X*, I match each column name with the *featureName* values from *Features* data frame, having the *X[,i]* columnn name the *Features$featureName[i]*, for *i* in *{1:561}

Finally, data frames *X*, *S* and *Y* are joined in a single data frame (called ***Data*** in my script), giving a 10299x563 data frame.

    Note: I noticed that there exist some duplicated columns. Even though I could ignore them, since according the following steps such columns will be discarded, I would rather rename them. So, in my script, I make a function in order to change a column name and I pass to that function the different indices to be changed. There are three groups of duplicated names: 
	* group 1: columns 303:316, 317:330 and 331:344
	* group 2: columns 382:395, 396:409 and 410:423
	* group 3: columns 461:474, 475:488 and 489:502
    I interpreted that like triaxial values and I add the suffix 'X', 'Y' and 'Z' from the three different part of each group.


## 2.  Extracts only the measurements on the mean and standard deviation for each measurement.

By using regular expresions, the *Data* data frame is shrinked to a 10299 x 68 data frame (66 apart from *Data$subject* and *Data$activity* columns), since there only are 66 out of 561 attributes that are mean or standard deviation measurements.

## 3. Uses descriptive activity names to name the activities in the data set:

The idea here is to change the *Data$activity* column into activity names rather than activity values (values from 1:6). Since we have the matching between activity numbers and activity names in the *Activities* data frame, we exchange the activity numbers appearing in *Data$activity* into their activity names (walking, walkingUpstairs, walkingDownstairs, sitting, standing, laying). Previously, those activity names were changed to camel case format instead of upper case with '_'.

## 4. Appropriately labels the data set with descriptive activity names.
In this step I label the data set with camel case descriptive names, namely:

* For those features that have the string *"BodyBody"*, I convert that string into just ***"Body"***
* I remove the parenthesis ( *'('* and *')'* ) and *'-'* symbols from feature names.
* I make more descriptive names for the features, changing:
	* a. For those feature names that started with *'t'*, now starts by ***"time"*** 
	* b. For those feature names that started with *'f'*, now starts by ***"frequency"***
	* c. For those feature names that have de substring *"Acc"*, *"Gyro"* or *"Mag"*, they are changed to ***"Accelerometer"***, ***"Gyroscope"*** and ***"Magnitude"***.

Finally we have the following features:

    "timeBodyAccelerometerMean?"
    "timeBodyAccelerometerStd?" 
    "timeGravityAccelerometerMean?"
    "timeGravityAccelerometerStd?"
    "timeBodyAccelerometerJerkMean?"
    "timeBodyAccelerometerJerkStd?"
    "timeBodyGyroscopeMean?"
    "timeBodyGyroscopeStd?"
    "timeBodyGyroscopeJerkMean?"
    "timeBodyGyroscopeJerkStd?" 
    "timeBodyAccelerometerMagnitudeMean"
    "timeBodyAccelerometerMagnitudeStd"
    "timeGravityAccelerometerMagnitudeMean"
    "timeGravityAccelerometerMagnitudeStd"
    "timeBodyAccelerometerJerkMagnitudeMean"
    "timeBodyAccelerometerJerkMagnitudeStd"
    "timeBodyGyroscopeMagnitudeMean"
    "timeBodyGyroscopeMagnitudeStd"
    "timeBodyGyroscopeJerkMagnitudeMean"
    "timeBodyGyroscopeJerkMagnitudeStd"
    "frequencyBodyAccelerometerMean?"
    "frequencyBodyAccelerometerStd?"
    "frequencyBodyAccelerometerJerkMean?"
    "frequencyBodyAccelerometerJerkStd?"
    "frequencyBodyGyroscopeMean?"
    "frequencyBodyGyroscopeStd?"
    "frequencyBodyAccelerometerMagnitudeMean"
    "frequencyBodyAccelerometerMagnitudeStd"
    "frequencyBodyAccelerometerJerkMagnitudeMean"
    "frequencyBodyAccelerometerJerkMagnitudeStd"
    "frequencyBodyGyroscopeMagnitudeMean"
    "frequencyBodyGyroscopeMagnitudeStd"
    "frequencyBodyGyroscopeJerkMagnitudeMean"
    "frequencyBodyGyroscopeJerkMagnitudeStd"
    "subject"
    "activity" 

where each time where it appears the ***'?'*** symbol we actually have three features for ***'X'***, ***'Y'*** and ***'Z'***.

    Note: Currently, the data frame "Data" is not saved in the main memory. Anyway, if somebody wants to have it in disk, he/she only has to uncomment the two last lines of the 4th step. (Lines 101 and 102)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Finally, we create such tidy data set, being the result saved as *"./AverageData.txt"*" and *"./AverageData.csv"*. Such tidy data set is a 180x68 data frame where the first column contains the subject identifiers, the second one the activity names, and the other 66 the features that I exposed above. Since the averages are grouped by *Data$subject* and *Data$activity*, there are 180 rows (30 subjects * 6 different activities).


