source("/home/yaw/workspace/GrapeGS/scripts/GrapeGS2.R")

basedir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea"
phenodir = "phenos"
genodir = "GBS/maf"
fileList = list.files(path=file.path(basedir, phenodir), pattern = "*.txt")

#------------------------------------------------------------------------------------------------------#
# Population: RupestrisB38_x_Horizon
# Genotypes:  rQTL
#------------------------------------------------------------------------------------------------------#
for(f in fileList){
  # counter = counter + 1
  # sprintf("%s:\t\t%i of %i", f, counter, length(fileList))
  # Method:   Tabular
  grapeGS(
    outdir = basedir,
    phenoFilename = file.path(basedir, phenodir, f),
    genoFilename = file.path(basedir, genodir, "grm.tabular.txt"),
    isGRM = TRUE,
    genoTech = "rhampseq",
    matrixMethod = "Tabular"
  )
  
  # Method:   Incidence_GRM
  grapeGS(
    outdir = basedir,
    phenoFilename = file.path(basedir, phenodir, f),
    genoFilename = file.path(basedir, genodir, "grm.incidence.txt"),
    isGRM = TRUE,
    genoTech = "rhampseq",
    matrixMethod = "Incidence_GRM"
  )
  
  # Method:   Incidence_Matrix
  grapeGS(
    outdir = basedir,
    phenoFilename = file.path(basedir, "phenos", f),
    genoFilename = file.path(basedir, "rqtl/grm.tabular.txt"),
    isGRM = FALSE,
    genoTech = "rhampseq",
    matrixMethod = "Incidence_Matrix"
  )
}