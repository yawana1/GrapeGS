source("/home/yn259/workspace/GrapeGS/scripts/prep/analysisPrep.R")

# rQTL grm
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HR/phenos/FruitQuality.csv",
  genofilename = "/media/yn259/data/research/HR/rqtl/grm.maf.txt",
  isGRM = TRUE,
  colFilter = FALSE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HR/phenos/FruitQuality.csv",
  genofilename = "/media/yn259/data/research/HR/rqtl/grm.tabular.txt",
  isGRM = TRUE,
  colFilter = FALSE,
  isBase = FALSE
)

# rQTL matrix
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HR/phenos/FruitQuality.csv",
  genofilename = "/media/yn259/data/research/HR/rqtl/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = FALSE,
  isBase = FALSE
)
