library(vcfR)
library(reshape2)

majorallele <- function(vec){
  # vec = gt[i,]
  vec2 = colsplit(vec, '/', c('allele1', 'allele2'))
  res = table(vec2, useNA = 'no', exclude = c(NA, NaN, '.'))
  
  if(ncol(res) >= nrow(res)){
    tabcol = ncol(res)
    tab = matrix(0, ncol = tabcol, nrow = 1)
    colnames(tab) = colnames(res)
  }else{
    tabcol = nrow(res)
    tab = matrix(0, ncol = tabcol, nrow = 1)
    colnames(tab) = rownames(res)
  }
  
  for(c in colnames(tab)){
    if(c == ''){
      next
    }
    total = 0
    total = total + ifelse(c %in% rownames(res), sum(res[c, ]), 0)
    total = total + ifelse(c %in% colnames(res), sum(res[, c]), 0)
    tab[1,c] = tab[1,c] + total
  }
  
  return(colnames(tab)[which.max(tab)])
}

MAFmatrix <- function(outdir, 
                      infile,
                      mfreq = 1,
                      afreq = 0){
  outdir = '/media/yn259/data/research/HI/snp/none'
  infile = '/media/yn259/data/research/HI/snp/genotype.vcf'
  mfreq = 1
  afreq = 0
  
  setwd(outdir)
  vcf <- read.vcfR(infile, checkFile = TRUE, verbose = FALSE)
  
  gt <- extract.gt(vcf,element = "GT",
                   as.numeric = FALSE,
                   return.alleles = FALSE,
                   IDtoRowNames = TRUE,
                   extract = TRUE,
                   convertNA = TRUE
  )
  hets <- is_het(gt, na_is_false = FALSE)
  summary <- maf(vcf, element = 2)
  
  # filter data by maf and missing frequency
  c = ncol(gt)
  if(afreq > 0){
    summary = summary[summary[, 'Frequency'] >= afreq,]  
  }
  if(mfreq < 1){
    summary = summary[summary[, 'NA']/c <= mfreq,]  
  }
  if(nrow(summary) < nrow(gt)){
    gt <- subset(gt, rownames(gt) %in% rownames(summary))
    hets <- subset(hets, rownames(hets) %in% rownames(summary))
  }
  
  # create output matrix
  r = nrow(gt)
  G = matrix(, nrow = r, ncol = c)
  colnames(G) = colnames(gt)
  rownames(G) = rownames(gt)
  
  # loop matrix and convert to maf count
  for(i in 1:r){
    # i = 45
    mallele = majorallele(gt[i,])
    for(j in 1:c){
      # j = 358
      if(is.na(hets[i,j])){
        next
      }else if(hets[i,j]){
        G[i,j] = 1
      }else{
        snp = strsplit(gt[i,j], '/')
        if(snp[[1]][1] == mallele){
          G[i,j] = 0
        }else{
          G[i,j] = 2
        }
      }
    }
  }
  
  G <- t(G)
  # save Maf matrix to file
  write.table(G, file = 'matrix.maf.txt', sep = '\t', col.names = TRUE, row.names = TRUE, quote = FALSE, na = '')
  
  # create GRM and save to file
  library(rgl)
  library(stringr)
  library(plot3D)
  source('~/workspace/GrapeGS/scripts/raw.data.R')
  source('~/workspace/GrapeGS/scripts/popgen.R')
  source('~/workspace/GrapeGS/scripts/G.matrix.R')
  
  mrc <- raw.data(G, frame="wide", base=FALSE, imput=TRUE, imput.type="mean", outfile="012")
  grm <- G.matrix(mrc$M.clean, method = "VanRaden", format = "wide", plot=FALSE)
  write.table(grm$Ga, file='grm.maf.txt', sep="\t", col.names = T, row.names = T, quote = FALSE) 
}




