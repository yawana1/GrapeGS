grapeGS <- function(
  outdir,
  phenoFilename,
  genoFilename,
  isGRM = FALSE,
  genoTech,
  matrixMethod
){
  library("BGLR")
  title = paste(genoTech,matrixMethod,sep = "_")
  dir.create(file.path(outdir, "crossvalidation"), showWarnings = FALSE)
  setwd(file.path(outdir, "crossvalidation"))
  
  # load and prep phenotype data
  sep = ifelse(endsWith(phenoFilename, ".csv"), ",", "\t")
  # if(endsWith(phenoFilename, ".csv")){
  #   sep = ","
  #   print(sep)
  # }else if(endsWith(phenoFilename, ".txt")){
  #   sep = "\t"
  #   print(sep)
  # }
  phenoDat = read.table(phenoFilename, header=TRUE, sep=sep, row.names=1)
  phenoDat = as.matrix(phenoDat)
  
  # load genotype data
  genoDat = read.table(genoFilename, header=TRUE, sep="\t", row.names=1)
  genoDat = as.matrix(genoDat)
  genoDat[genoDat == -1] <- NA
  
  df_acc <- matrix(ncol = 4, nrow = 0)
  colnames(df_acc) <- c("Tech", "Method", "Phenotype", "Accuracy")
  for(phenoIndex in c(1:length(phenoDat[1,]))){
    # phenoIndex = 1
    P = phenoDat[,phenoIndex]
    P = P[!is.na(P)]
    phenoName = colnames(phenoDat)[phenoIndex]
    G = genoDat
    # Filter genomic relationship matrix
    lines = c()
    headers = c()
    for(item in names(P)){
      if(item %in% rownames(G)){
        lines = append(lines, item)
        headers = append(headers, paste('X', item, sep=""))
        # headers = append(headers, item)
      }
    }
    
    P = P[lines]
    if(isGRM){
      G = G[lines, headers]  
      colnames(G) = lines
    }else{
      G = G[lines,]
    }
    
    # if(is_empty(G) || is_empty(P))
    #   next
    
    # Cross validation
    if(isGRM){
      EVD <-eigen(G)
      Model<-list(list(K=G, model='RKHS'),
                  list(V=EVD$vectors,d=EVD$values, model='RKHS'))
      # Model<-list(list(K=G, model='RKHS'))
    }else{
      Model<-list(list(X=G,model="BRR"))
    }
    
    nLines=length(G[,1])
    foldSize=floor(nLines/10) + 1
    currentFoldPos=1
    Ypred=rep(0,nLines)
    for(i in c(1:10)){
      Y = array(P)
      newpos = min(currentFoldPos+foldSize, nLines+1)
      if(newpos == currentFoldPos)
        break
      Y[currentFoldPos:(newpos-1)]=NA
      result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 3000, burnIn = 1500, thin = 10, verbose = FALSE)
      Yhat=result$yHat
      Ypred[currentFoldPos:(newpos-1)]=Yhat[currentFoldPos:(newpos-1)]
      currentFoldPos=newpos 
    }
    
    res <- data.frame(
      observed = P,
      predicted = Ypred
    )
    
    library(ggplot2)
    library(hrbrthemes)
    
    # Open PNG file
    png(file = paste("graph_",title, tools::file_path_sans_ext(basename(phenoFilename)),phenoName,".png", sep=""),
        width = 1040,
        height = 600
    )
    
    #Divide the screen in 1 line and 2 columns
    par(
      mfrow=c(1,2), 
      oma = c(0, 0, 2, 0)
    )
    #Make the margin around each graph a bit smaller
    par(mar=c(4,2,2,2))
    
    # Histogram of phenotype
    tmp_range = range(P)
    tmp<-range(c(P,Ypred))
    hist(P, xlim=tmp_range, col=rgb(0,0,1,0.5), xlab="", 
         ylab="", main=phenoName)
    plot(P, Ypred,xlab='Observed',ylab='Predicted',col=2,
         xlim=tmp,ylim=tmp); abline(a=0,b=1,col=4,lwd=2)
    
    # Close file
    dev.off()
    
    # Compute accuracy
    acc=cor(Ypred,P, use="complete.obs")
    df_acc <- rbind(df_acc, c(genoTech, matrixMethod, phenoName, round(acc, digits = 4)))
  }
  write.table(df_acc, file=paste("acc_", title, tools::file_path_sans_ext(basename(phenoFilename)), ".txt", sep=""), row.names=FALSE, col.names=TRUE, sep="\t")
}

# library(ggplot2)
# library(hrbrthemes)

# set paths for Horizon_x_Illinois547-1
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1"
# phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/phenos/phenotype_faq.txt"
# genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rqtl/grm.tabular.txt"

# set paths for RupestrisB38_x_Horizon
# outdir = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon"
# phenoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv"
# genoFilename = "/home/yaw/Documents/Grape/RupestrisB38_x_Horizon/rqtl/grm.tabular.txt"

# set paths for RupestrisB38_x_Horizon
# outdir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea"
# phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/phenos/HCallHRpheno.csv"
# genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/rqtl/grm.tabular.txt"

# set globals
# isGRM = TRUE
# title = "GRM_Tabular_HCallHR"
# dir.create(file.path(outdir, "crossvalidation"), showWarnings = FALSE)
# dir = paste("crossvalidation", title, sep="/")
# dir.create(file.path(outdir, dir), showWarnings = FALSE)
# setwd(file.path(outdir, dir))

# load and prep phenotype data
# phenoDat = read.table(phenoFilename, header=TRUE, sep=",", row.names=1)
# if(endsWith(phenoFilename, ".csv")){
#   sep = ","
# }else if(endsWith(phenoFilename, ".csv")){
#   sep = "\t"
# }
# phenoDat = read.table(phenoFilename, header=TRUE, sep=sep)
# phenoDat = as.matrix(phenoDat)
# 
# 
# # load genotype data
# genoDat = read.table(genoFilename, header=TRUE, sep="\t", row.names=1)
# genoDat = as.matrix(genoDat)
# 
# df_acc <- matrix(ncol = 2, nrow = 0)
# colnames(df_acc) <- c("Phenotype", "Accuracy")
# for(phenoIndex in c(1:length(phenoDat[1,]))){
#   # phenoIndex = 1
#   P = phenoDat[,phenoIndex]
#   P = P[!is.na(P)]
#   phenoName = colnames(phenoDat)[phenoIndex]
#   G = genoDat
#   # Filter genomic relationship matrix
#   lines = c()
#   headers = c()
#   for(item in names(P)){
#     if(item %in% rownames(G)){
#       lines = append(lines, item)
#       headers = append(headers, paste('X', item, sep=""))
#       # headers = append(headers, item)
#     }
#   }
#   
#   P = P[lines]
#   if(isGRM){
#     G = G[lines, headers]  
#     colnames(G) = lines
#   }else{
#     G = G[lines,]
#   }
#   
#   # Cross validation
#   if(isGRM){
#     EVD <-eigen(G)
#     Model<-list(list(K=G, model='RKHS'),
#                 list(V=EVD$vectors,d=EVD$values, model='RKHS')
#     )
#   }else{
#     Model<-list(list(X=G,model="BRR"))
#   }
#   
#   nLines=length(G[,1])
#   foldSize=floor(nLines/10) + 1
#   currentFoldPos=1
#   Ypred=rep(0,nLines)
#   for(i in c(1:10)){
#     Y = array(P)
#     newpos = min(currentFoldPos+foldSize, nLines+1)
#     if(newpos == currentFoldPos)
#       break
#     Y[currentFoldPos:(newpos-1)]=NA
#     result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 3000, burnIn = 1500, thin = 10, verbose = FALSE)
#     Yhat=result$yHat
#     Ypred[currentFoldPos:(newpos-1)]=Yhat[currentFoldPos:(newpos-1)]
#     currentFoldPos=newpos 
#   }
#   
#   res <- data.frame(
#     observed = P,
#     predicted = Ypred
#   )
#   
#   # Open PNG file
#   png(file = paste("graph_", phenoName,".png", sep=""),
#       width = 1040,
#       height = 600
#       )
#   
#   #Divide the screen in 1 line and 2 columns
#   par(
#     mfrow=c(1,2), 
#     oma = c(0, 0, 2, 0)
#   )
#   #Make the margin around each graph a bit smaller
#   par(mar=c(4,2,2,2))
#   
#   # Histogram of phenotype
#   tmp_range = range(P)
#   tmp<-range(c(P,Ypred))
#   hist(P, xlim=tmp_range, col=rgb(0,0,1,0.5), xlab="", 
#        ylab="", main=phenoName)
#   plot(P, Ypred,xlab='Observed',ylab='Predicted',col=2,
#        xlim=tmp,ylim=tmp); abline(a=0,b=1,col=4,lwd=2)
#   
#   # Close file
#   dev.off()
#   
#   # Compute accuracy
#   acc=cor(Ypred,P, use="complete.obs")
#   df_acc <- rbind(df_acc, c(phenoName, round(acc, digits = 4)))
# }
# write.table(df_acc, file=paste("acc_", title, ".txt", sep=""), row.names=FALSE, col.names=TRUE, sep="\t")
# ggplot(res, aes(x=observed, y=predicted)) +
#   geom_point() +
#   geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE) +
#   theme_ipsum()