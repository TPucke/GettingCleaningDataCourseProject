# GettingCleaningDataCourseProject.

## Invoking the process
It is intended that the entire process is run by sourcing the script file.  The script invokes a sequence of calls to the functions documented below.  

An optional parameter of the `getdata` function can be modified to skip the internet download of the data file in the case that it already exists after the script has been previously run. 

## Functions in order of execution
### getdata
`getdata(unzip_path = "./GettingCleaningData/CourseProject", download=TRUE)` ensures that the publicly available data files exist in a known local directory on the system.  In general the default unzip_path will work on all systems.  If the data has been previously downloaded this time consuming step can be skipped by passing the argument `download=FALSE`.  The function executes the following sequence of steps:
1. Establish a unique temporary file name for download of the zip file.  
2. Download the zip file from the internet to the temporary file name. 
3. Unzip the data folders/files into a specified (or default) path.  
4. Delete the temporary zip file. 

The path of the data files to be used in the rest of the script is returned and the global logic stores this path in variable `datafolder`. 

### build_combined_data
`build_combined_data(rootfolder)` creates a tidy data.frame that contains both training and test measurements combined, with activity and subject variables added, and with all columns removed that do not represent mean or standard deviation variables.  The function executes the following sequence of steps:
1. Define a regex expression that will be used to filter variable names, keeping only mean and std variables (as instructed).  
2. Load the features.txt file, which contains variable names for each column of the raw data files. These names are applied to both test and training data. 
3. For both training and test data perform the following steps:
  - Load the raw measurement data, applying the variable names to the columns. 
  - Load the subject and activity data files corresonding to the training measurements. 
  - Eliminate columns from raw measurments data with names that should not be retained and add subject and activity columns.  
4. Combine training and test data frames. 
5. Read the activity_labels file containing the mapping from numeric to string activity names. 
6. Convert numeric activity column to the string based activity name
7. Improve measurement column names by removing punctuation characters and converting to lower case. 

The resulting tidy data frame is returned and the global logic stores it in variable `combined_data`. 

### report_summary
`report_summary(x)` implements step 5 of the project requirements, creating a dataset that contains mean measurement values for all subjects and activities.  The function executes the following sequence of steps:
1. Applies dplyer functions to:
  - Group the combined data by activity and subject. 
  - Summarize all other variables using the calculation of mean. 

The resulting tidy data frame is returned and the global logic stores it in variable `meansbyactivityandsubject`.  The data frame is then stored to disk file in the root data folder printed at the start of script execution. 
