# set working directory 
setwd('c:/users/dale/my documents/coursera/getting and cleaning data/')
# Load plyr package to be used later
require(plyr)
# Read in test sets of tables. Need data in subject and both x and y
test<-read.table("./UCI HAR dataset/test/subject_test.txt",sep=" ")
test1<-read.table("./UCI HAR dataset/test/y_test.txt",sep=" ")
test2<-read.table("./UCI HAR dataset/test/X_test.txt",header=FALSE,sep="")
# bind three tables of equal length together to make one data fram and remove the unneeded data
totaltest<-cbind(test,test1,test2)
rm(test,test1,test2)
# repeat for the train data
train<-read.table("./UCI HAR dataset/train/subject_train.txt",sep=" ")
train1<-read.table("./UCI HAR dataset/train/y_train.txt",sep=" ")
train2<-read.table("./UCI HAR dataset/train/X_train.txt",header=FALSE,sep="")
totaltrain<-cbind(train,train1,train2)
rm(train,train1,train2)
# combine the to sets together. Can use rbind since they contain the same variables in same order
totalset<-rbind(totaltest,totaltrain)
# Extract the means
means<-lapply(totalset[,3:563],mean)
# extract the stan devs
sds<-lapply(totalset[,3:563],sd)
# replace the integer codes with character names for activity
totalset[,2][totalset[,2]==1] <- "Walking"
totalset[,2][totalset[,2]==2] <- "Walking_upstairs"
totalset[,2][totalset[,2]==3] <- "Walking_downstairs"
totalset[,2][totalset[,2]==4] <- "Sitting"
totalset[,2][totalset[,2]==5] <- "Standing"
totalset[,2][totalset[,2]==6] <- "Laying"
# fetch the 561 variable names for the data captures
varnames<-read.table("./UCI HAR dataset/features.txt",header=FALSE,sep=" ")
# convert the data frame to a vector to use below
vartxtnames<-as.vector(varnames[[2]])
# change the names of the variables in the data frame
names(totalset)[1:2]<-c("subject_id","activity")
names(totalset)[3:563]<-vartxtnames[1:561]
# Create the final tidy data set using ddply to shape the data
finalset<-ddply(totalset, .(subject_id,activity), colwise(mean))
