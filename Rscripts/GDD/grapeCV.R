grapeCV <- function(outdir, P, G, traits){
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
}