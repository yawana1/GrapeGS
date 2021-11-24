###############################
# Genomic Selection           #
# K-fold cross-validation     #
###############################

rm(list = ls())

# linux input parameters
analysis_name = 'rh_hap.matrix.incidence'
phenofile = '/media/yn259/data/research/HC/phenos/GDD.csv'
genofile = '/media/yn259/data/research/HC/rh/none/matrix.incidence.txt'
outdir = '/media/yn259/data/research/HC'
isBase = FALSE
marker.callrate = 0.1
ind.callrate = 0.1
maf = 0.05
traits = c('FB', 'LB', 'Diff')

# 0. create output folder
outdir = file.path(outdir, 'analysis')
dir.create(outdir, showWarnings = FALSE)
outdir = file.path(outdir, analysis_name)
dir.create(outdir, showWarnings = FALSE)
setwd(outdir)

library(ASRgenomics)

# 1. Read and Filter molecular dataset
M = read.table(file=genofile, header=TRUE)
dim(M)  # 157x6723
M[1:5,1:5]

M = as.matrix(M)
M_filter <- qc.filtering(M = M, base = FALSE, ref = NULL,
                         maf = maf, marker.callrate = marker.callrate, 
                         ind.callrate = ind.callrate, 
                         impute = FALSE,
                         na.string = "-1", 
                         plots = TRUE)

# A total of 47232 values were identified as missing with the string -1 and were replaced by NA.
# Initial marker matrix M contains 157 individuals and 6723 markers.
# A total of 487 markers were removed because their proportion of missing values was equal or larger than 0.2.
# A total of 31 markers were removed because their MAF was smaller than 0.05.
# A total of 0 individuals were removed because their proportion of missing values was equal or larger than 0.2.
# Final cleaned marker matrix M contains 157 individuals and 6209 markers.
100*47232/(157*6723)  # 4.47% missing

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
G <- G.matrix(M = M_filter$M.clean, method = "Yang", na.string = NA)$G

# 3. Diagnostics on the Kinship Matrix
check_G <- kinship.diagnostics(K = G)
#G_bend <- G.tuneup(G = G, bend = TRUE)$Gb
# check_G <- kinship.diagnostics(K = G_bend)
png(file = 'G.diag.png', width = 1024, height = 1024)
check_G$plot.diag  
dev.off()
png(file = 'G.offdiag.png', width = 1024, height = 1024)
check_G$plot.offdiag
dev.off()
png(file = 'G.heatmap.png', width = 1024, height = 1024)
kinship.heatmap(K = G, dendrogram = TRUE, row.label = TRUE,
                col.label = TRUE)
dev.off()

# Matrix dimension is: 157x157
# Rank of matrix is: 156
# Range diagonal values: 0.65556 to 1.27991
# Mean diagonal values: 0.72459
# Range off-diagonal values: -0.98166 to 0.27473
# Mean off-diagonal values: -0.00464
# There are 154 extreme diagonal values, outside < 0.8 and > 1.2
# There are 0 records of possible duplicates, based on: K(i,j)/sqrt[K(i,i)*K(j,j)] >  0.95

# Notes:
# The mean diagonal values are much smaller than 1, hence, there are issues with the matrix.
# There are only 2 values that are large in the diagonal, this is also strange (but n=157 only)
# There is a -1 in the off-diagonal that needs to be eliminated.

ls(check_G)
View(G)
min(G[,87])
which.min(G[,87])
G[87:88,87:88]

#             Horizon VcinereaB9
# Horizon     1.1508296 -0.9816594
# VcinereaB9 -0.9816594  1.2799132
# Note: all problems in this matrix are here... 

# Dropping Horizon and VcinereaB9
G <- G[-c(87:88),-c(87:88)]
dim(G)

# Now bending
G_bend <- G.tuneup(G = G, bend = TRUE)$Gb
check_G <- kinship.diagnostics(K = G_bend)
check_G$plot.diag  
check_G$plot.offdiag

# Note: off-diagonal much better.
# Note: diagonals still with a strong bias,
# Note: but much better conditional number.

# 4. Load phenotypic data
sep = ifelse(endsWith(phenofile, ".csv"), ",", "\t")
P <- read.table(phenofile, sep=sep, header=T)
# P <- phenofile

# 5. Match pheno and geno data
pheno.S <- match.kinship2pheno(K = G_bend, pheno.data = P,
                               indiv = "Genotype", clean = TRUE, mism = TRUE)
pheno.G <- G_bend[pheno.S$matchesK, pheno.S$matchesK]
pheno.P <- P[pheno.S$matchesP, ]
dim(pheno.P)

pheno.P$Genotype <- as.factor(pheno.P$Genotype)
pheno.P$Year <- as.factor(pheno.P$Year)
pheno.P$Flower <- as.factor(pheno.P$Flower)
pheno.P$rrep <- as.factor(pheno.P$rrep)
length(levels(pheno.P$Genotype)) # 137

# 6. Get G inverse and sparse form
Ginv.sparse <- G.inverse(G = pheno.G, sparseform = TRUE)$Ginv
head(Ginv.sparse)

# Note: this looks reasonable


str(pheno.P)

# 7. Fit model.A
library(asreml)
# mv.A <- asreml(cbind(FB,LB) ~ trait + trait:Flower            
#                , random = ~us(trait):vm(Genotype, Ginv.sparse)                
#                + at(trait):Year
#                , residual = ~ id(units):us(trait)                               
#                , na.action = na.method(y = "include")
#                , data = pheno.P)


# Trying univariate first to check
pheno.P <- pheno.P[order(pheno.P$Year),]

ub.1 <- asreml(FB ~ 1 + Flower            
               , random = ~Year + vm(Genotype, Ginv.sparse)             
               , residual = ~ idv(units)
               , workspace = 128e06
               , na.action = na.method(y = "include")
               , data = pheno.P)
summary(ub.1)$varcomp
(h2.1 <- vpredict(ub.1, h2.1 ~ V2 / (V1 + V2 + V3)))

ub.2 <- asreml(FB ~ 1 + Flower            
               , random = ~us(Year):vm(Genotype, Ginv.sparse)             
               , residual = ~ dsum(~idv(units)|Year)
               , workspace = 128e06
               , na.action = na.method(y = "include")
               , data = pheno.P)
ub.2 <- update.asreml(ub.2)
summary(ub.A)$varcomp
(h2.2 <- vpredict(ub.2, h2.1 ~ (V1+V2+V3+V4+V5+V6) / (V1+V2+V3+V4+V5+V6+V7+V8+V9)))

# Changing to corgh for clarity
ub.A <- asreml(FB ~ 1 + Flower            
               , random = ~corgh(Year):vm(Genotype, Ginv.sparse)                
               , residual = ~ dsum(~idv(units)|Year)                               
               , na.action = na.method(y = "include")
               , data = pheno.P)
ub.A <- update.asreml(ub.A)
summary(ub.A)$varcomp
plot(ub.A) # Potentailly some outliers in year 2018 and 2019

# Strange results with some negative and then possitive correlations??? is this correct?
#                                                             component   std.error    z.ratio bound %ch
# Year:vm(Genotype, Ginv.sparse)!Year!2019:!Year!2018.cor   -0.12858413   0.1184598 -1.0854661     U 0.4
# Year:vm(Genotype, Ginv.sparse)!Year!2021:!Year!2018.cor    0.51896834   0.1004512  5.1663722     U 0.1
# Year:vm(Genotype, Ginv.sparse)!Year!2021:!Year!2019.cor   -0.06213334   0.1218903 -0.5097482     U 0.1
# Year:vm(Genotype, Ginv.sparse)!Year_2018                2391.49377530 431.4285646  5.5431976     P 0.0
# Year:vm(Genotype, Ginv.sparse)!Year_2019                3159.27284875 532.8640765  5.9288531     P 0.2
# Year:vm(Genotype, Ginv.sparse)!Year_2021                1585.30410037 285.4997898  5.5527330     P 0.1
# Year_2018!R                                                1.00000000          NA         NA     F 0.0
# Year_2018!units                                         1137.17729603  78.2475419 14.5330737     P 0.0
# Year_2019!R                                                1.00000000          NA         NA     F 0.0
# Year_2019!units                                          613.23774048  41.1484664 14.9030522     P 0.0
# Year_2021!R                                                1.00000000          NA         NA     F 0.0
# Year_2021!units                                          787.51822637  50.1250742 15.7110635     P 0.0

table(pheno.P$Year,pheno.P$Year )
table(pheno.P$Genotype,pheno.P$Year )


# The other trait...
# Changing to corgh for clarity
ub.B <- asreml(LB ~ 1 + Flower            
               , random = ~corgh(Year):vm(Genotype, Ginv.sparse)                
               , residual = ~ dsum(~idv(units)|Year)                               
               , na.action = na.method(y = "include")
               , data = pheno.P)
ub.B <- update.asreml(ub.B) # unstable?
summary(ub.B)$varcomp
plot(ub.B) # Clearly some outliers in year 2019 (see also MSE_2019 = 9166 much larger than the others)

# Note: also unstable correlations, some positive and some negative...
#                                                             component    std.error    z.ratio bound %ch
# Year:vm(Genotype, Ginv.sparse)!Year!2019:!Year!2018.cor   -0.04067188 1.180269e-01 -0.3445984     U 0.5
# Year:vm(Genotype, Ginv.sparse)!Year!2021:!Year!2018.cor    0.54527071 8.851424e-02  6.1602599     U 0.0
# Year:vm(Genotype, Ginv.sparse)!Year!2021:!Year!2019.cor   -0.26347289 1.066738e-01 -2.4698934     U 0.0
# Year:vm(Genotype, Ginv.sparse)!Year_2018                3818.57763769 6.112057e+02  6.2476142     P 0.0
# Year:vm(Genotype, Ginv.sparse)!Year_2019                9166.09326025 1.446275e+03  6.3377252     P 0.0
# Year:vm(Genotype, Ginv.sparse)!Year_2021                4639.75167416 7.914808e+02  5.8621154     P 0.0
# Year_2018!R                                                1.00000000           NA         NA     F 0.0
# Year_2018!units                                         1046.01842698 7.202763e+01 14.5224602     P 0.0
# Year_2019!R                                                1.00000000           NA         NA     F 0.0
# Year_2019!units                                         1137.48675417 7.709784e+01 14.7538082     P 0.0
# Year_2021!R                                                1.00000000           NA         NA     F 0.0
# Year_2021!units                                         1421.50536009 8.997630e+01 15.7986638     P 0.0


#####################################
# Fitting a BIVARIATE - MET requires that all outliers are eliminated, and good starting values.
# also you want years and trait to be correlated.
# It is not possible (under the current data structure) to fit a bivariate with multiple years.
# However, a bivariate for a given year, will look like:

pheno.P2021 <- pheno.P[pheno.P$Year =='2021',]

mv.2021 <- asreml(cbind(FB,LB) ~ trait + trait:Flower            
                  , random = ~corgh(trait):vm(Genotype, Ginv.sparse)                
                  , residual = ~ id(units):us(trait)                               
                  , na.action = na.method(y = "include")
                  , data = pheno.P2021)
summary(mv.2021)$varcomp
plot(mv.2021) # not outliers in this case.

# Note: very good correlation between traits.
#                                                          component   std.error   z.ratio bound %ch
# trait:vm(Genotype, Ginv.sparse)!trait!LB:!trait!FB.cor    0.718443   0.0632937 11.350941     U 0.0
# trait:vm(Genotype, Ginv.sparse)!trait_FB               1126.086457 196.0803663  5.742984     P 0.0
# trait:vm(Genotype, Ginv.sparse)!trait_LB               2865.132134 472.1153486  6.068712     P 0.1
# units:trait!R                                             1.000000          NA        NA     F 0.0
# units:trait!trait_FB:FB                                 766.765248  48.0412942 15.960545     P 0.0
# units:trait!trait_LB:FB                                 501.464980  51.1748334  9.799054     P 0.0
# units:trait!trait_LB:LB                                1388.126505  86.8915278 15.975395     P 0.0

# Now, the model below is not 'combining the traits in the G part, so it is fitting each trait separately but
# across years.
# Also,there should be 6 error variances (one per year-trait combination)
# The model below will not work because is not liking the us(year) with at(trait).

mv.X <- asreml(cbind(FB,LB) ~ trait + trait:Flower            
               , random = ~at(trait):us(Year):vm(Genotype, Ginv.sparse)                
               , residual = ~ id(units):us(trait)                               
               , na.action = na.method(y = "include", x='include')
               , data = pheno.P)

mv.X <- asreml(cbind(FB,LB) ~ trait + trait:Flower            
               , random = ~at(Year):corgh(trait):vm(Genotype, Ginv.sparse)                
               , residual = ~ id(units):us(trait)                               
               , na.action = na.method(y = "include", x='include')
               , data = pheno.P)
summary(mv.X)$varcomp

# The above model is closer, but still makes the years independent.
# I also fit the 2 traits x 3 years  and creating a database with 6 environments.
# say env 1 to 6. Now, then you can fit a model like:

mv.D <- asreml(resp ~ Env + Env:Flower            
               , random = ~corgh(Env):vm(Genotype, Ginv.sparse)                
               , residual = ~ dsum(~id(units)| Env)                               
               , na.action = na.method(y = "include", x='include')
               , data = pheno.MY6)

# That is still an approximation, but a bit closer to what you want.
# Finally, it is possible to use:
# residual = ~ id(units):us(Env)                               
# but in this case, you are correlating all envs to each other in the residual part, 
# and only the env from different traits are correlated. 

#####################################
#####################################

# # Note: fitting bivariate with us structure.
# str(pheno.P)
# 
# mv.A <- asreml(cbind(FB,LB) ~ trait + trait:Flower            
#                , random = ~at(trait):us(Year):vm(Genotype, Ginv.sparse)                
#                , residual = ~ id(units):us(trait)                               
#                , na.action = na.method(y = "include")
#                , data = pheno.P)
# 
# if(mv.A$converge==TRUE){
#   pred = predict(mv.A, classify = "Genotype", trace=T)$pvals
#   res$prediction[currentFoldPos:(newpos-1)] <- pred$predicted.value[currentFoldPos:(newpos-1)]
#   png(file = paste('bivar.A', 'png', sep='.'), width = 1024, height = 1024)
#   plot(mv.A)
#   dev.off()
# }
# # diag
# # corgh
# # xfa1
# # us
# # rr1
# # 1:  Bivariate model of FB & LB, fitting the mean of each and sex as fixed effects
# # 2:  Random G structure defined as an unstructured covariance matrix (us). Initial 
# #     starting values of va1=1 cov12=0.1 va2=1 
# # 3:  Residual (R) structure defined as an unstructured covar matrix, initial starting 
# #     values of va1, cov12, va2.
# 
