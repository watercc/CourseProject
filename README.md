The original data is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The R script run_analysis.R is used to combine original datasets in different .txt files into one dataset and create a clean and tidy dataset by removing columns we don't need to handle, giving more meaningful values to some columns, giving better descriptive column names to some columns and calculating some summary statistics from the raw data. There are five steps inside the script:
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

The details of the script will be in CodeBook.md

The script run_analysis.R takes an assumption that the folder containing the original data is in the same directory as run_analysis.R, as you can see from all places where read.table() is called.



 