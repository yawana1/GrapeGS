source("/home/yn259/workspace/GrapeGS/Rscripts/prep/analysisPrep.R")

# snp Filtered
# GRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# DRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)


# matrix
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.filtered',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)



# snp Not-Filtered
# GRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/grm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/grm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/grm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# DRM
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/drm.incidence.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/drm.snp.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/drm.maf.txt",
  isGRM = TRUE,
  colFilter = TRUE,
  isBase = FALSE
)

# matrix
analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/matrix.incidence.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/matrix.snp.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = TRUE
)

analysisprep(
  outdir="/media/yn259/data/research/HR",
  outfolder = 'snp.none',
  phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
  genofilename = "/media/yn259/data/research/HR/snp/none/matrix.maf.txt",
  isGRM = FALSE,
  colFilter = TRUE,
  isBase = FALSE
)


























# source("/home/yn259/workspace/GrapeGS/scripts/prep/analysisPrep.R")
# 
# # snp Filtered grm
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.incidence.txt",
#   isGRM = TRUE,
#   colFilter = FALSE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.tabular.txt",
#   isGRM = TRUE,
#   colFilter = FALSE,
#   isBase = FALSE
# )
# 
# # snp Filtered matrix
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.incidence.txt",
#   isGRM = FALSE,
#   colFilter = FALSE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.snp.txt",
#   isGRM = FALSE,
#   colFilter = FALSE,
#   isBase = TRUE
# )
# 
# # snp Not-Filtered grm
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/none/grm.tabular.txt",
#   isGRM = TRUE,
#   colFilter = FALSE,
#   isBase = FALSE
# )
# 
# # snp Not-Filtered matrix
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/none/matrix.incidence.txt",
#   isGRM = FALSE,
#   colFilter = FALSE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/none/matrix.snp.txt",
#   isGRM = FALSE,
#   colFilter = FALSE,
#   isBase = TRUE
# )
# 
# # snp MAF matrix
# source("/home/yn259/workspace/GrapeGS/scripts/prep/MAFmatrix.R")
# MAFmatrix(
#   outdir = '/media/yn259/data/research/HR/snp/none',
#   infile = '/media/yn259/data/research/HR/snp/genotype.vcf',
#   mfreq = 1,
#   afreq = 0
# )
# 
# MAFmatrix(
#   outdir = '/media/yn259/data/research/HR/snp/filtered',
#   infile = '/media/yn259/data/research/HR/snp/genotype.vcf',
#   mfreq = 0.1,
#   afreq = 0.2
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/none/matrix.maf.txt",
#   isGRM = FALSE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.none',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/none/grm.maf.txt",
#   isGRM = TRUE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/matrix.maf.txt",
#   isGRM = FALSE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
# 
# analysisprep(
#   outdir="/media/yn259/data/research/HR",
#   outfolder = 'snp.filtered',
#   phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt",
#   genofilename = "/media/yn259/data/research/HR/snp/filtered/grm.maf.txt",
#   isGRM = TRUE,
#   colFilter = TRUE,
#   isBase = FALSE
# )
