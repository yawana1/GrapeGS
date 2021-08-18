outdir = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/phenos"
phenoFilename = "/home/yaw/Documents/Grape/Horizon_x_Cinerea/phenos/HCallHRpheno.csv"
setwd(outdir)

phenoDat = read.table(phenoFilename, header=TRUE, sep=",")
phenoDat = as.matrix(phenoDat)

filename = tools::file_path_sans_ext(basename(phenoFilename))
varYear = unique(phenoDat[,"Year"])
varExperiment = unique(phenoDat[,"Experiment"])
hasDPI = FALSE
if("Dpi" %in% colnames(phenoDat)){
  hasDPI = TRUE
  varDpi = unique(phenoDat[,"Dpi"])
}

for(yr in varYear){
  datYear = phenoDat[phenoDat[,"Year"] == yr,]
  fileYear = paste(filename, yr, sep = "_")
  for(exp in varExperiment){
    datExp = datYear[datYear[,"Experiment"] == exp,]
    fileExp = paste(fileYear, exp, sep = "_")
    if(hasDPI){
      for(dpi in varDpi){
        datDpi = datExp[datExp[,"Dpi"] == dpi,]
        fileDpi = paste(fileExp, dpi, sep = "_")
        if(!is_empty(datDpi)){
          datDpi = subset(datDpi, select=-c(Year, Experiment, Dpi))
          write.table(datDpi, file=paste(fileDpi, ".txt", sep=""), row.names=FALSE, col.names=TRUE, sep="\t")
        }
      }
    }else{
      if(!is_empty(datExp)){
        datExp = subset(datExp, select=-c(Year, Experiment))
        write.table(datExp, file=paste(fileExp, ".txt", sep=""), row.names=FALSE, col.names=TRUE, sep="\t")  
      }
    }
  }
}
