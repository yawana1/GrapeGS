phenofile = '/Users/yn259/Box/research/HC/phenos/GDD.csv'
genofile = '/Users/yn259/Box/research/HC/rh/none/matrix.incidence.txt'
outdir = '/Users/yn259/Box/research/HC'
traits = c('Diff', 'FB', 'LB')
maf = 0.05
marker.callrate = 0.2
ind.callrate = 0.2
validationFactor = 'Genotype'

library(ASRgenomics)
library(asreml)

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
P_meta <- P[,!names(P) %in% traits]
for(tr in traits){
  tr = 'Diff'
  traitdir = file.path(outdir, tr)
  dir.create(traitdir, showWarnings = FALSE)
  setwd(traitdir)
  
  # 5. Match pheno and geno data
  pheno.P <- P_meta
  pheno.P$trait <- P[,tr]
  pheno.P = pheno.P[!is.na(pheno.P[, 'trait']),]
  pheno.S <- match.kinship2pheno(K = G_bend, pheno.data = pheno.P,
                                 indiv = "Genotype", clean = TRUE, mism = TRUE)
  pheno.P <- pheno.P[pheno.S$matchesP, ]
  pheno.G <- G_bend[pheno.S$matchesK, pheno.S$matchesK]
  
  # 6. Get G inverse and sparse form
  Ginv.sparse <- G.inverse(G = pheno.G, sparseform = TRUE)$Ginv
  
  # 7. Cross validation
  pheno.P$Genotype <- as.factor(pheno.P$Genotype)
  pheno.P$Year <- as.factor(pheno.P$Year)
  pheno.idv <- unique(pheno.P[, validationFactor])
  nLines = length(pheno.idv)
  foldSize=floor(nLines/(10))
  currentFoldPos=1
  res <- data.frame(Genotype = pheno.idv, prediction = numeric(nLines))
  for(i in c(1:10)){
    i = 1
    Y <- pheno.P
    newpos <- min(currentFoldPos+foldSize, nLines+1)
    idv <- pheno.idv[currentFoldPos:(newpos-1)]
    Y$trait[Y$Genotype %in% idv] <- NA
    # Y$trait[currentFoldPos:(newpos-1)] <- NA
    GBLUP <- asreml(fixed = trait ~ Year+Flower, random = ~vm(Genotype, Ginv.sparse),
                    residual = ~idv(units), na.action = na.method(y = "include"),
                    data = Y)
    if(GBLUP$converge==TRUE){
      pred = predict(GBLUP, classify = "Genotype", trace=T)$pvals
      vpredict(GBLUP, h2 ~ V1/(V1 + V2))
      res$prediction[currentFoldPos:(newpos-1)] <- pred$predicted.value[currentFoldPos:(newpos-1)]
      png(file = paste('prediction', i, 'png', sep='.'), width = 1024, height = 1024)
      plot(GBLUP)
      dev.off()
    }
  }
}



# 7. Fit a Genomic-BLUP (GBLUP) model with ASReml-R
pheno.P$Genotype <- as.factor(pheno.P$Genotype)
pheno.P$Year <- as.factor(pheno.P$Year)
GBLUP <- asreml(fixed = Diff ~ Year, random = ~vm(Genotype, Ginv.sparse),
                residual = ~idv(units), na.action = na.method(y = "include"),
                data = pheno.P)
if(GBLUP$converge==TRUE){
  pred = predict(GBLUP, classify = "Genotype", trace=T)$pvals
}
