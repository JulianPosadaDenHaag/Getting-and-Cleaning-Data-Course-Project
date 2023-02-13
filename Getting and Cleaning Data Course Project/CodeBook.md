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

    subject_train<-  data.table::fread(here::here(path, "train","subject_train.txt"),colClasses = "character") %>%
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

    summary(tidy_data_average)

    ##    subject          activity_labels    tBodyAcc-mean()-X tBodyAcc-mean()-Y 
    ##  Length:40          Length:40          Min.   :0.2657    Min.   :-0.02095  
    ##  Class :character   Class :character   1st Qu.:0.2706    1st Qu.:-0.01856  
    ##  Mode  :character   Mode  :character   Median :0.2755    Median :-0.01766  
    ##                                        Mean   :0.2744    Mean   :-0.01746  
    ##                                        3rd Qu.:0.2776    3rd Qu.:-0.01645  
    ##                                        Max.   :0.2802    Max.   :-0.01335  
    ##  tBodyAcc-mean()-Z tBodyAcc-std()-X  tBodyAcc-std()-Y  tBodyAcc-std()-Z  
    ##  Min.   :-0.1183   Min.   :-0.9924   Min.   :-0.9722   Min.   :-0.97635  
    ##  1st Qu.:-0.1100   1st Qu.:-0.6680   1st Qu.:-0.5905   1st Qu.:-0.70516  
    ##  Median :-0.1087   Median :-0.6192   Median :-0.5317   Median :-0.64677  
    ##  Mean   :-0.1088   Mean   :-0.6281   Mean   :-0.5311   Mean   :-0.64518  
    ##  3rd Qu.:-0.1067   3rd Qu.:-0.5545   3rd Qu.:-0.4224   3rd Qu.:-0.57841  
    ##  Max.   :-0.0996   Max.   :-0.1270   Max.   : 0.1215   Max.   :-0.08298  
    ##  tGravityAcc-mean()-X tGravityAcc-mean()-Y tGravityAcc-mean()-Z
    ##  Min.   :0.4753       Min.   :-0.180019    Min.   :-0.28488    
    ##  1st Qu.:0.6471       1st Qu.:-0.062547    1st Qu.: 0.03948    
    ##  Median :0.6738       Median : 0.019050    Median : 0.09160    
    ##  Mean   :0.6790       Mean   : 0.004372    Mean   : 0.08625    
    ##  3rd Qu.:0.7026       3rd Qu.: 0.067378    3rd Qu.: 0.14281    
    ##  Max.   :0.9626       Max.   : 0.281472    Max.   : 0.23923    
    ##  tGravityAcc-std()-X tGravityAcc-std()-Y tGravityAcc-std()-Z
    ##  Min.   :-0.9957     Min.   :-0.9825     Min.   :-0.9738    
    ##  1st Qu.:-0.9722     1st Qu.:-0.9624     1st Qu.:-0.9537    
    ##  Median :-0.9660     Median :-0.9571     Median :-0.9429    
    ##  Mean   :-0.9659     Mean   :-0.9557     Mean   :-0.9420    
    ##  3rd Qu.:-0.9587     3rd Qu.:-0.9508     3rd Qu.:-0.9304    
    ##  Max.   :-0.9340     Max.   :-0.9011     Max.   :-0.8807    
    ##  tBodyAccJerk-mean()-X tBodyAccJerk-mean()-Y tBodyAccJerk-mean()-Z
    ##  Min.   :0.05724       Min.   :-0.003104     Min.   :-0.0196720   
    ##  1st Qu.:0.07683       1st Qu.: 0.003826     1st Qu.:-0.0073727   
    ##  Median :0.07824       Median : 0.007196     Median :-0.0039814   
    ##  Mean   :0.07813       Mean   : 0.007454     Mean   :-0.0044584   
    ##  3rd Qu.:0.08188       3rd Qu.: 0.010645     3rd Qu.:-0.0007876   
    ##  Max.   :0.08664       Max.   : 0.020047     Max.   : 0.0155338   
    ##  tBodyAccJerk-std()-X tBodyAccJerk-std()-Y tBodyAccJerk-std()-Z
    ##  Min.   :-0.9936      Min.   :-0.987196    Min.   :-0.9911     
    ##  1st Qu.:-0.7001      1st Qu.:-0.678521    1st Qu.:-0.8280     
    ##  Median :-0.6374      Median :-0.621958    Median :-0.7817     
    ##  Mean   :-0.6555      Mean   :-0.620812    Mean   :-0.7785     
    ##  3rd Qu.:-0.5760      3rd Qu.:-0.502877    3rd Qu.:-0.7267     
    ##  Max.   :-0.1716      Max.   : 0.004091    Max.   :-0.3869     
    ##  tBodyGyro-mean()-X  tBodyGyro-mean()-Y tBodyGyro-mean()-Z tBodyGyro-std()-X
    ##  Min.   :-0.070278   Min.   :-0.10137   Min.   :0.04831    Min.   :-0.9876  
    ##  1st Qu.:-0.041855   1st Qu.:-0.08290   1st Qu.:0.08399    1st Qu.:-0.7668  
    ##  Median :-0.027554   Median :-0.07732   Median :0.08826    Median :-0.7201  
    ##  Mean   :-0.031428   Mean   :-0.07503   Mean   :0.08844    Mean   :-0.7345  
    ##  3rd Qu.:-0.020822   3rd Qu.:-0.07060   3rd Qu.:0.09601    3rd Qu.:-0.6771  
    ##  Max.   : 0.007798   Max.   :-0.04224   Max.   :0.11626    Max.   :-0.3534  
    ##  tBodyGyro-std()-Y tBodyGyro-std()-Z tBodyGyroJerk-mean()-X
    ##  Min.   :-0.9858   Min.   :-0.9857   Min.   :-0.11443      
    ##  1st Qu.:-0.7674   1st Qu.:-0.7239   1st Qu.:-0.10388      
    ##  Median :-0.7273   Median :-0.6883   Median :-0.09765      
    ##  Mean   :-0.7028   Mean   :-0.6713   Mean   :-0.09631      
    ##  3rd Qu.:-0.6436   3rd Qu.:-0.5968   3rd Qu.:-0.09137      
    ##  Max.   :-0.2167   Max.   :-0.1694   Max.   :-0.05891      
    ##  tBodyGyroJerk-mean()-Y tBodyGyroJerk-mean()-Z tBodyGyroJerk-std()-X
    ##  Min.   :-0.05007       Min.   :-0.06442       Min.   :-0.9927      
    ##  1st Qu.:-0.04396       1st Qu.:-0.05715       1st Qu.:-0.7790      
    ##  Median :-0.04146       Median :-0.05514       Median :-0.7350      
    ##  Mean   :-0.04217       Mean   :-0.05468       Mean   :-0.7382      
    ##  3rd Qu.:-0.04002       3rd Qu.:-0.05273       3rd Qu.:-0.6742      
    ##  Max.   :-0.03722       Max.   :-0.04186       Max.   :-0.0342      
    ##  tBodyGyroJerk-std()-Y tBodyGyroJerk-std()-Z tBodyAccMag-mean()
    ##  Min.   :-0.9934       Min.   :-0.99354      Min.   :-0.98028  
    ##  1st Qu.:-0.8708       1st Qu.:-0.79592      1st Qu.:-0.61689  
    ##  Median :-0.8084       Median :-0.75702      Median :-0.54135  
    ##  Mean   :-0.7975       Mean   :-0.74395      Mean   :-0.57317  
    ##  3rd Qu.:-0.7242       3rd Qu.:-0.69365      3rd Qu.:-0.50024  
    ##  Max.   :-0.3000       Max.   :-0.05099      Max.   :-0.05541  
    ##  tBodyAccMag-std() tGravityAccMag-mean() tGravityAccMag-std()
    ##  Min.   :-0.9747   Min.   :-0.98028      Min.   :-0.9747     
    ##  1st Qu.:-0.6593   1st Qu.:-0.61689      1st Qu.:-0.6593     
    ##  Median :-0.5984   Median :-0.54135      Median :-0.5984     
    ##  Mean   :-0.6125   Mean   :-0.57317      Mean   :-0.6125     
    ##  3rd Qu.:-0.5450   3rd Qu.:-0.50024      3rd Qu.:-0.5450     
    ##  Max.   :-0.1046   Max.   :-0.05541      Max.   :-0.1046     
    ##  tBodyAccJerkMag-mean() tBodyAccJerkMag-std() tBodyGyroMag-mean()
    ##  Min.   :-0.9924        Min.   :-0.9915       Min.   :-0.9795    
    ##  1st Qu.:-0.7060        1st Qu.:-0.6881       1st Qu.:-0.6935    
    ##  Median :-0.6590        Median :-0.6260       Median :-0.6202    
    ##  Mean   :-0.6654        Mean   :-0.6435       Mean   :-0.6272    
    ##  3rd Qu.:-0.5839        3rd Qu.:-0.5567       3rd Qu.:-0.5499    
    ##  Max.   :-0.1539        Max.   :-0.0879       Max.   :-0.1756    
    ##  tBodyGyroMag-std() tBodyGyroJerkMag-mean() tBodyGyroJerkMag-std()
    ##  Min.   :-0.9805    Min.   :-0.9946         Min.   :-0.9937       
    ##  1st Qu.:-0.7445    1st Qu.:-0.8298         1st Qu.:-0.8637       
    ##  Median :-0.6780    Median :-0.7834         Median :-0.8013       
    ##  Mean   :-0.6788    Mean   :-0.7716         Mean   :-0.7867       
    ##  3rd Qu.:-0.6072    3rd Qu.:-0.7131         3rd Qu.:-0.7232       
    ##  Max.   :-0.2012    Max.   :-0.2027         Max.   :-0.2368       
    ##  fBodyAcc-mean()-X fBodyAcc-mean()-Y fBodyAcc-mean()-Z fBodyAcc-std()-X 
    ##  Min.   :-0.9922   Min.   :-0.9752   Min.   :-0.9827   Min.   :-0.9925  
    ##  1st Qu.:-0.6905   1st Qu.:-0.6106   1st Qu.:-0.7442   1st Qu.:-0.6578  
    ##  Median :-0.6226   Median :-0.5562   Median :-0.6884   Median :-0.6154  
    ##  Mean   :-0.6417   Mean   :-0.5559   Mean   :-0.6907   Mean   :-0.6242  
    ##  3rd Qu.:-0.5779   3rd Qu.:-0.4383   3rd Qu.:-0.6300   3rd Qu.:-0.5478  
    ##  Max.   :-0.1338   Max.   : 0.1020   Max.   :-0.2726   Max.   :-0.1272  
    ##  fBodyAcc-std()-Y   fBodyAcc-std()-Z   fBodyAcc-meanFreq()-X
    ##  Min.   :-0.97169   Min.   :-0.97406   Min.   :-0.348854    
    ##  1st Qu.:-0.60560   1st Qu.:-0.71320   1st Qu.:-0.242945    
    ##  Median :-0.54290   Median :-0.65149   Median :-0.218266    
    ##  Mean   :-0.54918   Mean   :-0.65062   Mean   :-0.204185    
    ##  3rd Qu.:-0.45817   3rd Qu.:-0.59200   3rd Qu.:-0.180500    
    ##  Max.   : 0.05923   Max.   :-0.05984   Max.   : 0.007987    
    ##  fBodyAcc-meanFreq()-Y fBodyAcc-meanFreq()-Z fBodyAccJerk-mean()-X
    ##  Min.   :-0.16456      Min.   :-0.140595     Min.   :-0.9937      
    ##  1st Qu.:-0.02825      1st Qu.: 0.005818     1st Qu.:-0.7168      
    ##  Median : 0.03748      Median : 0.051708     Median :-0.6600      
    ##  Mean   : 0.02171      Mean   : 0.055647     Mean   :-0.6719      
    ##  3rd Qu.: 0.07151      3rd Qu.: 0.090987     3rd Qu.:-0.6019      
    ##  Max.   : 0.13642      Max.   : 0.284313     Max.   :-0.2090      
    ##  fBodyAccJerk-mean()-Y fBodyAccJerk-mean()-Z fBodyAccJerk-std()-X
    ##  Min.   :-0.98687      Min.   :-0.9894       Min.   :-0.9942     
    ##  1st Qu.:-0.69749      1st Qu.:-0.8090       1st Qu.:-0.7101     
    ##  Median :-0.64149      Median :-0.7679       Median :-0.6547     
    ##  Mean   :-0.64145      Mean   :-0.7605       Mean   :-0.6697     
    ##  3rd Qu.:-0.54047      3rd Qu.:-0.7089       3rd Qu.:-0.5862     
    ##  Max.   :-0.08715      Max.   :-0.3530       Max.   :-0.2071     
    ##  fBodyAccJerk-std()-Y fBodyAccJerk-std()-Z fBodyAccJerk-meanFreq()-X
    ##  Min.   :-0.98858     Min.   :-0.9913      Min.   :-0.27090         
    ##  1st Qu.:-0.67943     1st Qu.:-0.8460      1st Qu.:-0.09216         
    ##  Median :-0.62243     Median :-0.7969      Median :-0.04095         
    ##  Mean   :-0.62457     Mean   :-0.7954      Mean   :-0.03006         
    ##  3rd Qu.:-0.50474     3rd Qu.:-0.7434      3rd Qu.: 0.01699         
    ##  Max.   : 0.03547     Max.   :-0.4196      Max.   : 0.25766         
    ##  fBodyAccJerk-meanFreq()-Y fBodyAccJerk-meanFreq()-Z fBodyGyro-mean()-X
    ##  Min.   :-0.40027          Min.   :-0.30464          Min.   :-0.98612  
    ##  1st Qu.:-0.24934          1st Qu.:-0.16540          1st Qu.:-0.71258  
    ##  Median :-0.19827          Median :-0.10515          Median :-0.67328  
    ##  Mean   :-0.20126          Mean   :-0.10416          Mean   :-0.68399  
    ##  3rd Qu.:-0.16451          3rd Qu.:-0.07174          3rd Qu.:-0.62998  
    ##  Max.   : 0.08838          Max.   : 0.13623          Max.   :-0.07883  
    ##  fBodyGyro-mean()-Y fBodyGyro-mean()-Z fBodyGyro-std()-X fBodyGyro-std()-Y
    ##  Min.   :-0.9874    Min.   :-0.98643   Min.   :-0.9881   Min.   :-0.9849  
    ##  1st Qu.:-0.8000    1st Qu.:-0.71157   1st Qu.:-0.7865   1st Qu.:-0.7738  
    ##  Median :-0.7463    Median :-0.66724   Median :-0.7367   Median :-0.7254  
    ##  Mean   :-0.7239    Mean   :-0.65796   Mean   :-0.7521   Mean   :-0.6953  
    ##  3rd Qu.:-0.6419    3rd Qu.:-0.60237   3rd Qu.:-0.6906   3rd Qu.:-0.6493  
    ##  Max.   :-0.2488    Max.   :-0.08198   Max.   :-0.4454   Max.   :-0.1509  
    ##  fBodyGyro-std()-Z fBodyGyro-meanFreq()-X fBodyGyro-meanFreq()-Y
    ##  Min.   :-0.9867   Min.   :-0.30704       Min.   :-0.40331      
    ##  1st Qu.:-0.7528   1st Qu.:-0.14378       1st Qu.:-0.23774      
    ##  Median :-0.7186   Median :-0.10234       Median :-0.15943      
    ##  Mean   :-0.7079   Mean   :-0.10091       Mean   :-0.17280      
    ##  3rd Qu.:-0.6389   3rd Qu.:-0.03931       3rd Qu.:-0.09613      
    ##  Max.   :-0.2257   Max.   : 0.12250       Max.   : 0.08460      
    ##  fBodyGyro-meanFreq()-Z fBodyAccMag-mean() fBodyAccMag-std()
    ##  Min.   :-0.266167      Min.   :-0.98140   Min.   :-0.9748  
    ##  1st Qu.:-0.077612      1st Qu.:-0.65817   1st Qu.:-0.7076  
    ##  Median :-0.044087      Median :-0.59292   Median :-0.6687  
    ##  Mean   :-0.042621      Mean   :-0.60635   Mean   :-0.6779  
    ##  3rd Qu.:-0.003054      3rd Qu.:-0.51739   3rd Qu.:-0.6191  
    ##  Max.   : 0.265781      Max.   :-0.05628   Max.   :-0.2742  
    ##  fBodyAccMag-meanFreq() fBodyBodyAccJerkMag-mean() fBodyBodyAccJerkMag-std()
    ##  Min.   :-0.06820       Min.   :-0.99120           Min.   :-0.9907          
    ##  1st Qu.: 0.03812       1st Qu.:-0.68402           1st Qu.:-0.6894          
    ##  Median : 0.08495       Median :-0.61798           Median :-0.6390          
    ##  Mean   : 0.08425       Mean   :-0.63689           Mean   :-0.6551          
    ##  3rd Qu.: 0.13997       3rd Qu.:-0.54154           3rd Qu.:-0.5821          
    ##  Max.   : 0.25776       Max.   :-0.07597           Max.   :-0.1103          
    ##  fBodyBodyAccJerkMag-meanFreq() fBodyBodyGyroMag-mean() fBodyBodyGyroMag-std()
    ##  Min.   :-0.02354               Min.   :-0.9859         Min.   :-0.9803       
    ##  1st Qu.: 0.12167               1st Qu.:-0.7720         1st Qu.:-0.7709       
    ##  Median : 0.17704               Median :-0.7272         Median :-0.7076       
    ##  Mean   : 0.18153               Mean   :-0.7103         Mean   :-0.7156       
    ##  3rd Qu.: 0.21617               3rd Qu.:-0.6498         3rd Qu.:-0.6595       
    ##  Max.   : 0.40347               Max.   :-0.1562         Max.   :-0.3770       
    ##  fBodyBodyGyroMag-meanFreq() fBodyBodyGyroJerkMag-mean()
    ##  Min.   :-0.31465            Min.   :-0.9937            
    ##  1st Qu.:-0.11207            1st Qu.:-0.8650            
    ##  Median :-0.03994            Median :-0.8035            
    ##  Mean   :-0.04543            Mean   :-0.7886            
    ##  3rd Qu.: 0.01493            3rd Qu.:-0.7194            
    ##  Max.   : 0.28622            Max.   :-0.2526            
    ##  fBodyBodyGyroJerkMag-std() fBodyBodyGyroJerkMag-meanFreq()
    ##  Min.   :-0.9939            Min.   :-0.00802               
    ##  1st Qu.:-0.8722            1st Qu.: 0.06580               
    ##  Median :-0.8101            Median : 0.12932               
    ##  Mean   :-0.8001            Mean   : 0.13092               
    ##  3rd Qu.:-0.7426            3rd Qu.: 0.18183               
    ##  Max.   :-0.2708            Max.   : 0.33225
