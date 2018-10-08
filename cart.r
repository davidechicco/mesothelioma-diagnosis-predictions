setwd(".")
options(stringsAsFactors = FALSE)
library("clusterSim")
library("PRROC")
library("e1071")
library("rpart")


accuracy <- function(actual, predicted)
{
  
  TP <- sum(actual == 1 & predicted == 1)
  TN <- sum(actual == 0 & predicted == 0)
  FP <- sum(actual == 0 & predicted == 1)
  FN <- sum(actual == 1 & predicted == 0)
  
  return ((TP+TN) / (FP+TN+TP+FN))
  
}

f1_score <- function(actual, predicted)
{
  
  TP <- sum(actual == 1 & predicted == 1)
  TN <- sum(actual == 0 & predicted == 0)
  FP <- sum(actual == 0 & predicted == 1)
  FN <- sum(actual == 1 & predicted == 0)
  
  precision <- TP / (TP + FP)
  recall <- TP / (TP + FN)

  if ((precision==0 & recall==0) || is.nan(recall) || is.nan(precision))   {
    return (-1.0)
  }  else  {
    return ((2 * precision * recall) / (precision + recall))
  }

}

# Matthews correlation coefficient
mcc <- function(actual, predicted)
{
  # Compute the Matthews correlation coefficient (MCC) score
  # Jeff Hebert 9/1/2016
  # Geoffrey Anderson 10/14/2016 
  # Added zero denominator handling.
  # Avoided overflow error on large-ish products in denominator.
  #
  # actual = vector of true outcomes, 1 = Positive, 0 = Negative
  # predicted = vector of predicted outcomes, 1 = Positive, 0 = Negative
  # function returns MCC
  
  TP <- sum(actual == 1 & predicted == 1)
  TN <- sum(actual == 0 & predicted == 0)
  FP <- sum(actual == 0 & predicted == 1)
  FN <- sum(actual == 1 & predicted == 0)
  #TP;TN;FP;FN # for debugging
  sum1 <- TP+FP; sum2 <-TP+FN ; sum3 <-TN+FP ; sum4 <- TN+FN;
  denom <- as.double(sum1)*sum2*sum3*sum4 # as.double to avoid overflow error on large products
  if (any(sum1==0, sum2==0, sum3==0, sum4==0)) {
    denom <- 1
  }
  mcc <- ((TP*TN)-(FP*FN)) / sqrt(denom)
  return(mcc)
}

fileName <- "./Mesothelioma_data_set_COL_NORM.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");

original_mesothelioma_datatable <- mesothelioma_datatable

# shuffle the rows
mesothelioma_datatable <- original_mesothelioma_datatable[sample(nrow(original_mesothelioma_datatable)),] 

# Allocation of the size of the training set
perce_training_set <- 70
size_training_set <- round(dim(mesothelioma_datatable)[1]*(perce_training_set/100))

# Allocation of the training set and of the test set
test_set <- (mesothelioma_datatable[1:size_training_set,])
training_set <- (mesothelioma_datatable[size_training_set+1:dim(mesothelioma_datatable)[1],])

# Generation of the CART model
cart_model <- rpart(class.of.diagnosis ~ keep.side + platelet.count..PLT., method="class", data=training_set);

test_predictions <- as.numeric(predict(cart_model, test_set, typ="class"))-1
test_set_labels <- as.numeric(test_set$class.of.diagnosis)

mcc_outcome <- mcc(test_predictions, test_set_labels)
cat("The MCC is ", round(mcc_outcome,2), " (worst possible: -1; best possible: +1)\n", sep="")

this_accuracy <- accuracy(test_predictions, test_set_labels)
cat("The accuracy is ", round(this_accuracy,2), " (worst possible: 0; best possible: 1)\n", sep="")

this_f1_score <- f1_score(test_predictions, test_set_labels)
if (this_f1_score != -1 ) {
  cat("The F1 score is ", round(this_f1_score,2), " (worst possible: 0; best possible: 1)\n", sep="")
} else {
  cat("The F1 score cannot be computed\n", sep="")
}

