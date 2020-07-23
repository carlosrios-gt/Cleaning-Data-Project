# JHU - Coursera
# Carlos Alberto Rios Calderon
# Getting and Cleaning Data - Final Course Project

# Preparing work environment / Preparando el area de trabajo
install.packages("dplyr")
library(dplyr)
setwd("C:/Users/Carlos Rios/Documents/Johns Hopkings University/03 Getting and Cleaning Data/Course Program Project/UCI HAR Dataset")

# Process to read feature list and activity names
# Proceso para leer la lista de características y nombres de actividades
features_list <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))

# Commands to read test dataset and combine into one dataframe
# Comandos para leer el conjunto de datos de prueba y combinarlos en un solo marco de datos
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features_list$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")

# Executing labeling
# Ejecutando etiquetas
y_test_label <- left_join(y_test, activity, by = "label")
tidy_test <- cbind(subject_test, y_test_label, x_test)
tidy_test <- select(tidy_test, -label)

# Read the training dataset
# Cargando el marco de datos del entrenamiento/prueba
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features_list$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, activity, by = "label")

#Executing cleaning process
#Ejecutando la limpieza de datos
tidy_train <- cbind(subject_train, y_train_label, x_train)
tidy_train <- select(tidy_train, -label)

# Executing a combination of test and train data set
# Ejecutando una consolidacion de juego de datos de prueba y entrenamiento
tidy_set <- rbind(tidy_test, tidy_train)

# Extract the arithmetical mean and standard deviation
# Extrayendo la media y la desviacion estandar
tidy_mean_std <- select(tidy_set, contains("mean"), contains("std"))

# Calculating the average of all variable by each subject each activity
# Calculando el promedio de todas las variables por cada sujeto en cada actividad
tidy_mean_std$subject <- as.factor(tidy_set$subject)
tidy_mean_std$activity <- as.factor(tidy_set$activity)

# Creating a summarize
# Creando un reporte
tidy_avg <- tidy_mean_std %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))