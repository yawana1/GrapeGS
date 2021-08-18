source("/Users/yn259/Documents/Robbins-Lab/Grape/scripts/GrapeCV.R")

basedir = "/Users/yn259/Documents/Robbins-Lab/Grape/Horizon_x_Cinerea/output/hcallsporcv"
pheno_filenames = list.files(path = basedir, pattern = "pheno*", all.files = FALSE,
                       full.names = FALSE, recursive = FALSE,
                       ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)

# library(hash)
# lst_acc <- hash()
# for(item in pheno_filenames){
#   pheno_filename = paste(basedir,item, sep="/")
#   geno_filename = paste(basedir, sub("pheno","geno", item), sep="/")
#   acc <- crossvalidation(pheno_filename, geno_filename)
#   lst_acc[[item]] <- acc
# }
# lst_acc

library(foreach)
library(doParallel)
cores=detectCores()
cl <- makeCluster(cores[1]-2)
registerDoParallel(cl)
finalMatrix <- foreach(item = iter(pheno_filenames), .combine=cbind) %dopar% {
  pheno_filename = paste(basedir,item, sep="/")
  geno_filename = paste(basedir, sub("pheno","geno", item), sep="/")
  acc <- crossvalidation(pheno_filename, geno_filename)
  c(item,acc)
}
#stop cluster
stopCluster(cl)

# mat1 <- matrix(pheno_filenames)
mat <- t(finalMatrix)
# mat <- cbind(mat1, mat2)
write.table(mat, file = paste(basedir, "results_BRR.txt", sep="/"), sep = "\t")
