library("ggplot2")
options(stringsAsFactors=FALSE)

library(gtable)    
library(grid)
library(gridExtra) 
library(egg)



# adjust_feature_name
adjust_feature_name <- function(label_string) {

  var <- gsub("\\.", " ", label_string)
  var <- gsub("PLT", "(PLT)", var)
  var <- gsub("CRP", "(CRP)", var)
  var <- gsub("WBC", "(WBC)", var)
  var <- gsub("ALP", "(ALP)", var)
  var <- gsub("LDH", "(LDH)", var)
  var <- gsub("pH", "(pH)", var)
  var <- gsub("type of MM", "type of malignant mesothelioma", var)
  var <- gsub("C reactive", "C-reactive", var)
  var <- gsub("  ", " ", var)
  var <- gsub("Lung side", "lung side", var)

  return(var)
}



# array_of_real_values_names <- c("albumin", "alkaline phosphatise (ALP)", "lactate dehydrogenase test (LDH)", "C-reactive protein (CRP)", "glucose", "platelet count (PLT)", "pleural albumin", "pleural fluid WBC count", "pleural fluid glucose", "pleural lactic dehydrogenise", "pleural protein", "sedimentation rate", "total protein", "white blood cells (WBC)")

fileName <- "../data/MesotheliomaDataSet_DicleUniversity_updated_names.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");
sick_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==1,])
healthy_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==0,])

random_number <- sample(1:1000000, 1)

real_vector_list <- list()

real_vector_list[[length(real_vector_list) + 1]] <- c( grep("albumin", colnames(mesothelioma_datatable))[1], 
grep("alkaline.phosphatise..ALP.", colnames(mesothelioma_datatable)), 
grep("C.reactive.protein..CRP.", colnames(mesothelioma_datatable)))

real_vector_list[[length(real_vector_list) + 1]] <- c(grep("glucose", colnames(mesothelioma_datatable))[1], 
grep("lactate.dehydrogenase.test", colnames(mesothelioma_datatable)),
grep("platelet.count..PLT.", colnames(mesothelioma_datatable)))

real_vector_list[[length(real_vector_list) + 1]] <- c(grep("pleural.albumin", colnames(mesothelioma_datatable)),
grep("pleural.fluid.WBC.count", colnames(mesothelioma_datatable)), 
grep("pleural.fluid.glucose", colnames(mesothelioma_datatable)))

real_vector_list[[length(real_vector_list) + 1]] <- c(grep("pleural.lactic.dehydrogenise", colnames(mesothelioma_datatable)),
grep("pleural.protein", colnames(mesothelioma_datatable)), 
grep("sedimentation", colnames(mesothelioma_datatable)))

real_vector_list[[length(real_vector_list) + 1]] <- c(grep("total.protein", colnames(mesothelioma_datatable)) ,
grep("white.blood.cells..WBC.", colnames(mesothelioma_datatable)))


feature_group_index <- 5
real_vector <- real_vector_list[[feature_group_index]]
lun <- length(real_vector)



fontSize <- 20
max_y <- 20

cat("Number of features = ", lun, "\n")

# Sick patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/REAL_histograms_sick_patients_vect",feature_group_index,"_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

sick_plot_list <- list()
for(index in real_vector){

  sick_patients_table$CurrentFeature = sick_patients_table[, index]
  P_this <- NULL
  feature_label <- colnames(mesothelioma_datatable[index])
  
  cat("i=",i," ", feature_label, "\n")
  
  P_this <- sick_patients_histo <- ggplot(sick_patients_table, aes(x=CurrentFeature)) + geom_histogram(fill="#CC79A7", binwidth=1) + labs(x=adjust_feature_name(feature_label), y="#patients") + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize)) + theme(legend.title=element_blank()) + ylim(0,max_y) 
  
  sick_plot_list[[length(sick_plot_list) + 1]] <- P_this
  i <- i+1
}

# sick_plot_list[[1]] <- sick_plot_list[[1]] + ggtitle("mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(sick_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()



# Healthy patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/REAL_histograms_healthy_patients_vect",feature_group_index,"_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

healthy_plot_list <- list()
for(index in real_vector){

  healthy_patients_table$CurrentFeature = healthy_patients_table[, index]
  P_this <- NULL
  
  feature_label <- colnames(mesothelioma_datatable[index])
  cat("i=",i," ", feature_label, "\n")
    
  P_this <- sick_patients_histo <- ggplot(healthy_patients_table, aes(x=CurrentFeature)) + geom_histogram(fill="#009E73", binwidth=1) + labs(x=adjust_feature_name(feature_label), y="#patients")  + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize)) + theme(legend.title=element_blank()) + ylim(0,max_y) 
  
  healthy_plot_list[[length(healthy_plot_list) + 1]] <- P_this
  i <- i+1
}

# healthy_plot_list[[1]] <- healthy_plot_list[[1]] + ggtitle("non-mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(healthy_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()
