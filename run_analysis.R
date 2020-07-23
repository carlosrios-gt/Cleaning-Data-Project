# JHU - Coursera
# Carlos Alberto Rios Calderon
# Getting and Cleaning Data - Final Course Project

# Preparing work environment / Preparando el area de trabajo
install.packages("dplyr")
library(dplyr)
setwd("C:/Users/Carlos Rios/Documents/Johns Hopkings University/03 Getting and Cleaning Data/Course Program Project/UCI HAR Dataset")

# Process to read feature list and activity names
# Proceso para leer la lista de características y nombres de actividades
features_list <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("label", "activity"))
x_test <- read.table("test/X_test.txt", col.names = features_list$functions)
y_test <- read.table("test/Y_test.txt", col.names = "label")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")

## Step 1 ##
# Commands to read test dataset and combine into one dataframe
# Comandos para leer el conjunto de datos de prueba y combinarlos en un solo marco de datos
x_train <- read.table("train/X_train.txt", col.names = features_list$functions)
y_train <- read.table("train/Y_train.txt", col.names = "label")
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
subject <- rbind(subject_train,subject_test)
mergedata <- cbind(subject,y,x)

## Step 2 ##
# Commands to define tidydata
# Comandos definir el ditydata
Tidy_Data <- mergedata %>% select( subject, label, contains("arith.mean"), contains("std,dev"))

## Step 3 ##
# Description to rename the dataset
# Descripción para nombrar el conjunto de datos
Tidy_Data$label <- activities[Tidy_Data$label,2]

## Step 4 ##
# Labeling the variables of the data set
# Etiquetado de las variables del marco de datos
names(Tidy_Data)[2] = "activity"
names(Tidy_Data) <- gsub("Acc", "accelerometer", names(Tidy_Data))
names(Tidy_Data) <- gsub("Gyro", "gyroscope", names(Tidy_Data))
names(Tidy_Data) <- gsub("BodyBody", "body", names(Tidy_Data))
names(Tidy_Data) <- gsub("Mag", "magnitude", names(Tidy_Data))
names(Tidy_Data) <- gsub("^t", "time", names(Tidy_Data))
names(Tidy_Data) <- gsub("^f", "frequency", names(Tidy_Data))
names(Tidy_Data) <- gsub("tBody", "timebody", names(Tidy_Data))
names(Tidy_Data) <- gsub("-mean()", "arith.mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data) <- gsub("-std()", "std.dev", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data) <- gsub("-freq()", "frequency", names(Tidy_Data), ignore.case = TRUE)

## Step 5 ##
# Calculating and creating independent tidy data set with the average of each variable for each activity and each subject.
# Calculando un conjunto de datos ordenado e independiente con el promedio de cada variable para cada actividad y cada sujeto.
FinalData <- Tidy_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(arith.mean))
write.table(FinalData, "Tidy_Data.txt", row.name=FALSE)

# Creating a summarize
# Creando un reporte
str(FinalData)
View(FinalData)
