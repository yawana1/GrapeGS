source("/home/yn259/workspace/GrapeGS/scripts/prep/analysisPrep.R")

# rQTL grm
analysisprep(
  outdir="/media/yn259/data/research/HIR",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HIR/phenos/FruitQuality.csv",
  genofilename = "/media/yn259/data/research/HIR/rqtl/grm.maf.txt",
  isGRM = TRUE,
  colFilter = FALSE,
  isBase = FALSE
)

# rQTL matrix
analysisprep(
  outdir="/media/yn259/data/research/HIR",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HIR/phenos/FruitQuality.csv",
  genofilename = "/media/yn259/data/research/HIR/rqtl/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = FALSE,
  isBase = FALSE
)
