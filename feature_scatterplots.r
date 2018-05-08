
library("ggplot2");

x_artifical_maximum<-1000

fileName <- "../data/MesotheliomaDataSet_DicleUniversity.csv"
mesothelioma_datatable <- read.csv(fileName, header = TRUE, sep =",");

random_number <- sample(1:1000000, 1)

outputPdfFileName <- paste("../results/plot_plateletCount_vs_lungSide_",random_number,".pdf",sep="")
# pdf(outputPdfFileName, 20, 10)


P_this <- NULL

font_size <- 20

P_this = ggplot(mesothelioma_datatable, aes(x=mesothelioma_datatable$"platelet.count..PLT.", y=keep.side, colour=factor(class.of.diagnosis))) + labs(color="patients") + scale_color_manual(labels = c("mesothelioma", "non-mesothelioma"), values = c("blue", "red")) + xlim(0, x_artifical_maximum) + labs(x = "platelet count (PLT) kiloplatelets/microliter", y = "lung side") + geom_vline(xintercept = 150, colour="green4", linetype = "dotted", size=2) + geom_jitter(height = 0.05) + theme(axis.text=element_text(size=font_size), axis.title=element_text(size=font_size), legend.text=element_text(size=font_size), legend.title=element_text(size=font_size))

# P_this = ggplot(mesothelioma_datatable, aes(x=mesothelioma_datatable$"platelet.count..PLT.", y=keep.side, colour=factor(class.of.diagnosis))) + labs(color="patients") + scale_color_manual(labels = c("mesothelioma", "non-mesothelioma"), values = c("blue", "red")) + geom_point(size = 3, alpha=0.4)  + xlim(0, x_artifical_maximum) + labs(x = "platelet count (PLT)", y = "lung side") + geom_vline(xintercept = 150, colour="green4", linetype = "dotted", size=2)

cat("Printed ",outputPdfFileName, "\n\n")
ggsave(outputPdfFileName, P_this, width=40, height=20, units="cm")
