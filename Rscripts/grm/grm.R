grm <- function(outdir, genoFilename, freqFilename, outfilename, population){
  # outdir = "/home/yn259/ExpanDrive/Cornell/research/xyz_example/filtered"
  # genoFilename = "matrix.M.txt"
  # freqFilename = "matrix.P.txt"
  # inputfilename = "matrix.tabulate.txt"
  # outfilename = "grm.maf.txt"
  # population = "Horizon_x_Illinois547-1"
  
  setwd(outdir)
  # read MAF matrix and format
  M = read.table(genoFilename, header=TRUE, sep="\t", row.names=1)
  M = as.matrix(M)
  M = M - 1
  # read P matrix and format
  P = read.table(freqFilename, header=TRUE, sep="\t", row.names=1)
  P = as.matrix(P)
  Q = 2 * (P - 0.5)
  # Z matrix
  Z = M - Q
  ZZ = Z %*% t(Z)
  
  # calculate denomicator of G matrix
  p = 0
  f = 0
  for (i in P[1,]){
    p = p + (i * (1 - i))
    f = f + i
  }
  
  # G matrix
  G =  ZZ / (2 * p)
  write.table(G, file=outfilename, row.names=TRUE, col.names=TRUE, sep="\t")
  rownames(G) <- paste('X', rownames(G), sep="")
  colnames(G) <- paste('Y', colnames(G), sep="")
  
  library(ggplot2)
  library(hrbrthemes)
  library(otuSummary)
  library(tidyverse)
  library(viridis)
  library(forcats)
  library(reshape2)
  
  
  data = matrixConvert(G, colname=c('X', 'Y', 'Z'))
  data1 = melt(G) 
  
  png(file = paste("grm.maf",".png", sep=""),
      width = 1040,
      height = 600
  )

  myplot <- ggplot(data1, aes(Var1, Var2, fill= value)) +
    geom_tile() +
    scale_fill_gradient(low="white", high="red") +
    theme_ipsum()
  
  # myplot <- ggplot(data, aes(X, Y, fill= Z, text=population)) + 
  #   geom_tile() +
  #   scale_fill_gradient(low="white", high="blue") +
  #   theme_ipsum()
  print(myplot)
  dev.off()
  
  # Chi-square test
  # counts = as.data.frame(table(M))
}
