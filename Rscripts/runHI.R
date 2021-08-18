source("/home/yaw/workspace/GrapeGS/scripts/GrapeGS2.R")

#------------------------------------------------------------------------------------------------------#
# Population: Horizon_x_Illinois547-1
# Genotypes:  rQTL
#------------------------------------------------------------------------------------------------------#

# Method:     Tabular
grapeGS(
  outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
  phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_disease.txt",
  genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/grm.tabular.txt",
  isGRM = TRUE,
  genoTech = "rQTL",
  matrixMethod = "Tabular"
)

grapeGS(
  outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
  phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_faq.txt",
  genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/grm.tabular.txt",
  isGRM = TRUE,
  genoTech = "rQTL",
  matrixMethod = "Tabular"
)

# Method:     MAF
grapeGS(
  outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
  phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_disease.txt",
  genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/grm.maf.txt",
  isGRM = TRUE,
  genoTech = "rQTL",
  matrixMethod = "MAF_GRM"
)

grapeGS(
  outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
  phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_faq.txt",
  genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/grm.maf.txt",
  isGRM = TRUE,
  genoTech = "rQTL",
  matrixMethod = "MAF_GRM"
)

# Method:     MAF
# grapeGS(
#   outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
#   phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_disease.txt",
#   genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/matrix.M.txt",
#   isGRM = FALSE,
#   genoTech = "MAF",
#   matrixMethod = "MAF"
# )
# 
# grapeGS(
#   outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1",
#   phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_faq.txt",
#   genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/matrix.M.txt",
#   isGRM = FALSE,
#   genoTech = "MAF",
#   matrixMethod = "MAF"
# )
