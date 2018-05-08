library("ggplot2")
options(stringsAsFactors=FALSE)

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

  return(var)
}

fileName <- "../data/MesotheliomaDataSet_DicleUniversity_updated_names.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");
sick_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==1,])
healthy_patients_table <- (mesothelioma_datatable[mesothelioma_datatable$class.of.diagnosis==0,])

random_number <- sample(1:1000000, 1)

# Boolean features
# grep("ache.on.chest", colnames(sick_patients_table))
#
# ache.on.chest 11
# asbestos.exposure 4
# cytology.exam.of.pleural.fluid 8
# dead.or.not 29
# dyspnoea 10
# hemoglobin.normality.test 17
# pleural.effusion 30
# pleural.level.of.acidity..pH. 32
# pleural.thickness.on.tomography 31
# weakness: 12

bool_vector <- c(grep("ache.on.chest", colnames(mesothelioma_datatable)), grep("asbestos.exposure", colnames(mesothelioma_datatable))[1], grep("cytology.exam.of.pleural.fluid", colnames(mesothelioma_datatable)), grep("dead.or.not", colnames(mesothelioma_datatable)), grep("dyspnoea", colnames(mesothelioma_datatable)), grep("hemoglobin.normality.test", colnames(mesothelioma_datatable)), grep("pleural.effusion", colnames(mesothelioma_datatable)), grep("pleural.level.of.acidity..pH.", colnames(mesothelioma_datatable)), grep("pleural.thickness.on.tomography", colnames(mesothelioma_datatable)), grep("weakness", colnames(mesothelioma_datatable)))

lun <- length(bool_vector)

fontSize <- 10

# Sick patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/BOOLEAN_barplots_sick_patients_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName)

i=1

sick_plot_list <- list()
for(index in bool_vector){
  temp_df = sick_patients_table
  temp_df$CurrentFeature = sick_patients_table[, index]
  sick_plot_list[[length(sick_plot_list) + 1]] <- ggplot(temp_df, aes(factor(" "), fill=factor(CurrentFeature))) + geom_bar(stat="count", position="stack") + ylim(0,dim(sick_patients_table)[1]) +  scale_fill_discrete(labels=c("no", "yes"))  + labs(x=" ", y=adjust_feature_name(colnames(sick_patients_table[index])))  + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize)) + coord_flip() + theme(legend.title=element_blank()) 

  i <- i+1
}

# sick_plot_list[[1]] <- sick_plot_list[[1]] + ggtitle("mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("grid.arrange", c(sick_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()



# Healthy patients
 
require(gridExtra)
outputPdfFileName <- paste("../results/BOOLEAN_barplots_healthy_patients_vs_", random_number, ".pdf", sep="")
pdf(outputPdfFileName)

i=1

healthy_plot_list <- list()
for(index in bool_vector){
  temp_df = healthy_patients_table
  temp_df$CurrentFeature = healthy_patients_table[, index]
  healthy_plot_list[[length(healthy_plot_list) + 1]] <- ggplot(temp_df, aes(factor(" "), fill=factor(CurrentFeature))) + geom_bar(stat="count", position="stack") + ylim(0,dim(healthy_patients_table)[1]) +  scale_fill_discrete(labels=c("no", "yes")) + labs(x=" ", y=adjust_feature_name(colnames(healthy_patients_table[index])))  + theme(axis.text=element_text(size=fontSize), axis.title=element_text(size=fontSize), legend.text=element_text(size=fontSize), legend.title=element_text(size=fontSize)) + coord_flip() + theme(legend.title=element_blank())

  i <- i+1
}

# healthy_plot_list[[1]] <- healthy_plot_list[[1]] + ggtitle("non-mesothelioma patients: boolean features") + theme(plot.title = element_text(size = fontSize+1, hjust = 0.5))

do.call("grid.arrange", c(healthy_plot_list, ncol=1))
#grid.arrange(sick_plot_list)
dev.off()
