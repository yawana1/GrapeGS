grHist <- function(outdir){
  # library
  library(ggplot2)
  library(dplyr)
  library(hrbrthemes)
  library(tidyverse)
  library(viridis)
  library(forcats)
  
  # outdir = "/media/yn259/data/research/HCR/rh/filtered"
  setwd(outdir)
  # population = "Example Population"
  
  # allele frequencies
  if(file.exists("freq.alleles.txt")){
    freq_allele = read.table("freq.alleles.txt", header=TRUE, sep="\t", na = "NA")
    num_col = ncol(freq_allele) - 1
    png(file = paste("freq.alleles",".png", sep=""),
        width = 1040,
        height = 600
    )
    par(mfrow=c(1, num_col))
    for(i in 1:num_col){
      colname = paste('X', (i-1), sep = "")
      label = paste('Allele', (i-1), sep = ' ')
      hist(as.vector(freq_allele[colname][,]) , xlim=c(0,1) , col="#69b3a2" , xlab=label , ylab="" , main="")
    }
    dev.off()
  }
  
  # hist(as.vector(freq_allele['X0'][,]) , xlim=c(0,1) , col="#69b3a2" , xlab="Allele0" , ylab="" , main="")
  # hist(as.vector(freq_allele['X1'][,]) , xlim=c(0,1) , col="#404080" , xlab="Allele1" , ylab="" , main="")
  # hist(as.vector(freq_allele['X2'][,]) , xlim=c(0,1) , col="#ff4d4d" , xlab="Allele2" , ylab="" , main="")
  # hist(as.vector(freq_allele['X3'][,]) , xlim=c(0,1) , col="#ff80ff" , xlab="Allele3" , ylab="" , main="")
  # ggplot(freq_allele, aes(x=x) ) +
  #   # Top
  #   geom_density( aes(x = Freq1, y = ..count..), fill="#69b3a2", alpha=0.6) +
  #   geom_label( aes(x=1, y=200, label="Allele 0"), color="#69b3a2") +
  #   theme_ipsum() +
  #   xlab("frequency")
  # ggplot(freq_allele, aes(x=x) ) +
  #   # Top
  #   geom_density( aes(x = Freq2, y = ..count..), fill="#404080", alpha=0.6) +
  #   geom_label( aes(x=1, y=200, label="Allele 1"), color="#404080") +
  #   theme_ipsum() +
  #   xlab("frequency")
  # p_X2 <- ggplot(freq_allele, aes(x=x) ) +
  #   # Top
  #   geom_density( aes(x = X2, y = ..count..), fill="#ff4d4d", alpha=0.6) +
  #   geom_label( aes(x=1.5, y=200, label="Allele 2"), color="#ff4d4d") +
  #   theme_ipsum() +
  #   xlab("frequency")
  # p_X3 <- ggplot(freq_allele, aes(x=x) ) +
  #   # Top
  #   geom_density( aes(x = X3, y = ..count..), fill="#ff80ff", alpha=0.6) +
  #   geom_label( aes(x=1.5, y=200, label="Allele 3"), color="#ff80ff") +
  #   theme_ipsum() +
  #   xlab("frequency")
  # p_X0
  # p_X1
  # p_X2
  # p_X3
  
  
  # % missing
  if(file.exists("freq.missing.txt")){
    freq_missing = read.table("freq.missing.txt", header=TRUE, sep="\t", na = "NA")
    freq_missing = filter(freq_missing, Selected == 'TRUE')
    png(file = paste("freq.missing",".png", sep=""),
        width = 1040,
        height = 600
    )
    par(mfrow=c(1,1))
    hist(as.vector(freq_missing['Missing'][,]) , xlim=c(0,1) , col=rgb(1,0,0,0.5) , xlab="frequency" , ylab="" , main="")
    dev.off()
    png(file = paste("freq.missing2",".png", sep=""),
        width = 1040,
        height = 600
    )
    par(mfrow=c(1,1))
    p_missing <- ggplot(freq_missing, aes(x=x) ) +
      # Top
      geom_density( aes(x = Missing, y = ..count..), fill="#404080", alpha=0.6) +
      geom_label( aes(x=1, y=200, label="Missing"), color="#404080") +
      theme_ipsum() +
      xlab("frequency")
    print(p_missing)
    dev.off()
  }
  
  # MAF
  if(file.exists("freq.maf.txt")){
    freq_maf = read.table("freq.maf.txt", header=TRUE, sep="\t", na = "NA")
    png(file = paste("freq.maf",".png", sep=""),
        width = 1040,
        height = 600
    )
    par(mfrow=c(1,1))
    hist(as.vector(freq_maf['MAF'][,]) , xlim=c(0,1) , col="#404080" , xlab="MAF" , ylab="" , main="")
    dev.off()
    png(file = paste("freq.maf2",".png", sep=""),
        width = 1040,
        height = 600
    )
    p_maf <- ggplot(freq_maf, aes(x=x) ) +
      # Top
      geom_density( aes(x = MAF, y = ..count..), fill="#404080", alpha=0.6) +
      geom_label( aes(x=1, y=200, label="MAF"), color="#404080") +
      theme_ipsum() +
      xlab("frequency")
    print(p_maf)
    dev.off()
  }
  
  # Heterozygosity
  # freq_het = read.table("freq.variants.het.txt", header=TRUE, sep="\t", na = "NA")
  # p_het <- ggplot(freq_het, aes(x=x) ) +
  #   # Top
  #   geom_density( aes(x = Hom, y = ..count..), fill="#69b3a2", alpha=0.6) +
  #   geom_label( aes(x=1.5, y=200, label="Hom"), color="#69b3a2") +
  #   # Bottom
  #   geom_density( aes(x = Het, y = -..count..), fill= "#404080", alpha=0.6) +
  #   geom_label( aes(x=1.5, y=-200, label="Het"), color="#404080") +
  #   
  #   # geom_density( aes(x = X2, y = -..density..), fill= "#404080") +
  #   # geom_label( aes(x=4.5, y=0.25, label="allele1"), color="#404080") +
  #   theme_ipsum() +
  #   xlab("frequency")
  # p_het
  
  # LD
  # freq_ld = read.table("freq.variants.ld.txt", header=TRUE, sep="\t", na = "NA", row.names = 1)
  # colIDs = names(freq_ld)
  # colIDs = unique(substring(colIDs, first = 1, last = 3))
  # rowIDs = rownames(freq_ld)
  # rowIDs = unique(substring(rowIDs, first = 1, last = 2))
  
  # for(i in 1:length(rowIDs)){
  # # for(i in 1:1){
  #   row_ex = paste("^",rowIDs[i],sep = "")
  #   col_ex = colIDs[i]
  #   freq = freq_ld[grepl(row_ex, rownames(freq_ld)),grepl(col_ex, names(freq_ld))]
  #   freq[upper.tri(freq, diag=TRUE)] <- NA
  #   freq = as.matrix(freq)
  #   freq = setNames(melt(freq), c('rows', 'vars', 'values'))
  #   freq = freq %>% filter(!is.na(freq$values))
  #   # par(mfrow=c(1,1))
  #   # hist(as.vector(freq_ld['values'][,]) , xlim=c(0,1) , col="#404080" , xlab="LD" , ylab="" , main=population)
  #   
  #   # Give extreme colors:
  #   p <- ggplot(freq, aes(rows, vars, fill= values)) + 
  #     geom_tile() +
  #     scale_fill_gradient(low="white", high="blue") +
  #     theme_ipsum()
  #   print(p + ggtitle(col_ex))
  #   # ggsave(filename = paste("heatmap", rowIDs[1], sep="_"), plot = p)
  # }
  
}
