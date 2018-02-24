# GettingCleaningDataCourseProject

## Invoking the program
It is intended that the entire process is run by calling runall(). 

`runall(download=TRUE)`

The optional parameter can be used to turn off the internet download of the data file in the case that it already exists.  

`runall` manages the sequence of other function calls that implement the details of the project logic. 

## Other functions in order of execution
### getdata
`getdata(unzip_path = "./GettingCleaningData/CourseProject", download=TRUE)` is first called to ensure that the publicly available data files exist locally on the system.  In general the default unzip_path will work on all systems.  If the data has been previously downloaded this time consuming step can be skipped by passing the argument `download=FALSE`.  

### build_raw_data
`build_raw_data(rootfolder)` reads raw files and creates a data.frame that contains combined measurements from both training and test data, with activity and subject variables added, and with all columns removed that do not represent mean or standard deviation variables. 

