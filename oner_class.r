setwd(".")
options(stringsAsFactors = FALSE)
# library("clusterSim")

library("OneR");
library(class)
library(gmodels)
source("./confusion_matrix_rates.r")

threshold <- 0.5

prc_data_norm <- read.csv(file="./Mesothelioma_data_set_COL_NORM.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)

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




#rf_new <- randomForest(class.of.diagnosis ~ ., data=prc_data_train, importance=TRUE, proximity=TRUE)


# Original application of One Rule with all the dataset
prc_model_train <- OneR(prc_data_train, verbose = TRUE)

# Generation of the CART model
# prc_model_train <- OneR(class.of.diagnosis ~ keep.side + platelet.count..PLT., method="class", data=prc_data_train);

summary(prc_model_train)
prediction <- predict(prc_model_train, prc_data_test)
# eval_model(prediction, prc_data_test)


prc_data_test_PRED_binary <- data.frame(prediction)

# print(prc_data_test$class.of.diagnosis)
# print(prc_data_test_PRED_binary)
# prc_data_test_PRED_binary

fg_test <- prc_data_test_PRED_binary[prc_data_test_PRED_binary==1]
bg_test <- prc_data_test_PRED_binary[prc_data_test_PRED_binary==0]
# pr_curve_test <- pr.curve(scores.class0 = fg_test, scores.class1 = bg_test, curve = F)
#plot(pr_curve_test)
# print(pr_curve_test)

mcc_outcome <- mcc(prc_data_test$"class.of.diagnosis", prc_data_test_PRED_binary)

confusion_matrix_rates(prc_data_test$"class.of.diagnosis", prc_data_test_PRED_binary)



