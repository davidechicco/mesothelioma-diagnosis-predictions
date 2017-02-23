
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

targetColumn <- dim(datatable)[2]
datatable[targetColumn] <- datatable[targetColumn] - 1

datatable_col_norm <- data.Normalization(datatable,type="n8",normalization="column")

normCsvFileName <- gsub("_CSV.csv", "_COL_NORM.csv", csvFileName)

write.csv(datatable_col_norm, normCsvFileName, row.names=FALSE)

removeCommand <- paste("rm ", csvFileName, " ;\n", sep="")
print(removeCommand)
system(removeCommand)

cat("\n The normalized-by-column data table has been saved into the ", normCsvFileName, " file \n", sep="")
