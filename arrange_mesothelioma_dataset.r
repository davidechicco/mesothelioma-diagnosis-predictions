
# From bash script:
#
# easy_install xlsx2csv
# Rscript -e 'install.packages("clusterSim", repos="https://cran.rstudio.com")'

args = commandArgs(trailingOnly=TRUE)

xlsxFileName <- toString(args[1])
# xlsxFileName <- "../data/MesotheliomaDataSet_original.xlsx" 

options(stringsAsFactors = FALSE)
library("clusterSim")


csvFileName <- gsub(".xlsx", "_CSV.csv", xlsxFileName)

convertCommand <- paste("xlsx2csv ", xlsxFileName, " > ", csvFileName, "; ",  sep="")
print(convertCommand)
system(convertCommand)

datatable = read.table(csvFileName, header = TRUE, sep=",")

print("dim(datatable)")
print(dim(datatable))

targetColumn <- dim(datatable)[2]
datatable[targetColumn] <- datatable[targetColumn] - 1

datatable[7] <- NULL # We remove diagnosis.method

datatable_col_norm <- data.Normalization(datatable,type="n8",normalization="column")

print("dim(datatable_col_norm)")
print(dim(datatable_col_norm))

normCsvFileName <- gsub("_CSV.csv", "_COL_NORM.csv", csvFileName)

write.csv(datatable_col_norm, normCsvFileName, row.names=FALSE)

print("colnames(datatable_col_norm)")
print(colnames(datatable_col_norm))



removeCommand <- paste("rm ", csvFileName, " ;\n", sep="")
print(removeCommand)
system(removeCommand)

cat("\n The normalized-by-column data table has been saved into the ", normCsvFileName, " file \n", sep="")
