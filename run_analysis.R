library(dplyr)
n <- c()

getdata <- function(unzip_path = "./GettingCleaningData/CourseProject", download=TRUE) {
    if (download) {
        temp <- tempfile()
        dataurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(url = dataurl, destfile =  temp, mode = "wb")
        unzip(zipfile = temp, exdir = unzip_path)
        unlink(temp)
    }
    # return the root directory path of the data
    paste0(unzip_path, .Platform$file.sep, "UCI HAR Dataset")
}

build_raw_data <- function(rootfolder) {
    keepcolumnnames <- "[Mm]ean|[Ss]td"  # a regex used below to isolate mean and std deviation columns only
    
    features <- read.csv(file=paste0(rootfolder, .Platform$file.sep, "features.txt"), header = FALSE, sep="", colClasses = c("character") )
    
    # training data
    f <- paste0(rootfolder, .Platform$file.sep, "train", .Platform$file.sep, "X_train.txt")
    rawtrain <- read.csv(file=f, header = FALSE, sep="", col.names = features[,2])
    subject <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "train", .Platform$file.sep, paste0("subject_train.txt")), header = FALSE, sep="" )
    activity <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "train", .Platform$file.sep, paste0("y_train.txt")), header = FALSE, sep="" )
    keepcolumns <- grep(keepcolumnnames, names(rawtrain), value = T)
    rawtrain <- rawtrain %>% select(keepcolumns) %>% mutate(subject = subject[,1], activity = activity[,1])
    print("Raw training data read")

    # test data
    f <- paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "X_test.txt")
    rawtest <- read.csv(file=f, header = FALSE, sep="", col.names = features[,2])
    subject <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "subject_test.txt"), header = FALSE, sep="" )
    activity <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "y_test.txt"), header = FALSE, sep="" )
    keepcolumns <- grep(keepcolumnnames, names(rawtest), value = T)
    rawtest <- rawtest %>% select(keepcolumns) %>% mutate(subject = subject[,1], activity = activity[,1])
    print("Raw test data read")
    
    combined <- bind_rows(rawtrain, rawtest)
    print("Test and training data combined")
    
    # convert activity index to string label
    f <- paste0(rootfolder, .Platform$file.sep, "activity_labels.txt")
    activitylabels <- read.csv(f, header = FALSE, sep = "", stringsAsFactors = FALSE)
    combined$activity <- tolower(sapply(combined$activity, function(x) {activitylabels[x,2]}))

    arrange(combined, subject, activity)
    
    combined
}

report_summary <- function(x) {
    x %>% group_by(activity, subject) %>% summarize()
}

runall <- function(download=FALSE) {
    datafolder <<- getdata(download = download)
    print(datafolder)

    raw_data <- build_raw_data(datafolder)
    
    repsum <- report_summary(raw_data)
    print("done")
    print(repsum)
}

