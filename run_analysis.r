setwd("D:/cloud storage/Google Drive/Coursera/cleaning data/assignment")

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "dataset.zip")

unzip("dataset.zip", list = TRUE) #first check the files in zip
unzip("dataset.zip", list = FALSE) #now unzip

#collect training data first
setwd("D:/cloud storage/Google Drive/Coursera/cleaning data/assignment/UCI HAR Dataset/train")
subject_train <- read.table("subject_train.txt")
head(subject_train) #this represents the person doing the activity

x_train <- read.table("X_train.txt")
head(x_train) #this is the dataset

y_train <- read.table("Y_train.txt")
head(y_train) #this is the activity number

#collect test data
setwd("D:/cloud storage/Google Drive/Coursera/cleaning data/assignment/UCI HAR Dataset/test")
subject_test <- read.table("subject_test.txt")
head(subject_test)

x_test <- read.table("X_test.txt")
head(x_test) #this is the dataset

y_test <- read.table("Y_test.txt")
head(y_test) #this is the activity number

#Part 1: now put them together, train data first
setwd("D:/cloud storage/Google Drive/Coursera/cleaning data/assignment/UCI HAR Dataset")

subject <- rbind(subject_train, subject_test)
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)

labels <- read.table("activity_labels.txt")

features <- read.table("features.txt")

#Part 2: Now extract the mean and stdev of each measurement
names(x) <- features[,2]

#Need to use \\ to search for the "(" symbol. There are 33 patterns, so 
#there should be 66 that we're looking for.
mean_std_features <- grep("Mean|mean\\(|Std|std\\(", features[,2])

mean_std_x <- x[,mean_std_features] #this dataset only contains mean and stdev

#Part 3: name activities in dataset

rename <- function(y){
  
  result <- labels[y,2]
  return(result)
}

y_named <- sapply(y, rename)

#Part 4: label the dataset

result2 <- as.character(features[mean_std_features,2])

result_edit <- gsub("tB|tG","TimeDomain", result2)
result_edit2 <- gsub("fB|fG","FrequencyDomain", result_edit)
result_edit3 <- gsub("Acc", "Accelerometer", result_edit2)
result_edit4 <- gsub("Gyro", "Gyroscope", result_edit3)
result_edit5 <- gsub("Mag", "Magnitude", result_edit4)
result_edit6 <- gsub("mean\\(\\)", "Mean", result_edit5)
result_edit7 <- gsub("std\\(\\)", "StandardDeviation", result_edit6)
result_edit8 <- gsub("-|\\)","",result_edit7)
result_edit9 <- gsub("angle\\(", "AngleBetween", result_edit8)
result_edit10 <- gsub(",","And",result_edit9)
result_edit11 <- gsub("gravity", "Gravity", result_edit10)

names(mean_std_x) <- result_edit11

final_data <- data.frame(y_named,y,subject,mean_std_x)

#Part 5: find the averages

average_data <- final_data[1:(max(subject)*max(y)),]
names(average_data)[1:3] <- c("Activity","ActivityID","Subject")

k = 1
for (i in 1:max(subject)){
  
  for (j in 1:max(y)){
    
    needed <- (final_data[,2] == j & final_data[,3] == i)
    average_data[k,1] <- labels[j,2]
    average_data[k,2] <- j
    average_data[k,3] <- i
    
    for (m in 4:ncol(final_data)){
      
      average_data[k,m] <- mean(final_data[needed, m])
      
    }
        
    k = k+1
  }
  
}
k = 1

setwd("D:/cloud storage/Google Drive/Coursera/cleaning data/assignment")
write.table(average_data, file = "average.txt", row.names = FALSE)
