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
  var <- gsub("pH", "(pH)", var)
  var <- gsub("type of MM", "type of malignant mesothelioma", var)
  var <- gsub("C reactive", "C-reactive", var)
  var <- gsub("  ", " ", var)
  var <- gsub("Lung side", "lung side", var)

  return(var)
}

fileName <- "../data/MesotheliomaDataSet_DicleUniversity_updated_names.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");
sick_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==1,])
healthy_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==0,])

random_number <- sample(1:1000000, 1)

time_vector <- c(grep("age", colnames(mesothelioma_datatable)), grep("duration.of.asbestos.exposure", colnames(mesothelioma_datatable)), grep("duration.of.symptoms", colnames(mesothelioma_datatable)))

lun <- length(time_vector)

fontSize <- 20
max_y <- 20

# Sick patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/TIME_histograms_sick_patients_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

sick_plot_list <- list()
for(index in time_vector){

  sick_patients_table$CurrentFeature = sick_patients_table[, index]
  P_this <- NULL
  feature_label <- colnames(mesothelioma_datatable[index])
  
  print(feature_label)
  
  P_this <- ggplot(sick_patients_table, aes(x=CurrentFeature)) + geom_histogram(fill="#CC79A7", binwidth=1) + labs(x=adjust_feature_name(feature_label), y="#patients") + ylim(0,max_y) 
  
  sick_plot_list[[length(sick_plot_list) + 1]] <- P_this
  i <- i+1
}

# sick_plot_list[[1]] <- sick_plot_list[[1]] + ggtitle("mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(sick_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()



# Healthy patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/TIME_histograms_healthy_patients_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

healthy_plot_list <- list()
for(index in time_vector){

  healthy_patients_table$CurrentFeature = healthy_patients_table[, index]
  P_this <- NULL
  feature_label <- colnames(mesothelioma_datatable[index])
    
  P_this <- ggplot(healthy_patients_table, aes(x=CurrentFeature)) + geom_histogram(fill="#009E73", binwidth=1) + labs(x=adjust_feature_name(feature_label), y="#patients")  + ylim(0,max_y) 
  
  healthy_plot_list[[length(healthy_plot_list) + 1]] <- P_this
  i <- i+1
}

# healthy_plot_list[[1]] <- healthy_plot_list[[1]] + ggtitle("non-mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(healthy_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()
