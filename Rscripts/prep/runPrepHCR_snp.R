source("/home/yn259/workspace/GrapeGS/Rscripts/prep/analysisPrep.R")

# snp Filtered
# GRM
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)
 
# DRM
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)


# matrix
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/filtered/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)



# snp Not-Filtered
# GRM
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# DRM
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)


# matrix
analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HCR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HCR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HCR/snp/none/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)
