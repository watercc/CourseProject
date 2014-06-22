
	X_testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
	Y_testData <- read.table("./UCI HAR Dataset/test/Y_test.txt")
	Sub_testData <- read.table("./UCI HAR Dataset/test/subject_test.txt")
	testData <- cbind(X_testData,Y_testData,Sub_testData)
Load all test data into X_testData, Y_testData and Sub_testData, and combine them by columns and store them in testData

	X_trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
	Y_trainData <- read.table("./UCI HAR Dataset/train/Y_train.txt")
	Sub_trainData <- read.table("./UCI HAR Dataset/train/subject_train.txt")
	trainData <- cbind(X_trainData,Y_trainData,Sub_trainData)
Load all test data into X_trainData, Y_trainData and Sub_trainData, and combine them by columns and store them in trainData

	data <- rbind(trainData,testData)
Combine training data and test data by rows and store them in "data"

	features <- read.table("./UCI HAR Dataset/features.txt",colClasses="character")
Get feature names from features.txt and append it with two names "Activity" and "Subject"

	names(data) <- c(features[,2],"Activity","Subject")
Set the feature names to the names of all columns of the combined dataset

	filteredData <- data[,(grepl("mean()",names(data),fixed=T)|
                        grepl("std()",names(data),fixed=T)|
                        grepl("Activity",names(data),fixed=T)|
                        grepl("Subject",names(data),fixed=T))
                      ]
Get the subset dataset containing only columns for mean, standard deviation, activity and subject

	labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
	filteredData$Activity <- labels[as.numeric(filteredData$Activity),2]
Get the label name each integer represents in the activity column, and replace the integer with the label name

	library(reshape2)
Load reshape2 package since we need to use function melt() and dcast() which are defined in reshape2 package

	colNames <- names(filteredData)
	origTerms <- c("^t","^f","-X$","-Y$","-Z$","BodyBody","Body","Gravity","Acc","Gyro","JerkMag","Jerk","Mag",
                 "-mean()","-std()")
	replacingTerms <- c("time_","frequency_","_Xaxis","_Yaxis","_Zaxis","body_","body_","gravity_","acceleration_","gyroscopic_",
                     "jerkmagnitude_","jerk_","magnitude_","mean","stardardDeviation")
Get the current column names of the dataset. "origTerms" contains the each part of the column names which we get from features.txt previously we want to replace with more descriptive names, which is in "replacingTerms". Replaced terms and its corresponding replacing terms are in the same index of origTerms and replacingTerms.		 
					 					 
	for(i in 1:length(origTerms))
	{
		if(i <= 5)
			colNames <- gsub(origTerms[i],replacingTerms[i],colNames) 
		else
			colNames <- gsub(origTerms[i],replacingTerms[i],colNames,fixed=T) 
	}
The first five terms use regular expression, so the value of the param "fixed" in gsub() is FALSE, which is the default value. The rest use literals, so the   value of the param "fixed" in gsub() is TRUE
	
	names(filteredData) <- colNames
Set the column names to be more descriptive names

	newData <- melt(filteredData,id.vars=c("Activity","Subject"))
Create a new data frame containing four columns. The first two columns have data for activity and subject. The third column named "variable" contains all column names of "filteredData" except "Activity" and "Subject", and the fourth column names "value" contains the value of the variable in the third column for the activity and subject in the first two columns.	
	
	res <- dcast(newData,Activity+Subject ~ variable,mean)
For each pair of activity and subject, calculate the average of each variable
  
	return (res)
Return the final clean and tidy data 

 