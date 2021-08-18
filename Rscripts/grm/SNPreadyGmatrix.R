gmatrix <- function(outdir, infilename, outfilename, base = FALSE){
  # outdir = '/media/yn259/data/research/HIR/gbs/none'
  # infilename = 'matrix.snp.txt'
  # outfilename = 'grm.snp.txt'
  # base = TRUE
  
  library(rgl)
  library(stringr)
  library(plot3D)
  source('~/workspace/GrapeGS/Rscripts/grm/raw.data.R')
  source('~/workspace/GrapeGS/Rscripts/grm/popgen.R')
  source('~/workspace/GrapeGS/Rscripts/grm/G.matrix.R')
  
  setwd(outdir)
  
  data_matrix = read.table(infilename, header=TRUE, sep="\t", row.names=1)
  data_matrix = as.matrix(data_matrix)
  if(base){
    data_matrix[data_matrix == 'NN'] <- NA
    data_matrix[data_matrix == ''] <- NA
    data_matrix[grepl('-', data_matrix, fixed = TRUE)] <- NA
  }else{
    data_matrix[data_matrix == -1] <- NA
  }
  
  # data filtering and imputing
  mrc <- raw.data(data_matrix, frame="wide", base=base, sweep.sample= 1,
                  call.rate=0.1, maf=0.1, imput=TRUE, imput.type="mean", outfile="012", plot=TRUE)
  # View(mrc$M.clean)
  
  # G.matrix
  x <- G.matrix(mrc$M.clean, method = "VanRaden", format = "wide", plot=TRUE, outfilename)
  A <- x$Ga
  D <- x$Gd
  
  write.table(A, file=outfilename, sep="\t", col.names = T, row.names = T, quote = FALSE)
  write.table(D, file=gsub('grm','drm',outfilename), sep="\t", col.names = T, row.names = T, quote = FALSE)
}
