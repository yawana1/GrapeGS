# Mac folder paths
# phenofile = '/Users/yn259/Box/research/HC/phenos/GDD.csv'
# genofile = '/Users/yn259/Box/research/HC/rh/none/matrix.incidence.txt'
# outdir = '/Users/yn259/Box/research/HC'

# Linux folder paths
phenofile = '/media/yn259/data/research/HC/phenos/GDD.csv'
genofile = '/media/yn259/data/research/HC/rh/none/matrix.incidence.txt'
outdir = '/media/yn259/data/research/HC'

traits = c('Diff', 'FB', 'LB')
maf = 0.05
marker.callrate = 0.2
ind.callrate = 0.2
validationFactor = 'Genotype'

library(ASRgenomics)

# 0. Create output folder
outdir = file.path(outdir, "analysis")
dir.create(outdir, showWarnings = FALSE)
setwd(outdir)

# 1. Reading and Filtering a Molecular Dataset
M = read.table(genofile,sep="\t", header=T, row.names = 1)
M = as.matrix(M)
M_filter <- qc.filtering(M = M, base = FALSE, ref = NULL,
                         maf = maf, marker.callrate = marker.callrate, 
                         ind.callrate = ind.callrate, 
                         impute = FALSE,
                         na.string = "-1", 
                         plots = TRUE)

png(file = 'missing.ind.png', width = 1024, height = 1024)
M_filter$plot.missing.ind
dev.off()
png(file = 'missing.SNP.png', width = 1024, height = 1024)
M_filter$plot.missing.SNP
dev.off()
png(file = 'heteroz.png', width = 1024, height = 1024)
M_filter$plot.heteroz
dev.off()
png(file = 'maf.png', width = 1024, height = 1024)
M_filter$plot.maf
dev.off()

# 2. Generating a Kinship Matrix
G <- G.matrix(M = M_filter$M.clean, method = "VanRaden", na.string = NA)$G

# 3. Diagnostics on the Kinship Matrix
check_G <- kinship.diagnostics(K = G)
G_bend <- G.tuneup(G = G, bend = TRUE)$Gb
check_G <- kinship.diagnostics(K = G_bend)
png(file = 'G.diag.png', width = 1024, height = 1024)
check_G$plot.diag
dev.off()
png(file = 'G.offdiag.png', width = 1024, height = 1024)
check_G$plot.offdiag
dev.off()
png(file = 'G.heatmap.png', width = 1024, height = 1024)
kinship.heatmap(K = G_bend, dendrogram = TRUE, row.label = TRUE,
                col.label = TRUE)
dev.off()

# 4. Load phenotypic data
sep = ifelse(endsWith(phenofile, ".csv"), ",", "\t")
P <- read.table(phenofile, sep=sep, header=T)

# 5. Match pheno and geno data
pheno.S <- match.kinship2pheno(K = G_bend, pheno.data = P,
                               indiv = "Genotype", clean = TRUE, mism = TRUE)
pheno.G <- G_bend[pheno.S$matchesK, pheno.S$matchesK]
pheno.P <- P[pheno.S$matchesP, ]
pheno.P$Genotype <- as.factor(pheno.P$Genotype)
pheno.P$Year <- as.factor(pheno.P$Year)
pheno.P$Flower <- as.factor(pheno.P$Flower)

# 6. Get G inverse and sparse form
Ginv.sparse <- G.inverse(G = pheno.G, sparseform = TRUE)$Ginv

# source('/home/yn259/workspace/GrapeGS/Rscripts/GDD/bivar.R')
# mv.A <- bivar(outdir, pheno.P, Ginv.sparse, c('FB', 'LB'))

# 7. Fit model.A
mv.A <- asreml(cbind(FB,LB) ~ trait + trait:Flower              # 1
               , random = ~us(trait):vm(Genotype, Ginv.sparse)                # 2
               + at(trait):Year
               , residual = ~ units:us(trait)                                 # 3
               , na.action = na.method(y = "include")
               , data = pheno.P)

if(mv.A$converge==TRUE){
  pred = predict(mv.A, classify = "Genotype", trace=T)$pvals
  res$prediction[currentFoldPos:(newpos-1)] <- pred$predicted.value[currentFoldPos:(newpos-1)]
  png(file = paste('bivar.A', 'png', sep='.'), width = 1024, height = 1024)
  plot(mv.A)
  dev.off()
}
# diag
# corgh
# xfa1
# us
# rr1
# 1:  Bivariate model of FB & LB, fitting the mean of each and sex as fixed effects
# 2:  Random G structure defined as an unstructured covariance matrix (us). Initial 
#     starting values of va1=1 cov12=0.1 va2=1 
# 3:  Residual (R) structure defined as an unstructured covar matrix, initial starting 
#     values of va1, cov12, va2.

# 8. Fix the value of the covariance to zero (COVA = 0)
mv.Z <- asreml(cbind(FB,LB) ~ trait + trait:Flower                        
               , random = ~diag(trait):vm(Genotype, Ginv.sparse)
               + at(trait):Year
               , residual = ~ units:us(trait)             
               , na.action = na.method(y = "include")
               , data = pheno.P)

# pred = predict(mv, classify = "trait:Genotype", trace=T)$pvals
