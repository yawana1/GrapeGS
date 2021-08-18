source("/home/yn259/workspace/GrapeGS/scripts/GrapeGS2.R")
source("/home/yn259/workspace/GrapeGS/scripts/asremlCV.R")

#------------------------------------------------------------------------------------------------------#
# Population: RupestrisB38_x_Horizon
# Genotypes:  rQTL
#------------------------------------------------------------------------------------------------------#

# run asremlCV
asremlCV(
  outputdir = "/media/yn259/data/Grape/RupestrisB38_x_Horizon",
  phenofilename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv",
  geno1filename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/rqtl/grm.maf.txt",
  geno2filename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/rqtl/grm.tabular.txt",
)


# run GrapeGS2.R
# Method:     Tabular
# grapeGS(
#   outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon",
#   phenoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv",
#   genoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl/grm.tabular.txt",
#   isGRM = TRUE,
#   genoTech = "rQTL",
#   matrixMethod = "Tabular"
# )

# Method:     MAF
# grapeGS(
#   outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon",
#   phenoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv",
#   genoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl/grm.maf.txt",
#   isGRM = TRUE,
#   genoTech = "rQTL",
#   matrixMethod = "MAF_GRM"
# )

# Method:     MAF
# grapeGS(
#   outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon",
#   phenoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv",
#   genoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl/matrix.M.txt",
#   isGRM = FALSE,
#   genoTech = "rQTL",
#   matrixMethod = "MAF"
# )
