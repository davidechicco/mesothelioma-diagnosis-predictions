#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

INPUT_PERC_POS <-  -1
INPUT_PERC_TRAIN <-  -1

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)>=1) {
  # default output file
  INPUT_PERC_POS <- as.numeric(args[1])
  INPUT_PERC_TRAIN <- as.numeric(args[2])
}

cat("INPUT_PERC_POS = ", INPUT_PERC_POS, "\n" , sep="")
cat("INPUT_PERC_TRAIN = ", INPUT_PERC_TRAIN, "\n", sep="")

library("PRROC")
library("e1071")
library("randomForest")
library("gsubfn")
library("gmodels")

source("./confusion_matrix_rates.r")
source("./utils.r")



setwd(".")
options(stringsAsFactors = FALSE)
# library("clusterSim")



list.of.packages <- c("PRROC", "e1071", "randomForest","gsubfn", "gmodels")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


threshold <- 0.5

prc_data_norm <- read.csv(file="./Mesothelioma_data_set_COL_NORM.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)

prc_data_norm$"diagnosis.method" <- NULL
prc_data_norm <- prc_data_norm[sample(nrow(prc_data_norm)),] # shuffle the rows
target_index <- dim(prc_data_norm)[2]

# Print the size and imbalance level of the complete dataset
title <- "Complete dataset"
dataset_dim_retriever(prc_data_norm, title)
imbalance_retriever(prc_data_norm[ , target_index], title)

training_set_perc <- INPUT_PERC_TRAIN # 50 Most important


# Creating the subsets for the data instances
train_data_balancer_output <- train_data_balancer(prc_data_norm, target_index, training_set_perc)

prc_data_train <- train_data_balancer_output[[1]]
prc_data_test <- train_data_balancer_output[[2]]
 
# Creating the subsets for the targets
prc_data_train_labels <- prc_data_train[, target_index] # NEW
prc_data_test_labels <- prc_data_test[, target_index]   # NEW


# Print the size and imbalance level of the training set
title <- "NEW training set"
dataset_dim_retriever(prc_data_train, title)
imbalance_retriever(prc_data_train_labels, title)

# Print the size and imbalance level of the test set
title <- "NEW test set"
dataset_dim_retriever(prc_data_test, title)
imbalance_retriever(prc_data_test_labels, title)





# # # # # # # # # # # # # # # # # # # # # # # # 
#exit("The script will stop here")
# # # # # # # # # # # # # # # # # # # # # # # # 


library(class)
library(gmodels)

rf_new <- randomForest(class.of.diagnosis ~ ., data=prc_data_train, importance=FALSE, proximity=TRUE, ntree=500)
prc_data_test_PRED <- predict(rf_new, prc_data_test, type="response")

prc_data_test_PRED_binary <- as.numeric(prc_data_test_PRED)

prc_data_test_PRED_binary[prc_data_test_PRED_binary>=threshold]=1
prc_data_test_PRED_binary[prc_data_test_PRED_binary<threshold]=0

# print(prc_data_test$class.of.diagnosis)
# print(prc_data_test_PRED_binary)
# prc_data_test_PRED_binary

fg_test <- prc_data_test_PRED[prc_data_test_labels==1]
bg_test <- prc_data_test_PRED[prc_data_test_labels==0]
pr_curve_test <- pr.curve(scores.class0 = fg_test, scores.class1 = bg_test, curve = F)
#plot(pr_curve_test)
# print(pr_curve_test)

mcc_outcome <- mcc(prc_data_test_labels, prc_data_test_PRED_binary)

confusion_matrix_rates(prc_data_test_labels, prc_data_test_PRED_binary)



