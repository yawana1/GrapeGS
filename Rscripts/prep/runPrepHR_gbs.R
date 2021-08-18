source("/home/yn259/workspace/GrapeGS/Rscripts/prep/analysisPrep.R")

# GBS Filtered
#GRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

#DRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# matrix
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/filtered/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)



# GBS Not-Filtered
# GRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# DRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# matrix
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'gbs.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/gbs/none/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

# GBS MAF matrix
# source("/home/yn259/workspace/GrapeGS/scripts/prep/MAFmatrix.R")
# MAFmatrix(
#   outdir = '/media/yn259/data/research/HR/gbs/none',
#   infile = '/media/yn259/data/research/HR/gbs/genotype.vcf',
#   mfreq = 1,
#   afreq = 0
# )
# 
# MAFmatrix(
#   outdir = '/media/yn259/data/research/HR/gbs/filtered',
#   infile = '/media/yn259/data/research/HR/gbs/genotype.vcf',
#   mfreq = 0.1,
#   afreq = 0.2
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'gbs.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/gbs/none/matrix.maf.txt",
#   isGRM = FALSE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'gbs.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/gbs/none/grm.maf.txt",
#   isGRM = TRUE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'gbs.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/gbs/filtered/matrix.maf.txt",
#   isGRM = FALSE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'gbs.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/gbs/filtered/grm.maf.txt",
#   isGRM = TRUE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
