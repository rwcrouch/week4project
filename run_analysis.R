setwd("C:/Users/rndyc/Documents/UCI HAR Dataset")
library(dplyr)

#reading data from text files


features<-read.table("features.txt")
actlab<-read.table("activity_labels.txt")
setwd("train")
train<-read.table("X_train.txt")
ytrain<-read.table("y_train.txt")
subtrain<-read.table("subject_train.txt")

setwd("..")
setwd("test")
test<-read.table("X_test.txt")
ytest<-read.table("y_test.txt")
subtest<-read.table("subject_test.txt")

#assigning variable names
names(train)<-features$V2
names(test)<-features$V2

#merging data on activity type and subject
train<-cbind(ytrain,train)
test<-cbind(ytest,test)
train<-cbind(subtrain,train)
test<-cbind(subtest,test)

#merging train and test data
both<-rbind(train,test)

names(both)[1]<-"subject"
names(both)[2]<-"activity"

#only keeping mean, std and activity variables
both1<-both[grepl("mean\\(|std|activity|subject",names(both))]

#tidying variable names
names(both1)<-tolower(names(both1))
names(both1)<-gsub("-","",names(both1))
names(both1)<-gsub("\\(","",names(both1))
names(both1)<-gsub("\\)","",names(both1))
names(both1)<-gsub("^t","time",names(both1))
names(both1)<-gsub("^f","freq",names(both1))

#changing the activity variable to have appropriate labels
both1<-mutate(both1,activity=factor(6*(activity),labels=actlab$V2))


#creating a new data set with the mean of each variable for each activity
byact<- group_by(both1, subject, activity) 
means<-summarize_each(byact, funs(mean(., na.rm=TRUE)))