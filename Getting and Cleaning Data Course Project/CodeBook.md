## R Markdown

### This is de CodeBook for the final project: Peer-graded Assignment: Getting and Cleaning Data Course Project

### Johns Hopkins Data Science Specialization via Coursera

One of the most exciting areas in all of data science right now is
wearable computing. Companies like Fitbit, Nike, and Jawbone Up are
racing to develop the most advanced algorithms to attract new users. The
data linked to from the course website represent data collected from the
accelerometers from the Samsung Galaxy S smartphone. A full description
is available at the site where the data was obtained:

[archive.ics.uci.edu](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

**Here are the data for the project:**

[cloudfront.net](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

You should create one R script called run\_analysis.R that does the
following.

Merges the training and the test sets to create one data set.

Extracts only the measurements on the mean and standard deviation for
each measurement.

Uses descriptive activity names to name the activities in the data set

Appropriately labels the data set with descriptive variable names.

From the data set in step 4, creates a second, independent tidy data set
with the average of each variable for each activity and each subject.

# My project:

the explanation of the variables can be found at
[codebook.docx](https://github.com/JulianPosadaDenHaag/Johns_Hopkins_Coursera_Data_Science/blob/7ef7711c0324055b5f5cc74f574139d42736d12d/Getting%20and%20Cleaning%20Data%20Course%20Project/codebook.docx)

or at the end of this document with a skimr summary

First I will load the packages I need to perform the getting and
cleaning process

    library(here)
    library(tidyverse)
    library(readr)
    library(skimr)
    library(data.table)
    library(stringr)

Using the library here, I am setting up the correct path

    path<-     here::here( "Getting and Cleaning Data course Project","UCI HAR Dataset")

The next code takes the features names from “features.txt”

    features<-data.table::fread(here::here(path,"features.txt"))%>% 
      set_names(c("index", "names")) 
    str(features)

    ## Classes 'data.table' and 'data.frame':   561 obs. of  2 variables:
    ##  $ index: int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ names: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

this select only the “names” in “features.txt” that contains mean or std

    mean_std<- features %>% filter( grepl("mean|std",features$names))
    str(mean_std)

    ## Classes 'data.table' and 'data.frame':   79 obs. of  2 variables:
    ##  $ index: int  1 2 3 4 5 6 41 42 43 44 ...
    ##  $ names: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

Loading the x\_train.txt (training data set) into a data.table, and
setting the names of all columns to be the right names (in features).
Then only selecting the names that contains mean or std

    x_train<- data.table::fread(here::here(path, "train", "x_train.txt"))%>%
      setNames(features$names) %>% select(mean_std$names)
    head(as.tibble(x_train))

    ## Warning: `as.tibble()` was deprecated in tibble 2.0.0.
    ## ℹ Please use `as_tibble()` instead.
    ## ℹ The signature and semantics have changed, see `?as_tibble`.

    ## # A tibble: 6 × 79
    ##   tBodyAcc-mea…¹ tBody…² tBody…³ tBody…⁴ tBody…⁵ tBody…⁶ tGrav…⁷ tGrav…⁸ tGrav…⁹
    ##            <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ## 1          0.289 -0.0203  -0.133  -0.995  -0.983  -0.914   0.963  -0.141  0.115 
    ## 2          0.278 -0.0164  -0.124  -0.998  -0.975  -0.960   0.967  -0.142  0.109 
    ## 3          0.280 -0.0195  -0.113  -0.995  -0.967  -0.979   0.967  -0.142  0.102 
    ## 4          0.279 -0.0262  -0.123  -0.996  -0.983  -0.991   0.968  -0.144  0.0999
    ## 5          0.277 -0.0166  -0.115  -0.998  -0.981  -0.990   0.968  -0.149  0.0945
    ## 6          0.277 -0.0101  -0.105  -0.997  -0.990  -0.995   0.968  -0.148  0.0919
    ## # … with 70 more variables: `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>,
    ## #   `tBodyGyro-mean()-Z` <dbl>, `tBodyGyro-std()-X` <dbl>, …

A data.table is created with the values to be transformed into
activity\_labels

    y_train<-  data.table::fread(here::here(path, "train","y_train.txt")) %>% 
            set_names("labels")
    str(y_train)

    ## Classes 'data.table' and 'data.frame':   7352 obs. of  1 variable:
    ##  $ labels: int  5 5 5 5 5 5 5 5 5 5 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

A data.table is created that contains all te subjects (as character). An
index is created.

    subject_train<-  data.table::fread(here::here(path, "train","subject_train.txt"),
                                       colClasses = "character") %>%
            set_names("subject")%>% 
            mutate("index" =row_number())
    str(subject_train)

    ## Classes 'data.table' and 'data.frame':   7352 obs. of  2 variables:
    ##  $ subject: chr  "1" "1" "1" "1" ...
    ##  $ index  : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  - attr(*, ".internal.selfref")=<externalptr>

The data from y\_train, subject\_train and activity labels is then
merged.

    activity_labelsX<-data.table::fread(here::here(path,"activity_labels.txt"))%>% 
             set_names(c("labels", "activity_labels")) %>% 
            merge(y_train, by = "labels") %>% mutate("index" =row_number()) %>% 
            merge(subject_train, by = "index") %>% select(!index & !labels)
    str(activity_labelsX)

    ## Classes 'data.table' and 'data.frame':   7352 obs. of  2 variables:
    ##  $ activity_labels: chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
    ##  $ subject        : chr  "1" "1" "1" "1" ...
    ##  - attr(*, ".internal.selfref")=<externalptr> 
    ##  - attr(*, "sorted")= chr "index"

All the columns are merged to created the tidy x\_train dataset.

    x_train<-bind_cols(activity_labelsX,x_train)
    head(as.tibble(x_train))

    ## # A tibble: 6 × 81
    ##   activity_lab…¹ subject tBody…² tBody…³ tBody…⁴ tBody…⁵ tBody…⁶ tBody…⁷ tGrav…⁸
    ##   <chr>          <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ## 1 WALKING        1         0.289 -0.0203  -0.133  -0.995  -0.983  -0.914   0.963
    ## 2 WALKING        1         0.278 -0.0164  -0.124  -0.998  -0.975  -0.960   0.967
    ## 3 WALKING        1         0.280 -0.0195  -0.113  -0.995  -0.967  -0.979   0.967
    ## 4 WALKING        1         0.279 -0.0262  -0.123  -0.996  -0.983  -0.991   0.968
    ## 5 WALKING        1         0.277 -0.0166  -0.115  -0.998  -0.981  -0.990   0.968
    ## 6 WALKING        1         0.277 -0.0101  -0.105  -0.997  -0.990  -0.995   0.968
    ## # … with 72 more variables: `tGravityAcc-mean()-Y` <dbl>,
    ## #   `tGravityAcc-mean()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>, …

The same process is repeated for the test dataset

    x_test<- data.table::fread(here::here(path, "test", "X_test.txt"))%>%
            setNames(features$names)%>% select(mean_std$names)

    y_test<-  data.table::fread(here::here(path, "test", "y_test.txt")) %>% 
            set_names("labels")

    subject_train_y<-  data.table::fread(here::here(path, "test","subject_test.txt"),colClasses = "character") %>%
            set_names("subject")%>% 
            mutate("index" =row_number())

    activity_labelsY<-data.table::fread(here::here(path, "activity_labels.txt"))%>% 
            set_names(c("labels", "activity_labels")) %>% 
            merge(y_test, by = "labels") %>% mutate("index" =row_number()) %>% 
            merge(subject_train_y, by = "index")%>% select(!index & !labels)

    x_test<-bind_cols(activity_labelsY,x_test) 
    head(as.tibble(x_test))

    ## # A tibble: 6 × 81
    ##   activity_lab…¹ subject tBody…² tBody…³ tBody…⁴ tBody…⁵ tBody…⁶ tBody…⁷ tGrav…⁸
    ##   <chr>          <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ## 1 WALKING        2         0.257 -0.0233 -0.0147  -0.938  -0.920  -0.668   0.936
    ## 2 WALKING        2         0.286 -0.0132 -0.119   -0.975  -0.967  -0.945   0.927
    ## 3 WALKING        2         0.275 -0.0261 -0.118   -0.994  -0.970  -0.963   0.930
    ## 4 WALKING        2         0.270 -0.0326 -0.118   -0.995  -0.973  -0.967   0.929
    ## 5 WALKING        2         0.275 -0.0278 -0.130   -0.994  -0.967  -0.978   0.927
    ## 6 WALKING        2         0.279 -0.0186 -0.114   -0.994  -0.970  -0.965   0.926
    ## # … with 72 more variables: `tGravityAcc-mean()-Y` <dbl>,
    ## #   `tGravityAcc-mean()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>, …

Binding all the rows to create a tidy\_dataset. The subject is set to
the first column

    tidy_data<- bind_rows(x_train,x_test) %>% 
            relocate(subject)
    head(as.tibble(tidy_data))

    ## # A tibble: 6 × 81
    ##   subject activity_lab…¹ tBody…² tBody…³ tBody…⁴ tBody…⁵ tBody…⁶ tBody…⁷ tGrav…⁸
    ##   <chr>   <chr>            <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ## 1 1       WALKING          0.289 -0.0203  -0.133  -0.995  -0.983  -0.914   0.963
    ## 2 1       WALKING          0.278 -0.0164  -0.124  -0.998  -0.975  -0.960   0.967
    ## 3 1       WALKING          0.280 -0.0195  -0.113  -0.995  -0.967  -0.979   0.967
    ## 4 1       WALKING          0.279 -0.0262  -0.123  -0.996  -0.983  -0.991   0.968
    ## 5 1       WALKING          0.277 -0.0166  -0.115  -0.998  -0.981  -0.990   0.968
    ## 6 1       WALKING          0.277 -0.0101  -0.105  -0.997  -0.990  -0.995   0.968
    ## # … with 72 more variables: `tGravityAcc-mean()-Y` <dbl>,
    ## #   `tGravityAcc-mean()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>, …

The tidy data is then grouped and summarized by average

    tidy_data_average<- tidy_data %>% 
      group_by( subject, activity_labels) %>% 
      summarise(across(everything(), mean), .groups = "drop") %>% 
      arrange(activity_labels) 
    tidy_data_average

    ## # A tibble: 40 × 81
    ##    subject activity_la…¹ tBody…² tBody…³ tBody…⁴ tBody…⁵ tBody…⁶ tBody…⁷ tGrav…⁸
    ##    <chr>   <chr>           <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1 20      LAYING          0.268 -0.0154  -0.103  -0.547  -0.259  -0.640   0.591
    ##  2 24      LAYING          0.277 -0.0177  -0.108  -0.675  -0.582  -0.636   0.695
    ##  3 27      LAYING          0.278 -0.0169  -0.112  -0.575  -0.541  -0.608   0.585
    ##  4 28      LAYING          0.278 -0.0192  -0.110  -0.649  -0.574  -0.686   0.624
    ##  5 29      LAYING          0.279 -0.0185  -0.109  -0.574  -0.598  -0.606   0.683
    ##  6 30      LAYING          0.276 -0.0176  -0.106  -0.616  -0.519  -0.523   0.697
    ##  7 12      SITTING         0.276 -0.0185  -0.108  -0.509  -0.401  -0.722   0.630
    ##  8 13      SITTING         0.276 -0.0177  -0.109  -0.625  -0.449  -0.587   0.710
    ##  9 17      SITTING         0.273 -0.0181  -0.109  -0.551  -0.507  -0.613   0.669
    ## 10 18      SITTING         0.278 -0.0173  -0.110  -0.992  -0.939  -0.951   0.963
    ## # … with 30 more rows, 72 more variables: `tGravityAcc-mean()-Y` <dbl>,
    ## #   `tGravityAcc-mean()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>, …

    skim(tidy_data_average)

<table>
<caption>Data summary</caption>
<tbody>
<tr class="odd">
<td style="text-align: left;">Name</td>
<td style="text-align: left;">tidy_data_average</td>
</tr>
<tr class="even">
<td style="text-align: left;">Number of rows</td>
<td style="text-align: left;">40</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Number of columns</td>
<td style="text-align: left;">81</td>
</tr>
<tr class="even">
<td style="text-align: left;">_______________________</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">Column type frequency:</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">character</td>
<td style="text-align: left;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">numeric</td>
<td style="text-align: left;">79</td>
</tr>
<tr class="even">
<td style="text-align: left;">________________________</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">Group variables</td>
<td style="text-align: left;">None</td>
</tr>
</tbody>
</table>

Data summary

**Variable type: character**

<table>
<colgroup>
<col style="width: 21%" />
<col style="width: 13%" />
<col style="width: 18%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 8%" />
<col style="width: 12%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">skim_variable</th>
<th style="text-align: right;">n_missing</th>
<th style="text-align: right;">complete_rate</th>
<th style="text-align: right;">min</th>
<th style="text-align: right;">max</th>
<th style="text-align: right;">empty</th>
<th style="text-align: right;">n_unique</th>
<th style="text-align: right;">whitespace</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">subject</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">30</td>
<td style="text-align: right;">0</td>
</tr>
<tr class="even">
<td style="text-align: left;">activity_labels</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">18</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">0</td>
</tr>
</tbody>
</table>

**Variable type: numeric**

<table style="width:100%;">
<colgroup>
<col style="width: 31%" />
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 5%" />
<col style="width: 4%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">skim_variable</th>
<th style="text-align: right;">n_missing</th>
<th style="text-align: right;">complete_rate</th>
<th style="text-align: right;">mean</th>
<th style="text-align: right;">sd</th>
<th style="text-align: right;">p0</th>
<th style="text-align: right;">p25</th>
<th style="text-align: right;">p50</th>
<th style="text-align: right;">p75</th>
<th style="text-align: right;">p100</th>
<th style="text-align: left;">hist</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">tBodyAcc-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: left;">▂▅▃▇▇</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAcc-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">-0.01</td>
<td style="text-align: left;">▂▇▇▃▂</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAcc-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">-0.12</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: left;">▁▂▇▃▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAcc-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.63</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">-0.13</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAcc-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.53</td>
<td style="text-align: right;">0.21</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.59</td>
<td style="text-align: right;">-0.53</td>
<td style="text-align: right;">-0.42</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAcc-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">-0.58</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: left;">▂▇▆▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tGravityAcc-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.68</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.48</td>
<td style="text-align: right;">0.65</td>
<td style="text-align: right;">0.67</td>
<td style="text-align: right;">0.70</td>
<td style="text-align: right;">0.96</td>
<td style="text-align: left;">▁▆▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tGravityAcc-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.10</td>
<td style="text-align: right;">-0.18</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">0.07</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: left;">▃▆▇▃▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tGravityAcc-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">0.11</td>
<td style="text-align: right;">-0.28</td>
<td style="text-align: right;">0.04</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: right;">0.24</td>
<td style="text-align: left;">▁▁▂▇▅</td>
</tr>
<tr class="even">
<td style="text-align: left;">tGravityAcc-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">-1.00</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.96</td>
<td style="text-align: right;">-0.93</td>
<td style="text-align: left;">▂▅▇▃▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tGravityAcc-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.96</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.96</td>
<td style="text-align: right;">-0.96</td>
<td style="text-align: right;">-0.95</td>
<td style="text-align: right;">-0.90</td>
<td style="text-align: left;">▂▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tGravityAcc-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.94</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.95</td>
<td style="text-align: right;">-0.94</td>
<td style="text-align: right;">-0.93</td>
<td style="text-align: right;">-0.88</td>
<td style="text-align: left;">▅▇▅▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAccJerk-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.06</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: left;">▁▁▂▇▅</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAccJerk-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: left;">▃▇▇▃▂</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAccJerk-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">-0.01</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: left;">▁▅▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAccJerk-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.70</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.58</td>
<td style="text-align: right;">-0.17</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAccJerk-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">0.19</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.50</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAccJerk-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.78</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.83</td>
<td style="text-align: right;">-0.78</td>
<td style="text-align: right;">-0.73</td>
<td style="text-align: right;">-0.39</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyro-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.03</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">-0.07</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">-0.03</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: left;">▅▁▇▆▂</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyro-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: right;">-0.07</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: left;">▂▇▇▂▂</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyro-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.05</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">0.10</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: left;">▁▂▇▇▂</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyro-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.73</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">-0.35</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyro-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.70</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.73</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.22</td>
<td style="text-align: left;">▂▇▃▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyro-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.60</td>
<td style="text-align: right;">-0.17</td>
<td style="text-align: left;">▂▇▆▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyroJerk-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">-0.09</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: left;">▅▇▃▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyroJerk-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">-0.05</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: left;">▂▂▆▇▆</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyroJerk-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.05</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: right;">-0.05</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: left;">▃▇▇▃▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyroJerk-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.78</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.03</td>
<td style="text-align: left;">▂▇▁▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyroJerk-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.87</td>
<td style="text-align: right;">-0.81</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.30</td>
<td style="text-align: left;">▅▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyroJerk-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">-0.76</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.05</td>
<td style="text-align: left;">▃▇▁▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAccMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.57</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.54</td>
<td style="text-align: right;">-0.50</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: left;">▂▂▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAccMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.60</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tGravityAccMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.57</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.54</td>
<td style="text-align: right;">-0.50</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: left;">▂▂▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tGravityAccMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.60</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyAccJerkMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.58</td>
<td style="text-align: right;">-0.15</td>
<td style="text-align: left;">▂▇▇▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyAccJerkMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.63</td>
<td style="text-align: right;">-0.56</td>
<td style="text-align: right;">-0.09</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyroMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.63</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">-0.18</td>
<td style="text-align: left;">▂▃▇▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyroMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">-0.20</td>
<td style="text-align: left;">▂▇▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tBodyGyroJerkMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.83</td>
<td style="text-align: right;">-0.78</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.20</td>
<td style="text-align: left;">▃▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">tBodyGyroJerkMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.79</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.86</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.24</td>
<td style="text-align: left;">▃▇▂▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAcc-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.58</td>
<td style="text-align: right;">-0.13</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAcc-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.56</td>
<td style="text-align: right;">0.20</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">-0.56</td>
<td style="text-align: right;">-0.44</td>
<td style="text-align: right;">0.10</td>
<td style="text-align: left;">▂▇▆▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAcc-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.63</td>
<td style="text-align: right;">-0.27</td>
<td style="text-align: left;">▂▇▇▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAcc-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">-0.13</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAcc-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.55</td>
<td style="text-align: right;">0.20</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">-0.54</td>
<td style="text-align: right;">-0.46</td>
<td style="text-align: right;">0.06</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAcc-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">-0.59</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAcc-meanFreq()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.20</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">-0.35</td>
<td style="text-align: right;">-0.24</td>
<td style="text-align: right;">-0.22</td>
<td style="text-align: right;">-0.18</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: left;">▂▇▃▁▂</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAcc-meanFreq()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">0.07</td>
<td style="text-align: right;">-0.16</td>
<td style="text-align: right;">-0.03</td>
<td style="text-align: right;">0.04</td>
<td style="text-align: right;">0.07</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: left;">▂▂▃▇▅</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAcc-meanFreq()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.06</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">-0.14</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.05</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">0.28</td>
<td style="text-align: left;">▂▆▇▃▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccJerk-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.60</td>
<td style="text-align: right;">-0.21</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAccJerk-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.70</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.54</td>
<td style="text-align: right;">-0.09</td>
<td style="text-align: left;">▂▇▆▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccJerk-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.76</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.81</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.35</td>
<td style="text-align: left;">▂▇▆▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAccJerk-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">-0.59</td>
<td style="text-align: right;">-0.21</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccJerk-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">0.19</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.50</td>
<td style="text-align: right;">0.04</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAccJerk-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">0.11</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.85</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.42</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccJerk-meanFreq()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.03</td>
<td style="text-align: right;">0.11</td>
<td style="text-align: right;">-0.27</td>
<td style="text-align: right;">-0.09</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.02</td>
<td style="text-align: right;">0.26</td>
<td style="text-align: left;">▁▅▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAccJerk-meanFreq()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.20</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">-0.40</td>
<td style="text-align: right;">-0.25</td>
<td style="text-align: right;">-0.20</td>
<td style="text-align: right;">-0.16</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccJerk-meanFreq()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">-0.30</td>
<td style="text-align: right;">-0.17</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.07</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: left;">▂▅▇▃▂</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyGyro-mean()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.63</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: left;">▂▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyGyro-mean()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">0.16</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">-0.75</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.25</td>
<td style="text-align: left;">▃▇▃▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyGyro-mean()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.60</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyGyro-std()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.75</td>
<td style="text-align: right;">0.11</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.79</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.45</td>
<td style="text-align: left;">▂▃▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyGyro-std()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.70</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.73</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">-0.15</td>
<td style="text-align: left;">▂▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyGyro-std()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.75</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.23</td>
<td style="text-align: left;">▂▇▅▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyGyro-meanFreq()-X</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">-0.31</td>
<td style="text-align: right;">-0.14</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: left;">▂▅▇▅▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyGyro-meanFreq()-Y</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.17</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: right;">-0.40</td>
<td style="text-align: right;">-0.24</td>
<td style="text-align: right;">-0.16</td>
<td style="text-align: right;">-0.10</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: left;">▃▃▆▇▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyGyro-meanFreq()-Z</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.10</td>
<td style="text-align: right;">-0.27</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.00</td>
<td style="text-align: right;">0.27</td>
<td style="text-align: left;">▂▅▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.61</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.59</td>
<td style="text-align: right;">-0.52</td>
<td style="text-align: right;">-0.06</td>
<td style="text-align: left;">▂▅▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyAccMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: right;">-0.97</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.67</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.27</td>
<td style="text-align: left;">▂▂▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyAccMag-meanFreq()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">-0.07</td>
<td style="text-align: right;">0.04</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">0.14</td>
<td style="text-align: right;">0.26</td>
<td style="text-align: left;">▃▃▇▅▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyBodyAccJerkMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.68</td>
<td style="text-align: right;">-0.62</td>
<td style="text-align: right;">-0.54</td>
<td style="text-align: right;">-0.08</td>
<td style="text-align: left;">▂▆▇▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyBodyAccJerkMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">0.17</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.69</td>
<td style="text-align: right;">-0.64</td>
<td style="text-align: right;">-0.58</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: left;">▂▇▇▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyBodyAccJerkMag-meanFreq()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">0.09</td>
<td style="text-align: right;">-0.02</td>
<td style="text-align: right;">0.12</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">0.22</td>
<td style="text-align: right;">0.40</td>
<td style="text-align: left;">▁▅▇▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyBodyGyroMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">0.15</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.73</td>
<td style="text-align: right;">-0.65</td>
<td style="text-align: right;">-0.16</td>
<td style="text-align: left;">▂▇▃▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyBodyGyroMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.98</td>
<td style="text-align: right;">-0.77</td>
<td style="text-align: right;">-0.71</td>
<td style="text-align: right;">-0.66</td>
<td style="text-align: right;">-0.38</td>
<td style="text-align: left;">▂▅▇▂▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyBodyGyroMag-meanFreq()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.05</td>
<td style="text-align: right;">0.11</td>
<td style="text-align: right;">-0.31</td>
<td style="text-align: right;">-0.11</td>
<td style="text-align: right;">-0.04</td>
<td style="text-align: right;">0.01</td>
<td style="text-align: right;">0.29</td>
<td style="text-align: left;">▁▆▇▂▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyBodyGyroJerkMag-mean()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.79</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.86</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">-0.72</td>
<td style="text-align: right;">-0.25</td>
<td style="text-align: left;">▃▇▂▁▁</td>
</tr>
<tr class="even">
<td style="text-align: left;">fBodyBodyGyroJerkMag-std()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">-0.80</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">-0.99</td>
<td style="text-align: right;">-0.87</td>
<td style="text-align: right;">-0.81</td>
<td style="text-align: right;">-0.74</td>
<td style="text-align: right;">-0.27</td>
<td style="text-align: left;">▅▇▂▁▁</td>
</tr>
<tr class="odd">
<td style="text-align: left;">fBodyBodyGyroJerkMag-meanFreq()</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">0.08</td>
<td style="text-align: right;">-0.01</td>
<td style="text-align: right;">0.07</td>
<td style="text-align: right;">0.13</td>
<td style="text-align: right;">0.18</td>
<td style="text-align: right;">0.33</td>
<td style="text-align: left;">▅▇▇▅▁</td>
</tr>
</tbody>
</table>
