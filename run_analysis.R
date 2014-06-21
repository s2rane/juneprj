run_analysis <- function(datadir)
{
        if(is.na(datadir)) stop("Please specify the input directory with data") 
        setwd(datadir)
        #load the features file
        features <- read.table("features.txt",col.names=c("id","name"))
               
        #load the activity file
        activity_lkp <- read.table("activity_labels.txt",col.names=c("activity_id", "activity_desc"))
        
        #load the test files
        subject_for_test <- read.table("subject_test.txt",col.names=c("subject_id"))
        
        #load the train files
        subject_for_train <- read.table("subject_train.txt",col.names=c("subject_id"))
        
        #Load Training activity data 
        train_activity <-read.table("y_train.txt",col.names=("activity_id"))
        
        train_activity <- merge(train_activity,activity_lkp)
        
        #Load Training activity measures 
        train_results <-read.table("X_train.txt")
        #assign feature name as column names
        names(train_results) <-features[,"name"]
        train_results <-train_results[grepl("mean\\(\\)|std\\(\\)",names(train_results),ignore.case=TRUE)]
        train_results <- cbind(subject_for_train,train_activity,train_results)
        
        #Load Test activity data 
        test_activity <-read.table("y_test.txt",col.names=("activity_id"))
        
        test_activity <- merge(test_activity,activity_lkp)
        
        #load Test activity measures
        test_results  <- read.table("X_test.txt")
        #assign feature name as column names
        names(test_results) <-features[,"name"]
        test_results <-test_results[grepl("mean\\(\\)|std\\(\\)",names(test_results),ignore.case=TRUE)]
        #below line gives the 1st set of dataset necessary for the project
        test_results <- cbind(subject_for_test,test_activity,test_results)
        mydata <- rbind(test_results,train_results)
        #below two steps tidy up the data.
        molten_data <- melt(mydata,id.var=c("subject_id","activity_desc"),measure.vars=c(4:69))
        tidy_data <- dcast(molten_data,subject_id+activity_desc ~ variable,mean)
}        