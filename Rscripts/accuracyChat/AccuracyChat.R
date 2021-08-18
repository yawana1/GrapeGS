accuracychat <- function(outdir, outfile, filenames){
  
  library(uuid)
  outdir = file.path(outdir, "acc_results")
  dir.create(outdir, showWarnings = FALSE)
  setwd(outdir)
  
  for(i in 1:(length(filenames)-1)){
    # i = 5
    X = read.table(filenames[i], header=TRUE, sep='\t')
    xname = tools::file_path_sans_ext(basename(filenames[i]))
    for(j in (i+1):length(filenames)){
      # j = 2
      Y = read.table(filenames[j], header=TRUE, sep='\t')
      yname = tools::file_path_sans_ext(basename(filenames[j]))
      filename = UUIDgenerate(use.time = TRUE, n = 1L)
      # Open PNG file
      png(file = paste(outfile, filename,"png", sep="."),
          width = 1040,
          height = 600
      )
      tmp<-range(c(X$Accuracy,Y$Accuracy), na.rm=TRUE)
      plot(X$Accuracy, Y$Accuracy, 
           xlab=xname, ylab=yname, col=2,
           xlim=tmp,ylim=tmp); abline(a=0,b=1,col=4,lwd=2)
      # Close file
      dev.off()
    }
  }
}



accuracyBoxPlot <- function(outdir, outfile, title,filenames){
  
  library(uuid)
  outdir = file.path(outdir, "accuracy")
  dir.create(outdir, showWarnings = FALSE)
  setwd(outdir)
  
  dat <- data.frame(matrix(ncol = 3, nrow = 0))
  colnames(dat) <- c("Class", "Phenotype", "Accuracy")
  
  for(i in 1:nrow(filenames)){
    filename = filenames[i, 'filename']
    if(file.exists(filename)){
      genoDat = read.table(filename, header=TRUE, sep='\t')
      genoDat = cbind(Class=filenames[i, 'title'], genoDat)
      dat = rbind(dat, genoDat)
    }
  }
  
  library(tidyverse)
  library(hrbrthemes)
  library(viridis)
  accplot = ggplot(dat, aes(x=Class, y=Accuracy, fill=Class)) +
    geom_boxplot() +
    ylim(-0.1, 1.0) +
    scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
    theme_ipsum() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11),
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    ) +
    ggtitle(title) +
    xlab("")
  ggsave(paste(outfile, 'png', sep = '.'), accplot)
}
