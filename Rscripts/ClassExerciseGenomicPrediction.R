#load/install BGLR
#install.packages("BGLR")
#library(BGLR)

#set working directory
#setwd("~/Documents/Courses/QGCourse/Final")

#read genotypic data
genoDat=read.table("centeredGenotypest.csv",sep=",")

#using read.table so need to convert to a matrix
genoDat=as.matrix(genoDat)

#setting variables with the number of lines and the number of markers
nLines=length(genoDat[,1])
nMarks=length(genoDat[1,])

#read phenotypic data
phenoDat=read.table("Pheno1000.csv",sep=",")
#phenoDat=read.table("Pheno30.csv",sep=",")
#using read.table so need to convert to a matrix
phenoDat=as.matrix(phenoDat)

#some quick summary statistics of phenotypic data
hist(phenoDat)

#setting fold size - there are 100 lines in the file so hardcoding it as 20 (lazy implementation)
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
  result= BGLR(Y, response_type = "gaussian", ETA = Model, nIter = 2500, burnIn = 1000, thin = 3,verbose = FALSE)
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




