crossvalidation <- function(phenofile, genofile){
  
  # phenofile = "/media/yn259/data/research/HI/analysis/matrix.incidence.gbs.none/TOTAL_DIGLUCOSIDES/data.asd"
  # genofile = "/media/yn259/data/research/HI/analysis/matrix.incidence.gbs.none/TOTAL_DIGLUCOSIDES/matrix.incidence.grm"
  
  library(stringi)
  setwd(dirname(phenofile))
  
  print(paste('Processing', tools::file_path_sans_ext(basename(dirname(phenofile))), '...', sep = ' '), quote = F)
  
  library(Matrix)
  phenoDat <- read.table(phenofile, sep="\t", header=T)
  genoDat=read.table(genofile,sep="\t", header=F)
  genoDat=as.matrix(genoDat)
  nLines=length(genoDat[,1])
  
  library(BGLR)
  foldSize=floor(nLines/10)
  currentFoldPos=1
  Ypred=rep(0,nLines)
  
  folds = ifelse(nLines %% 10 > 0, 11, 10)
  for(i in c(1:folds)){
    Y=phenoDat$x
    newpos = min(currentFoldPos+foldSize, nLines+1)
    Y[currentFoldPos:(newpos-1)]=NA
    Model<-list(list(X=genoDat,model="BRR"))
    result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 6000, burnIn = 1000, thin = 10, verbose = FALSE)
    # summary(result)
    # plot(scan('varE.dat'), type = 'o')
    Yhat=result$yHat
    Ypred[currentFoldPos:(newpos-1)]=Yhat[currentFoldPos:(newpos-1)]
    currentFoldPos=newpos
  }
  acc=cor(Ypred,phenoDat$x, use="complete.obs")
  return(acc)
  # print(acc)
  # plot(Ypred,phenoDat$Phenotype)
  # View(Ypred)
}


# setwd('/media/yn259/data/research/HI/analysis/matrix.maf.gbs.filtered/AMMONIA')
# phenofile = "/media/yn259/data/research/HI/analysis/matrix.maf.gbs.filtered/AMMONIA/data.asd"
# genofile = "/media/yn259/data/research/HI/analysis/matrix.maf.gbs.filtered/AMMONIA/matrix.maf.grm"
# 
# library(Matrix)
# phenoDat <- read.table(phenofile, sep="\t", header=T)
# genoDat=read.table(genofile,sep="\t", header=F)
# genoDat=as.matrix(genoDat)
# 
# # data(wheat)
# set.seed(12345)
# varB<-0.5*(1/sum(apply(X=genoDat,MARGIN=2,FUN=var)))
# b0<-rnorm(n=dim(genoDat)[2],sd=sqrt(varB))
# signal<-genoDat%*%b0
# error<-rnorm(dim(phenoDat)[1],sd=sqrt(0.5))
# y<-100+signal+error
# 
# nIter=500;
# burnIn=100;
# thin=3;
# saveAt='';
# S0=NULL;
# weights=NULL;
# R2=0.5;
# ETA<-list(list(X=genoDat,model='BRR'))
# 
# fit_BRR=BGLR(y=y,ETA=ETA,nIter=nIter,burnIn=burnIn,thin=thin,saveAt=saveAt,df0=5,S0=S0,weights=weights,R2=R2)
# plot(fit_BRR$yHat,y)

# crossvalidation <- function(phenofile, genofile){
#   
#   # phenofile = "/home/yn259/ExpanDrive/Cornell/research/HR/analysis/matrix.incidence.gbs.filtered/AMMONIA/data.asd"
#   # genofile = "/home/yn259/ExpanDrive/Cornell/research/HR/analysis/matrix.incidence.gbs.filtered/AMMONIA/matrix.incidence.grm"
#   
#   # setwd('/home/yn259/ExpanDrive/Cornell/research/HI/analysis/matrix.incidence.gbs.filtered/AMMONIA')
#   # phenofile = "/home/yn259/ExpanDrive/Cornell/research/HI/analysis/matrix.incidence.gbs.filtered/AMMONIA/data.asd"
#   # genofile = "/home/yn259/ExpanDrive/Cornell/research/HI/analysis/matrix.incidence.gbs.filtered/AMMONIA/matrix.incidence.grm"
#   
#   setwd(dirname(phenofile))
#   
#   library(Matrix)
#   phenoDat <- read.table(phenofile, sep="\t", header=T)
#   genoDat=read.table(genofile,sep="\t", header=F)
#   genoDat=as.matrix(genoDat)
#   nLines=length(genoDat[,1])
#   
#   library(BGLR)
#   foldSize=floor(nLines/10)
#   currentFoldPos=1
#   Ypred=rep(0,nLines)
#   for(i in c(1:10)){
#     Y=phenoDat$x
#     # Y = Y - mean(Y, trim=0, na.rm=TRUE)
#     newpos = min(currentFoldPos+foldSize, nLines+1)
#     Y[currentFoldPos:(newpos-1)]=NA
#     Model<-list(list(X=genoDat,model="BRR"))
#     result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 3000, burnIn = 1500, thin = 10, verbose = FALSE)
#     # summary(result)
#     # plot(result)
#     Yhat=result$yHat
#     Ypred[currentFoldPos:(newpos-1)]=Yhat[currentFoldPos:(newpos-1)]
#     currentFoldPos=newpos
#   }
#   acc=cor(Ypred,phenoDat$x, use="complete.obs")
#   return(acc)
#   # print(acc)
#   # plot(Ypred,phenoDat$Phenotype)
#   # View(Ypred)
# }