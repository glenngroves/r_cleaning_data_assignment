Run Analysis Script Explanation
-------------------------------

The **run\_analysis.R** script downloads the data files if required; and
then processes the data within both the test and train data sets, to
produce a summary table.

The original data set and descriptive files location was:
**<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" class="uri">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>**

The specific steps performed within **run\_analysis.R** are:

1.  Download the .zip file; uncomment this code to run it if required
2.  Read the features.txt file - we will use this later on to map from
    column number to meaningful column names
3.  Get the activity\_labels.txt file - we will use this later on to map
    from activity\_id to meaningful activity names
4.  Load the test subject, activity, and core variable data tables
5.  Merge the test subject, activity, and core variable data tables
    together, so we have the variables/observations, plus the test
    subject ID and the activity\_id that they relate to
6.  Load the train subject, activity, and core variable data tables
7.  Merge the train subject, activity, and core variable data tables
    together, so we have the variables/observations, plus the test
    subject ID and the activity\_id that they relate to
8.  Merge the test and the train combined data tables into one
9.  Subset only the mean columns, std columns, and the activity\_id and
    subject ID columns, using column numbers derived from the
    features.txt file
10. Replace the defaulted column names with meaningful ones, derived
    from the features.txt file, and modified to make them valid in R and
    easier to type
11. Add the activity name variable, merging using the activity\_id
    variable
12. Create the summary data set, with the average of all variables for
    each subject ID, activity\_id and activity name combination.
13. Output the run\_analysis\_summary.TXT file - the data summarised by
    subject ID, activity\_id, and activity name, with the mean (average)
    of each variable for each combination

PLEASE BE AWARE
---------------

1.  Both activity\_id and activity\_name are provided as variables in
    the summary data set output, even though they are simply different
    representations of the same original variable. Both have been
    included to provide as much flexibility as possible to those using
    the data. Because both are provided, anyone with knowledge of the
    data set the summary was created from is able to choose either
    activity\_id or activity\_name. Anyone without knowledge of the
    original data set will likely prefer to use the activity\_name
    variable.
2.  Subject names were not provided in the source data set, presumably
    for reasons of confidentiality. For that reason only subject\_id is
    provided in the summary data set output.
