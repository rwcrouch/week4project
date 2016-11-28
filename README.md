



#Description of process

This script takes the two data sets (test and train) with 561 variables, assigns names, merges them using row bind and then
adds a subject variable to the first column and an activity variable to the second column.  The activity variable is then converted to have the appropriate labels.  

Then, the data is parsed to have only variables for means and standard deviations.

The last step is to create a separate data set with the means of each of the 561 variables for each activity type.







setwd("C:/Users/rndyc/Documents/UCI HAR Dataset")
library(dplyr)

##reading data from text files


features<-read.table("features.txt")
actlab<-read.table("activity_labels.txt")
setwd("train")
train<-read.table("X_train.txt")
ytrain<-read.table("y_train.txt")
setwd("..")
setwd("test")
test<-read.table("X_test.txt")
ytest<-read.table("y_test.txt")

##assigning variable names
names(train)<-features$V2
names(test)<-features$V2

##merging data on activity type
train<-cbind(ytrain,train)
test<-cbind(ytest,test)

##merging train and test data
both<-rbind(train,test)


names(both)[1]<-"activity"

##only keeping mean, std and activity variables
both1<-both[grepl("mean\\(|std|activity",names(both))]

##tidying variable names
names(both1)<-tolower(names(both1))
names(both1)<-gsub("-","",names(both1))
names(both1)<-gsub("\\(","",names(both1))
names(both1)<-gsub("\\)","",names(both1))
names(both1)<-gsub("^t","time",names(both1))
names(both1)<-gsub("^f","freq",names(both1))

##changing the activity variable to have appropriate labels
both1<-mutate(both1,activity=factor(6*(activity),labels=actlab$V2))


##creating a new data set with the mean of each variable for each activity
byact<- group_by(both1, activity) 
means<-summarize_each(byact, funs(mean(., na.rm=TRUE)))