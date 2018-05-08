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


cate_vector <- c(grep("city", colnames(mesothelioma_datatable)), grep("gender", colnames(mesothelioma_datatable)), grep("habit.of.cigarette", colnames(mesothelioma_datatable)), grep("Lung.side", colnames(mesothelioma_datatable)), grep("performance.status", colnames(mesothelioma_datatable)), grep("type.of.MM", colnames(mesothelioma_datatable)))

lun <- length(cate_vector)

fontSize = 10

# Sick patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/CATEGORY_barplots_sick_patients_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

sick_plot_list <- list()
for(index in cate_vector){

  temp_df = sick_patients_table
  temp_df$CurrentFeature = sick_patients_table[, index]
  P_this <- NULL
  
  P_this <- ggplot(temp_df, aes(factor(" "), fill=factor(CurrentFeature))) + geom_bar(stat="count", position="stack") + ylim(0,dim(sick_patients_table)[1])  + labs(x=" ", y=adjust_feature_name(colnames(sick_patients_table[index])))  + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize), legend.key.size=unit(0.3, "cm")) + coord_flip() + theme(legend.title=element_blank()) 
  
  if (index == grep("habit.of.cigarette", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("non", "rare", "regular", "frequent"))
  }
  
  if (index == grep("gender", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("women", "men"))
  }
  
  if (index == grep("performance.status", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("able", "unable"))
  }
  
  if (index == grep("Lung.side", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("left", "right", "both"))
  }
  
  if (index == grep("type.of.MM", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("T1", "T2/T3", "T4"))
  }
  
   sick_plot_list[[length(sick_plot_list) + 1]] <- P_this
  i <- i+1
}

# sick_plot_list[[1]] <- sick_plot_list[[1]] + ggtitle("mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(sick_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()



# Healthy patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/CATEGORY_barplots_healthy_patients_vsy_", random_number, ".pdf", sep="")
pdf(outputPdfFileName, onefile=FALSE)

i=1

healthy_plot_list <- list()
for(index in cate_vector){
  temp_df = healthy_patients_table
  temp_df$CurrentFeature = healthy_patients_table[, index]
  P_this <- NULL
    
  P_this <- ggplot(temp_df, aes(factor(" "), fill=factor(CurrentFeature))) + geom_bar(stat="count", position="stack") + ylim(0,dim(healthy_patients_table)[1]) + labs(x=" ", y=adjust_feature_name(colnames(healthy_patients_table[index])))  + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize), legend.key.size=unit(0.3, "cm")) + coord_flip() + theme(legend.title=element_blank())
  
  if (index == grep("habit.of.cigarette", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("non", "rare", "regular", "frequent"))
  }
  
  if (index == grep("gender", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("women", "men"))
  }
  
  if (index == grep("performance.status", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("able", "unable"))
  }
  
  if (index == grep("Lung.side", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("left", "right", "both"))
  }
  
  if (index == grep("type.of.MM", colnames(mesothelioma_datatable))) {
    P_this <- P_this +  scale_fill_discrete(labels=c("T1", "T2/T3", "T4"))
  }
  
  P_this$width = 20
  
  healthy_plot_list[[length(healthy_plot_list) + 1]] <- P_this
  i <- i+1
}

# healthy_plot_list[[1]] <- healthy_plot_list[[1]] + ggtitle("non-mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("ggarrange", c(healthy_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()
