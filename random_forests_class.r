setwd(".")
options(stringsAsFactors = FALSE)
# library("clusterSim")
library("PRROC")
library("e1071")
library("randomForest");

source("./confusion_matrix_rates.r")

threshold <- 0.5

prc_data_norm <- read.csv(file="../data/MesotheliomaDataSet_original_COL_NORM_34features.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)

prc_data_norm$"diagnosis.method" <- NULL

prc_data_norm <- prc_data_norm[sample(nrow(prc_data_norm)),] # shuffle the rows

target_index <- dim(prc_data_norm)[2]



# the training set is the first 60% of the whole dataset
training_set_first_index <- 1 # NEW
training_set_last_index <- round(dim(prc_data_norm)[1]*60/100) # NEW

# the test set is the last 40% of the whole dataset
test_set_first_index <- training_set_last_index+1 # NEW
test_set_last_index <- dim(prc_data_norm)[1] # NEW

cat("[Creating the subsets for the values]\n")
prc_data_train <- prc_data_norm[training_set_first_index:training_set_last_index, 1:(target_index)] # NEW
prc_data_test <- prc_data_norm[test_set_first_index:test_set_last_index, 1:(target_index)] # NEW

cat("[Creating the subsets for the labels \"1\"-\"0\"]\n")
prc_data_train_labels <- prc_data_norm[training_set_first_index:training_set_last_index, target_index] # NEW
prc_data_test_labels <- prc_data_norm[test_set_first_index:test_set_last_index, target_index]   # NEW


library(class)
library(gmodels)

rf_new <- randomForest(class.of.diagnosis ~ ., data=prc_data_train, importance=TRUE, proximity=TRUE)
prc_data_test_PRED <- predict(rf_new, prc_data_test, type="response")

prc_data_test_PRED_binary <- as.numeric(prc_data_test_PRED)

prc_data_test_PRED_binary[prc_data_test_PRED_binary>=threshold]=1
prc_data_test_PRED_binary[prc_data_test_PRED_binary<threshold]=0

print(prc_data_test$class.of.diagnosis)
print(prc_data_test_PRED_binary)
# prc_data_test_PRED_binary

fg_test <- prc_data_test_PRED[prc_data_test_labels==1]
bg_test <- prc_data_test_PRED[prc_data_test_labels==0]
pr_curve_test <- pr.curve(scores.class0 = fg_test, scores.class1 = bg_test, curve = F)
#plot(pr_curve_test)
# print(pr_curve_test)

mcc_outcome <- mcc(prc_data_test_labels, prc_data_test_PRED_binary)

confusion_matrix_rates(prc_data_test_labels, prc_data_test_PRED_binary)



