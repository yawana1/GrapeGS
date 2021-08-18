#load/install BGLR
#install.packages("BGLR")
library(BGLR)

#set working directory, need to change to the directory containing the files on your computer
setwd("~/Documents/courses/PLBRG_7170-QG/code/finals")


genoFile <- "centeredGenotypest2.csv"
freqFile <- "freqst2.csv"
phenoFile <- "Pheno2.csv"

#read genotypic data
genoDat=read.table(genoFile,sep=",")
 
#using read.table so need to convert to a matrix
genoDat=as.matrix(genoDat)
 
#read in a file with allele frequencies for each marker
freqs=read.table(freqFile,sep=",")
freqs=as.matrix(freqs)
#calculate the G matrix
#calculate scaling factor k
k=0
for(i in c(1:length(freqs))){
  k=k+2*freqs[i]*(1-freqs[i])
}

G=genoDat%*%t(genoDat)*(1/k)

#heat map of the relationship matrix
image(G)

#setting variables with the number of lines and the number of markers
nLines=length(genoDat[,1])
nMarks=length(genoDat[1,])

#read phenotypic data
phenoDat=read.table(phenoFile,sep=",")

#using read.table so need to convert to a matrix
phenoDat=as.matrix(phenoDat)

#some quick summary statistics of phenotypic data
hist(phenoDat)

#setting fold size - there are 500 lines in the file so hardcoding it as 100 (lazy implementation)
foldSize=100
#variable to track which phenotypes need to be set to NA
currentFoldPos=1
#set up a vector to sore predicted values
Ypred=rep(0,nLines)
#loop for 5 fold cross validation
for(i in c(1:5)){
  #setting up a vector of phenotypes for each fold
  Y=phenoDat
  #mask data for prediction
  Y[currentFoldPos:(currentFoldPos+foldSize-1)]=NA
  #run BGLR
  #BGLR(y, response_type = "gaussian", a=NULL, b=NULL,ETA = NULL, nIter = 1500,
  #    burnIn = 500, thin = 5, saveAt = "", S0 = NULL,
  #    df0 =5, R2 = 0.5, weights = NULL,
  #    verbose = TRUE, rmExistingFiles = TRUE, groups=NULL)
  # Details at https://cran.r-project.org/web/packages/BGLR/BGLR.pdf
  # set up ETA list
  Model<-list(list(X=genoDat,model="BayesC"))
  #model types appropriate for this marker matrix are "BRR", "BayesA", "BL", "BayesB", "BayesC"
  #If passing in a genomic relationship matrix "RKHS" model type can be used
  #If providing an incedence matrix for fixed effects model type "FIXED"
  result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 3000, burnIn = 1500, thin = 10,verbose = FALSE)
  #grab estimates of breeding values from the results list
  Yhat=result$yHat
  Ypred[currentFoldPos:(currentFoldPos+foldSize-1)]=Yhat[currentFoldPos:(currentFoldPos+foldSize-1)]
  #update the variable tracking folds
  currentFoldPos=currentFoldPos+foldSize
}

#summarize prediction performance

acc=cor(Ypred,phenoDat)
print(acc)
plot(Ypred,phenoDat)
