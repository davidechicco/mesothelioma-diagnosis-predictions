

library("randomForest");

fileName <- "./Mesothelioma_data_set_COL_NORM.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");

mesothelioma_datatable$"diagnosis.method" <- NULL


rf_output <- randomForest(class.of.diagnosis ~ ., data=mesothelioma_datatable, importance=TRUE, proximity=TRUE)

dd <- as.data.frame(rf_output$importance);
dd_sorted <- dd[order(dd$"%IncMSE"), ]

print(dd_sorted);

varImpPlot(rf_output)

