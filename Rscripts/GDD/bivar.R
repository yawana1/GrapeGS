bivar <- function(outdir, pheno.P, Ginv.sparse, traits){
  library(asreml)
  setwd(outdir)
  
  pheno.P$t1 <- `$`(pheno.P, traits[1])
  pheno.P$t2 <- `$`(pheno.P, traits[2])
  
  # 7. Fit model.A
  mv.A <- asreml(cbind(FB,LB) ~ trait + trait:Flower              # 1
                 , random = ~us(trait):vm(Genotype, Ginv.sparse)                # 2
                 + at(trait):Year
                 , residual = ~ units:us(trait)                                 # 3
                 , na.action = na.method(y = "include")
                 , data = pheno.P)
  
  if(mv.A$converge==TRUE){
    pred = predict(mv.A, classify = "Genotype", trace=T)$pvals
    vpredict(mv.A, h2 ~ V1/(V1 + V2))
    print(vpredict)
    res$prediction[currentFoldPos:(newpos-1)] <- pred$predicted.value[currentFoldPos:(newpos-1)]
    png(file = paste('prediction', i, 'png', sep='.'), width = 1024, height = 1024)
    plot(GBLUP)
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
  
  return(mv.A, mv.Z)
}