# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/tabular"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/haplotype/maf"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/haplotype/no_filters"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/haplotype/missing"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/snp/no_filters"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/snp/maf"

# outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl"
# outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/tabular"
# outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rhampseq/snp/maf"
outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rhampseq/haplotype/maf"

# outdir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/rqtl"
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/GBS/maf"

# outdir = "/home/yaw/Documents/Grape/Chardonnay_x_cinerea/GBS/maf"


inputfilename = "matrix.tabular.txt"
setwd(outdir)

M = read.table(inputfilename, header=TRUE, sep="\t", row.names=1)
M = as.matrix(M)

library(ggplot2)
library(hrbrthemes)
library(otuSummary)
library(tidyverse)
library(viridis)
library(forcats)
library(reshape2)

rownames(M) <- paste('X', rownames(M), sep="")
data = melt(M) 

ggplot(data, aes(Var1, Var2, fill= value)) + 
  geom_tile() +
  scale_fill_gradient(low="white", high="red") +
  theme_ipsum()
