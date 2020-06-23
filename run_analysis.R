# You should create one R script called run_analysis.R that does the following. 
#1 Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names. 
#5 From the data set in step 4, creates a second, independent tidy data set with the average 
#  of each variable for each activity and each subject.

library(dplyr)

#1 Merges the training and the test sets to create one data set.

base_dir <- "UCI HAR Dataset\\"


#body_acc_x_text <-read.table(paste0(base_dir,'test\\Inertial Signals\\body_acc_x_test.txt'))
print('Reading in data')
X_test <-read.table(paste0(base_dir,'test\\X_test.txt'))  #2947 x 561  test set
Y_test <-read.table(paste0(base_dir,'test\\Y_test.txt'))  #2947 x 1  test labels
subject_test <-read.table(paste0(base_dir,'test\\subject_test.txt'))  #2947 x 1  train labels
X_train <-read.table(paste0(base_dir,'train\\X_train.txt'))  #7352 x 561  train set
Y_train <-read.table(paste0(base_dir,'train\\Y_train.txt'))  #7352 x 1  train labels
subject_train <-read.table(paste0(base_dir,'train\\subject_train.txt'))  #7352 x 1  train labels

#X test and train contain 561 columns.  features.txt contains the names of those columns
features <-read.table(paste0(base_dir,'\\features.txt'))
#fix features which seems to have repeats
XYZ <- c('-X','-Y','-Z')
features[,"V2"] <- as.character(features[,"V2"])
print('Fixing duplications in features labels for XYZ')

for (feat in features[,"V2"]) {
        temp <- which(features[,"V2"] == feat)
        if (length(temp) > 1){
                cnt <-1
                for(t in temp){
                        features[t,"V2"] <- paste0(feat,XYZ[cnt])
                        cnt<-cnt+1
                }
        }
}

# features["V2"] <- gsub('-',"",features[["V2"]])
# features["V2"] <- gsub("\\()","",features[["V2"]])
# features["V2"] <- gsub(",","_",features[["V2"]])


print('Appending subject, activity and set type to Datasets')
X_test <- mutate(X_test,subject = subject_test[,"V1"])
X_test <- mutate(X_test, set_type = 'test')
X_test <- mutate(X_test, Activity_number = Y_test[,"V1"])

X_train <- mutate(X_train,subject = subject_train[,"V1"])
X_train <- mutate(X_train, set_type = 'type')
X_train <- mutate(X_train, Activity_number = Y_train[,"V1"])



# colnames(X_test) <- c(features[,'V2'],'subject','set_type','Activity_number')  # names like fBodyGyro-bandsEnergy()-1,8 are repeated 3x  (X,Y,Z ?)
# colnames(X_train) <- features[,'V2']

#different number of rows indicates merged set should be 7352+2947 long with another column to indicate test/train set
#set_type.  Also merge in subject data set.

print('Creating the full dataset, and applying feature labels')
Full_Set <- rbind(X_train,X_test)  #10299 x 564

print('#4 Appropriately labels the data set with descriptive variable names.')
colnames(Full_Set) <- c(as.character(features[,"V2"]),'subject','set_type','Activity_number')  # names like fBodyGyro-bandsEnergy()-1,8 are repeated 3x  (X,Y,Z ?)

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
#This statement doesn't make sense
#will extract all columns with mean or std in names(Full_Set)
print('pairing down to just mean and std columns, and set_type, subject, Activity_number')
cols <-names(Full_Set)

keep_cols_variables <- cols[c(grep('mean\\()',cols),grep('std\\()',cols))]
keep_cols <- c('set_type','subject','Activity_number',keep_cols_variables)
Full_Set <- Full_Set[,keep_cols]


#3 Uses descriptive activity names to name the activities in the data set
print('Use descriptive activity names to name the activities in the data set')
activity_labels <-read.table(paste0(base_dir,'\\activity_labels.txt'))
colnames(activity_labels) <- c('number','label')
Full_Set <- mutate(Full_Set,Activity_Label = '')

for (r in seq(dim(activity_labels)[1])){
        ind10 <- Full_Set[,'Activity_number'] == activity_labels[r,'number']
        Full_Set[ind10,'Activity_Label'] = as.character(activity_labels[r,'label'])
}
ind <- c(length(names(Full_Set)),seq(2,length(names(Full_Set))))
Full_Set <- Full_Set[,ind]


#4 Appropriately labels the data set with descriptive variable names.
#I think I did that in step 1) with "features"


#5 From the data set in step 4, creates a second, independent tidy data set with the average
print('#5 From the data set in step 4, creates a second, independent tidy data set with the average ')
#  of each variable for each activity and each subject.
#Tidy_Average <- data.frame('Subject' = numeric(),'Activity' = character(),'Metric' = character(),'Average' = numeric(),stringsAsFactors=FALSE)
Tidy_Average <- Full_Set[0,]
Tidy_Average <- subset(Tidy_Average, select = -c(Activity_number))

        cnt <-0
        for (subject in unique(Full_Set$subject)){
                
                Temp_Set_o <- Full_Set[Full_Set$subject == subject,]
                
                
                for (activity in unique(Temp_Set_o$Activity_Label)){
                        Temp_Set <- Temp_Set_o[Temp_Set_o$Activity_Label == activity,]
                        
                        if (dim(Temp_Set)[1] > 0){
                                
                                        
                                cnt <- cnt+1
                                # for (variable in keep_cols_variables){
                                #         #Tidy_Average['Subj']
                                for (variable in keep_cols_variables){
                                         Tidy_Average[cnt,"subject"] <- subject
                                         Tidy_Average[cnt,"Activity_Label"] <-activity
                                         Tidy_Average[cnt,variable] <- mean(Temp_Set[,variable])#variable
                                #         Tidy_Average[cnt,"Average"] <- mean(Temp_Set[,variable])
                                # 
                                # 
                                        }
                        }
                }
}

write.table(Tidy_Average,"Tidy_Average.txt",row.name = FALSE)

