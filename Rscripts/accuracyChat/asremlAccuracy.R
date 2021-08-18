library(stringi)
outdir <- '/media/yn259/data/research/HIR/analysis'
maindir <- list.dirs(path = outdir, recursive = FALSE)
maindir <- maindir[grepl('drm*', maindir)]


for(dir in maindir){
  # dir = maindir[1]
  dirname = basename(dir)
  subdirs = list.dirs(dir, recursive = FALSE)
  acc = c()
  accM = c()
  for(sub in subdirs){
    # sub = subdirs[1]
    asData <- c()
    for(i in 0:10){
      foldername = file.path(sub, toString(i))
      subname = tools::file_path_sans_ext(basename(sub))
      subfilename = paste(subname, "asr", sep = '.')
      if(!file.exists(file.path(foldername, subfilename))){
        next
      }
      asr <- file.path(foldername, subfilename)
      lines <- readLines(asr)
      if(i == 0){
        arr <- unlist(strsplit(lines[length(lines)-1], ' '))
        arr <- stri_remove_empty(arr, na_empty = FALSE)
        if(arr[2] != 'LogL'){
          acc = rbind(acc, c(subname, arr[2]))
        }
        observedData <- read.table(file.path(foldername, 'data.asd'), header=F, sep='\t', row.names=1)
        colnames(observedData) <- c('Observation')
      }else{
        arr <- unlist(strsplit(lines[length(lines)], ' '))
        arr <- stri_remove_empty(arr, na_empty = FALSE)
        if(arr[length(arr)] != 'Converged'){
          next
        }
        pvsfilename <- file.path(foldername, paste(subname, "pvs", sep = '.'))
        if(!file.exists(pvsfilename)){
          next
        }
        pvslines <- readLines(pvsfilename)
        index = 0
        # skip meta information i pvs file
        for(l in pvslines){
          index = index + 1
          # line <- unlist(strsplit(l[length(l)], ' '))
          # line <- stri_remove_empty(line, na_empty = FALSE)
          if(startsWith(trimws(l), 'Genotype')){
            break
          }
        }
        # read lines and convert to table
        pvs <- c()
        for(idx in index:length(pvslines)){
          line <- trimws(pvslines[idx])
          line <- unlist(strsplit(line[length(line)], ' '))
          line <- stri_remove_empty(line, na_empty = FALSE)
          pvs <- rbind(pvs, line) 
        }
        colnames(pvs) <- pvs[1,]
        rownames(pvs) <- pvs[,1]
        pvs <- pvs[2:dim(pvs)[1], 2:dim(pvs)[2]]
        pvs <- pvs[1:dim(pvs)[1]-1,]
        
        #read data file
        asd <- read.table(file.path(foldername, 'data.asd'), header=TRUE, sep='\t', row.names=1)
        asd <- asd[asd[, 'Missing'] == 1,]
        pvs <- pvs[rownames(asd),]
        asData <- rbind(asData, pvs)
      }
    }
    if(is.null(asData)){
      next
    }
    asData <- cbind(asData, observedData[1:dim(asData)[1], 1])
    colnames(asData)[4] <- 'Observed_Value'
    correlation <- cor(sapply(asData[,'Predicted_Value'], as.numeric), sapply(asData[,'Observed_Value'], as.numeric))
    accM <- rbind(accM, c(subname, correlation))
    
    
    
    
  }
  if(length(acc) > 0){
    colnames(acc) = c('Phenotype', 'Accuracy')
    write.table(acc, file = file.path(dir, paste(dirname, 'accCombined', 'txt', sep = '.')), sep = '\t', col.names = TRUE, row.names = FALSE, quote = FALSE)
  }
  if(length(accM) > 0){
    colnames(accM) = c('Phenotype', 'Accuracy')
    write.table(accM, file = file.path(dir, paste(dirname, 'acc', 'txt', sep = '.')), sep = '\t', col.names = TRUE, row.names = FALSE, quote = FALSE)
  }
}


# for(dir in maindir){
#   dir = maindir[1]
#   dirname = basename(dir)
#   subdir = list.dirs(dir, recursive = FALSE)
#   acc = c()
#   accM = c()
#   for(sub in subdir){
#     # sub = subdir[1]
#     subname = tools::file_path_sans_ext(basename(sub))
#     subfilename = paste(subname, "asr", sep = '.')
#     if(!file.exists(file.path(sub, subfilename))){
#       next
#     }
#     asr <- file.path(sub, subfilename)
#     lines <- readLines(asr)
#     arr = unlist(strsplit(lines[length(lines)-1], ' '))
#     arr = stri_remove_empty(arr, na_empty = FALSE)
#     if(arr[2] != 'LogL'){
#       #   acc = rbind(acc, c(subname, ''))  
#       # }else{
#       acc = rbind(acc, c(subname, arr[2]))
#     }
#   }
#   if(length(acc) > 0){
#     colnames(acc) = c('Phenotype', 'Accuracy')
#     write.table(acc, file = file.path(dir, paste(dirname, 'acc', 'txt', sep = '.')), sep = '\t', col.names = TRUE, row.names = FALSE, quote = FALSE)
#   }
# }