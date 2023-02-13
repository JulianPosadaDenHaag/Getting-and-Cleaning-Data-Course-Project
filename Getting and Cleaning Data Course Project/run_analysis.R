library(here)
library(tidyverse)
library(readr)
library(skimr)
library(data.table)
library(stringr)

# using the library here, I am setting up the correct path
path<-     here::here( "Getting and Cleaning Data course Project",
                       "UCI HAR Dataset")

# this takes the features names from "features.txt"
features<-data.table::fread(here::here(path,
                                       "features.txt"))%>% 
        set_names(c("index", "names")) 

#this select only the "names" in "features.txt" that contains mean or std
mean_std<- features %>% filter( grepl("mean|std",features$names))
        

#This load the x_train.txt into a data table, and set the names of all columns. Then only the
# names with mean or std are selected. 
x_train<- data.table::fread(here::here(path,       
                                       "train",
                                        "X_train.txt"))%>%
        setNames(features$names) %>% select(mean_std$names)

# a data.table is created with the values to be transformed into activity_labels
y_train<-  data.table::fread(here::here(path,
                                        "train",
                                        "y_train.txt")) %>% 
        set_names("labels")

#a data.table is created that contains all te subjects.  An index is created. 
subject_train<-  data.table::fread(here::here(path,
                                              "train",
                                              "subject_train.txt")) %>%
        set_names("subject")%>% 
        mutate("index" =row_number())

#  the data from y_train, subject_train and activity labels is merged. 
activity_labelsX<-data.table::fread(here::here(path,
                                             "activity_labels.txt"))%>% 
         set_names(c("labels", "activity_labels")) %>% 
        merge(y_train, by = "labels") %>% mutate("index" =row_number()) %>% 
        merge(subject_train, by = "index") %>% select(!index & !labels)

# All the columns are merged to created the tidy x_train dataset. 
x_train<-bind_cols(activity_labelsX,x_train)

#This load the x_test.txt into a data table, and set the names of all columns. Then only the
# names with mean or std are selected. 
x_test<- data.table::fread(here::here(path,       
                                      "test",
                                      "X_test.txt"))%>%
        setNames(features$names)%>% select(mean_std$names)

# a data.table is created with the values to be transformed into activity_labels
y_test<-  data.table::fread(here::here(path,
                                        "test",
                                        "y_test.txt")) %>% 
        set_names("labels")

#a data.table is created that contains all te subjects.  An index is created. 
subject_train_y<-  data.table::fread(here::here(path,
                                              "test",
                                              "subject_test.txt")) %>%
        set_names("subject")%>% 
        mutate("index" =row_number())

#  the data from y_train, subject_train and activity labels is merged. 
activity_labelsY<-data.table::fread(here::here(path,
                                               "activity_labels.txt"))%>% 
        set_names(c("labels", "activity_labels")) %>% 
        merge(y_test, by = "labels") %>% mutate("index" =row_number()) %>% 
        merge(subject_train_y, by = "index")%>% select(!index & !labels)

# All the columns are merged to created th tidy x_train dataset. 
x_test<-bind_cols(activity_labelsY,x_test) 

#binding all the rows to create a tidy_dataset.  The subject is set to the first column

tidy_data<- bind_rows(x_train,x_test) %>% 
        relocate(subject)

tidy_data_average<- tidy_data %>% 
  group_by( subject, activity_labels) %>% 
  summarise(across(everything(), mean), .groups = "drop") %>% arrange(subject,activity_labels)


write.table(tidy_data_average,file= "tidy_data_average.txt",row.name=FALSE )
View(tidy_data_average)
