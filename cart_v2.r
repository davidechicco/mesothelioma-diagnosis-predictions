
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



setwd(".")
options(stringsAsFactors = FALSE)

list.of.packages <- c("PRROC", "e1071", "clusterSim","rpart")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("clusterSim")
library("PRROC")
library("e1071")
library("rpart")



# Function that returns a more balanced training set
train_data_balancer <- function(thisDataset, target_index, training_set_perc) {

    cat("\ntrain_data_balancer() function\n")
    
    thisDatasetSize <- dim(thisDataset)[1]
 
    training_set_numb_of_ele <- round(training_set_perc*thisDatasetSize/100,0)
    cat("\nThe training set will contain ", training_set_numb_of_ele, " items (", training_set_perc, "%) of the data instances\n", sep="")

    test_set_perc <- 100-training_set_perc
    test_set_numb_of_ele <- thisDatasetSize - training_set_numb_of_ele
    cat("The test set will contain ", test_set_numb_of_ele, " items (", test_set_perc, "%) of the data instances\n", sep="")
 
    # Split negative subset and positive subset
    positive_subset <- (thisDataset[is.element(thisDataset[,target_index], 1),])
    negative_subset <- (thisDataset[is.element(thisDataset[,target_index], 0),])
    positiveSetSize <- dim(positive_subset)[1]
    negativeSetSize <- dim(negative_subset)[1]
    cat("positiveSetSize = ", positiveSetSize, "\n", sep="")
    cat("negativeSetSize = ", negativeSetSize, "\n", sep="")
 
    title <- "Positive dataset"
    #dataset_dim_retriever(positive_subset, title)
    #imbalance_retriever(positive_subset[ , target_index], title)

    title <- "Negative dataset"
    #dataset_dim_retriever(negative_subset, title)
    #imbalance_retriever(negative_subset[ , target_index], title)
    
    cat("\nThe training set will contain ", training_set_numb_of_ele, " items", sep="")
    cat("\nThe test set will contain ", test_set_numb_of_ele, " items \n", sep="")
    
    # newTrainingSet <- 50% positive_subset & 50% negative_subset 
    # from index 1 to 81 (that is training_set_numb_of_ele/2 ) of positive_subset
    # and from index 1 to 81 (that is training_set_numb_of_ele/2 ) of negative_subset
    train_set_perc_of_positives <- INPUT_PERC_POS # 38   
    train_set_num_of_positives <- round(training_set_numb_of_ele*train_set_perc_of_positives/100, 0)
    train_set_num_of_negatives <- round(training_set_numb_of_ele - train_set_num_of_positives,0)
    trainPosComponent <- positive_subset[(1:train_set_num_of_positives), ]
    trainNegComponent <- negative_subset[(1:train_set_num_of_negatives), ]
    newTrainingSetTemp <- rbind(trainPosComponent, trainNegComponent)
    newTrainingSet <- newTrainingSetTemp[sample(nrow(newTrainingSetTemp)),]
    
    title <- "New training set"
    # dataset_dim_retriever(newTrainingSet, title)
    # imbalance_retriever(newTrainingSet[ , target_index], title)
    
    # newTestSet <- all the rest
    # from index 82 (that is training_set_numb_of_ele/2 + 1) to the end of positive_subset
    # and from index 82 (that is training_set_numb_of_ele/2 + 1) to the end of negative_subset
    
#     cat("train_set_num_of_positives +1 = ", train_set_num_of_positives+1, "\n", sep="")
#     cat("positiveSetSize = ", positiveSetSize, "\n", sep="")
#     cat("train_set_num_of_negatives +1 = ", train_set_num_of_negatives+1, "\n", sep="")
#     cat("negativeSetSize = ", negativeSetSize, "\n", sep="")

    testPosComponent <- positive_subset[((train_set_num_of_positives+1):positiveSetSize), ]
    testNegComponent <- negative_subset[((train_set_num_of_negatives+1):negativeSetSize), ]
    
    # print("dim(testPosComponent)")
    # print(dim(testPosComponent))
    # print("dim(testNegComponent)")
    # print(dim(testNegComponent))
    newTestSetTemp <- rbind(testPosComponent, testNegComponent)
    newTestSet <- newTestSetTemp[sample(nrow(newTestSetTemp)),]
    
    title <- "New test set"
    # dataset_dim_retriever(newTestSet, title)
    # imbalance_retriever(newTestSet[ , target_index], title)
    
    return (list(newTrainingSet, newTestSet))
}

list.of.packages <- c("PRROC", "e1071", "randomForest","gsubfn", "gmodels")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("PRROC")
library("e1071")
library("randomForest")
library("gsubfn")
library("gmodels")

source("./confusion_matrix_rates.r")
source("./utils.r")

threshold <- 0.5

prc_data_norm <- read.csv(file="./Mesothelioma_data_set_COL_NORM.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)

prc_data_norm$"diagnosis.method" <- NULL
prc_data_norm <- prc_data_norm[sample(nrow(prc_data_norm)),] # shuffle the rows
target_index <- dim(prc_data_norm)[2]

# Print the size and imbalance level of the complete dataset
title <- "Complete dataset"
dataset_dim_retriever(prc_data_norm, title)
imbalance_retriever(prc_data_norm[ , target_index], title)

training_set_perc <- INPUT_PERC_TRAIN # 70 Most important

# training_set_numb_of_ele <- round(training_set_perc*dim(prc_data_norm)[1]/100,0)
# cat("\nThe training set will contain ", training_set_numb_of_ele, " items (", training_set_perc, "%) of the data instances\n", sep="")
# 
# test_set_perc <- 100-training_set_perc
# test_set_numb_of_ele <- dim(prc_data_norm)[1] - training_set_numb_of_ele
# cat("The test set will contain ", test_set_numb_of_ele, " items (", test_set_perc, "%) of the data instances\n", sep="")


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


# Allocation of the training set and of the test set
test_set <- prc_data_test
training_set <- prc_data_train

# Generation of the CART model
cart_model <- rpart(class.of.diagnosis ~ keep.side + platelet.count..PLT., method="class", data=training_set);

test_predictions <- as.numeric(predict(cart_model, test_set, typ="class"))-1
test_set_labels <- as.numeric(test_set$class.of.diagnosis)


prc_data_test_PRED_binary <- as.numeric(test_predictions)

prc_data_test_PRED_binary[prc_data_test_PRED_binary>=threshold]=1
prc_data_test_PRED_binary[prc_data_test_PRED_binary<threshold]=0
mcc_outcome <- mcc(test_set_labels, prc_data_test_PRED_binary)
confusion_matrix_rates(test_set_labels, prc_data_test_PRED_binary)
