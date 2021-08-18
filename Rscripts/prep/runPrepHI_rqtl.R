source("/home/yn259/workspace/GrapeGS/Rscripts/prep/analysisPrep.R")

# rQTL grm
analysisprep(
  outdir="/media/yn259/data/research/HI",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HI/phenos/HIR.csv",
  genofilename = "/media/yn259/data/research/HI/rqtl/grm.maf.txt",
  isGRM = TRUE,
  colFilter = FALSE,
  isBase = FALSE
)

# analysisprep(
#   outdir="/media/yn259/data/research/HI",
#   outfolder = 'rqtl',
#   phenofilename = "/media/yn259/data/research/HI/phenos/HIR.csv",
#   genofilename = "/media/yn259/data/research/HI/rqtl/grm.tabular.txt",
#   isGRM = TRUE,
#   colFilter = FALSE,
#   isBase = FALSE
# )

# rQTL matrix
analysisprep(
  outdir="/media/yn259/data/research/HI",
  outfolder = 'rqtl',
  phenofilename = "/media/yn259/data/research/HI/phenos/HIR.csv",
  genofilename = "/media/yn259/data/research/HI/rqtl/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = FALSE,
  isBase = FALSE
)
