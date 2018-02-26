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

build_combined_data <- function(rootfolder) {
    require(dplyr)

    keepcolumnnames <- "[Mm]ean|[Ss]td"  # a regex used below to isolate mean and std deviation columns only
    
    features <- read.csv(file=paste0(rootfolder, .Platform$file.sep, "features.txt"), header = FALSE, sep="", colClasses = c("character") )
    
    # load training data
    f <- paste0(rootfolder, .Platform$file.sep, "train", .Platform$file.sep, "X_train.txt")
    rawtrain <- read.csv(file=f, header = FALSE, sep="", col.names = features[,2])
    subject <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "train", .Platform$file.sep, paste0("subject_train.txt")), header = FALSE, sep="" )
    activity <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "train", .Platform$file.sep, paste0("y_train.txt")), header = FALSE, sep="" )
    keepcolumns <- grep(keepcolumnnames, names(rawtrain), value = T)
    rawtrain <- rawtrain %>% 
        select(keepcolumns) %>% 
        mutate(subject = subject[,1], activity = activity[,1])
    print("Raw training data read")

    # load test data
    f <- paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "X_test.txt")
    rawtest <- read.csv(file=f, header = FALSE, sep="", col.names = features[,2])
    subject <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "subject_test.txt"), header = FALSE, sep="" )
    activity <- read.csv(file=paste0(rootfolder,.Platform$file.sep, "test", .Platform$file.sep, "y_test.txt"), header = FALSE, sep="" )
    keepcolumns <- grep(keepcolumnnames, names(rawtest), value = T)
    rawtest <- rawtest %>% 
        select(keepcolumns) %>% 
        mutate(subject = subject[,1], activity = activity[,1])
    print("Raw test data read")
    
    combined <- bind_rows(rawtrain, rawtest)
    print("Test and training data combined")
    
    # convert activity index to string label
    f <- paste0(rootfolder, .Platform$file.sep, "activity_labels.txt")
    activitylabels <- read.csv(f, header = FALSE, sep = "", stringsAsFactors = FALSE)
    combined$activity <- tolower(sapply(combined$activity, function(x) {activitylabels[x,2]}))

    # Improve the column names
    colnames(combined) <- tolower(gsub("\\.", "", colnames(combined)))
    
    combined
}

report_summary <- function(x) {
    require(dplyr)
    x %>% 
        group_by(activity, subject) %>% 
        summarize_all(mean)
}

# main script logic
datafolder <- getdata(download = TRUE)
print(paste("Working with raw data in folder:", datafolder))

combined_data <- build_combined_data(datafolder)

meansbyactivityandsubject <- report_summary(combined_data)
print("done")

