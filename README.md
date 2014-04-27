Getting and Cleaning peer assesment
===================================

R Script run_analysis.R
-----------------------

* Firstly, download and unzip the source
  ( *https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip* )

  into a folder on your local drive, say C:\Users\yourname\Documents\R\

* Secondly, put the script ***run_analysis.R*** into  *YOUR_LOCAL_PATH/UCI HAR Dataset/*, being **YOUR_LOCAL_PATH** the folder where you decide to allocate the folder resulting from the unzipped file

* Thirdly, in RStudio type: 

    setwd("YOUR_LOCAL_PATH/UCI HAR Dataset")
    source("run_analysis.R")

By means of that, the R script will be run. Such script reads different files from the *UCI HAR Dataset* folder and it generates the files:

    AverageData.txt: 224.8 kB .txt file
    AverageData.csv: 224.8 kB .csv file

Both files are a 180x68 data frame: the .txt is separated by tabs, and the .csv, a normal comma separated values file.
The R script it takes ~23 seconds on my computer, but the exact time will depend on your system.

CodeBook
--------

A file called ***CodeBook.md*** is also provided. In such files all the steps that were taken into account in the analysis are explained. Those steps start from separated train and test files and finish with a unique merged file and an average data frame for subjects and activities.

