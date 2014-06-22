GetCleanData <- function(){
  #1.Merges the training and the test sets to create one data set.
  X_testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
  Y_testData <- read.table("./UCI HAR Dataset/test/Y_test.txt")
  Sub_testData <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  testData <- cbind(X_testData,Y_testData,Sub_testData)
  
  X_trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
  Y_trainData <- read.table("./UCI HAR Dataset/train/Y_train.txt")
  Sub_trainData <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  trainData <- cbind(X_trainData,Y_trainData,Sub_trainData)
  
  data <- rbind(trainData,testData)
   
  features <- read.table("./UCI HAR Dataset/features.txt",colClasses="character")
  names(data) <- c(features[,2],"Activity","Subject")
  
  #2.Extracts only the measurements on the mean and standard deviation for each measurement.
  filteredData <- data[,(grepl("mean()",names(data),fixed=T)|
                        grepl("std()",names(data),fixed=T)|
                        grepl("Activity",names(data),fixed=T)|
                        grepl("Subject",names(data),fixed=T))
                      ]
  
  #3.Uses descriptive activity names to name the activities in the data set
  labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
  filteredData$Activity <- labels[as.numeric(filteredData$Activity),2]
  
  #4.Appropriately labels the data set with descriptive variable names. 
  colNames <- names(filteredData)
  origTerms <- c("^t","^f","-X$","-Y$","-Z$","BodyBody","Body","Gravity","Acc","Gyro","JerkMag","Jerk","Mag",
                 "-mean()","-std()")
  replacingTerms <- c("time_","frequency_","_Xaxis","_Yaxis","_Zaxis","body_","body_","gravity_","acceleration_","gyroscopic_",
                     "jerkmagnitude_","jerk_","magnitude_","mean","stardardDeviation")
  for(i in 1:length(origTerms))
  {
    if(i <= 5)
      colNames <- gsub(origTerms[i],replacingTerms[i],colNames) 
    else
      colNames <- gsub(origTerms[i],replacingTerms[i],colNames,fixed=T) 
  }
  
  names(filteredData) <- colNames
  
  #5.Creates a second, independent tidy data set with the average of each variable 
  #  for each activity and each subject. 
  library(reshape2)
  newData <- melt(filteredData,id.vars=c("Activity","Subject"))
  res <- dcast(newData,Activity+Subject ~ variable,mean)
  
  return (res)
}