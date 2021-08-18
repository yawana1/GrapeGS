source("/home/yn259/workspace/GrapeGS/Rscripts/accuracyChat/AccuracyChat.R")

# Incidence GRM
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/grm.incidence.gbs.filtered/grm.incidence.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.incidence.gbs.none/grm.incidence.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.incidence.rh.filtered/grm.incidence.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.incidence.rh.none/grm.incidence.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.incidence.snp.filtered/grm.incidence.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.incidence.snp.none/grm.incidence.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.rqtl/grm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered', 
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'grm.incidence',
  title = 'Incidence GRM (GBLUP)',
  filenames
)

# MAF GRM
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/grm.maf.gbs.filtered/grm.maf.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.gbs.none/grm.maf.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.rh.filtered/grm.maf.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.rh.none/grm.maf.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.snp.filtered/grm.maf.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.snp.none/grm.maf.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.rqtl/grm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'grm.maf',
  title = 'MAF GRM (GBLUP)',
  filenames
)

# SNP GRM
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/grm.snp.gbs.filtered/grm.snp.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.snp.gbs.none/grm.snp.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.snp.rh.filtered/grm.snp.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.snp.rh.none/grm.snp.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.snp.snp.filtered/grm.snp.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.snp.snp.none/grm.snp.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/grm.maf.rqtl/grm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'grm.snp',
  title = 'SNP GRM (GBLUP)',
  filenames
)

# Incidence drm
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/drm.incidence.gbs.filtered/drm.incidence.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.incidence.gbs.none/drm.incidence.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.incidence.rh.filtered/drm.incidence.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.incidence.rh.none/drm.incidence.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.incidence.snp.filtered/drm.incidence.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.incidence.snp.none/drm.incidence.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.rqtl/drm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered', 
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'drm.incidence',
  title = 'Incidence drm (GBLUP)',
  filenames
)

# MAF drm
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/drm.maf.gbs.filtered/drm.maf.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.gbs.none/drm.maf.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.rh.filtered/drm.maf.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.rh.none/drm.maf.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.snp.filtered/drm.maf.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.snp.none/drm.maf.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.rqtl/drm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'drm.maf',
  title = 'MAF drm (GBLUP)',
  filenames
)

# SNP drm
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/drm.snp.gbs.filtered/drm.snp.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.snp.gbs.none/drm.snp.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.snp.rh.filtered/drm.snp.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.snp.rh.none/drm.snp.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.snp.snp.filtered/drm.snp.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.snp.snp.none/drm.snp.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/drm.maf.rqtl/drm.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'drm.snp',
  title = 'SNP drm (GBLUP)',
  filenames
)

# Tabular GRM
# filenames = matrix(c(
#   '/media/yn259/data/research/HC/analysis/grm.tabular.gbs.filtered/grm.tabular.gbs.filtered.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.gbs.none/grm.tabular.gbs.none.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.rh.filtered/grm.tabular.rh.filtered.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.rh.none/grm.tabular.rh.none.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.snp.filtered/grm.tabular.snp.filtered.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.snp.none/grm.tabular.snp.none.acc.txt',
#   '/media/yn259/data/research/HC/analysis/grm.tabular.rqtl/grm.tabular.rqtl.acc.txt',
#   'GBS', 'GBS unfiltered',
#   'rHampseq', 'rHampseq unfiltered',
#   'SNP', 'SNP unfiltered', 
#   'rQTL'
# ), ncol=2)
# colnames(filenames) = c('filename', 'title')
# accuracyBoxPlot(
#   outdir = '/media/yn259/data/research/HC/analysis/',
#   outfile = 'grm.tabular',
#   title = 'Tabular GRM (GBLUP)',
#   filenames
# )

# Incidence matrix
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/matrix.incidence.gbs.filtered/matrix.incidence.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.incidence.gbs.none/matrix.incidence.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.incidence.rh.filtered/matrix.incidence.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.incidence.rh.none/matrix.incidence.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.incidence.snp.filtered/matrix.incidence.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.incidence.snp.none/matrix.incidence.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.rqtl/matrix.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered', 
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'matrix.incidence',
  title = 'Incidence matrix (BRR)',
  filenames
)

# MAF matrix
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/matrix.maf.gbs.filtered/matrix.maf.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.gbs.none/matrix.maf.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.rh.filtered/matrix.maf.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.rh.none/matrix.maf.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.snp.filtered/matrix.maf.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.snp.none/matrix.maf.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.rqtl/matrix.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'matrix.maf',
  title = 'MAF matrix (BRR)',
  filenames
)

# SNP matrix
filenames = matrix(c(
  '/media/yn259/data/research/HC/analysis/matrix.snp.gbs.filtered/matrix.snp.gbs.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.snp.gbs.none/matrix.snp.gbs.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.snp.rh.filtered/matrix.snp.rh.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.snp.rh.none/matrix.snp.rh.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.snp.snp.filtered/matrix.snp.snp.filtered.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.snp.snp.none/matrix.snp.snp.none.acc.txt',
  '/media/yn259/data/research/HC/analysis/matrix.maf.rqtl/matrix.maf.rqtl.acc.txt',
  'GBS', 'GBS unfiltered',
  'rHampseq', 'rHampseq unfiltered',
  'SNP', 'SNP unfiltered',
  'rQTL'
), ncol=2)
colnames(filenames) = c('filename', 'title')
accuracyBoxPlot(
  outdir = '/media/yn259/data/research/HC/analysis/',
  outfile = 'matrix.snp',
  title = 'SNP matrix (BRR)',
  filenames
)
