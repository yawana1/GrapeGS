analysisprep <- function(outdir, outfolder, phenofilename, genofilename, isGRM=FALSE, colFilter=FALSE, isBase=FALSE){
  # outdir="/media/yn259/data/research/HR"
  # outfolder = 'snp.none'
  # phenofilename = "/media/yn259/data/research/HR/phenos/HCR.txt"
  # genofilename = "/media/yn259/data/research/HR/snp/none/grm.incidence.txt"
  # isGRM = TRUE
  # colFilter = TRUE
  # isBase = FALSE
  
  source('/home/yn259/workspace/GrapeGS/Rscripts/grm/raw.data.R')
  outdir = file.path(outdir, "analysis")
  dir.create(outdir, showWarnings = FALSE)
  setwd(outdir)
  
  # load and prep phenotype data
  sep = ifelse(endsWith(phenofilename, ".csv"), ",", "\t")
  # phenoDat = read.table(phenofilename, header=TRUE, sep=sep, row.names=1, fileEncoding="UTF-16LE")
  phenoDat = read.table(phenofilename, header=TRUE, sep=sep, row.names=1)
  phenoDat = as.matrix(phenoDat)
  
  # load GRM data
  genoDat = read.table(genofilename, header=TRUE, sep="\t", row.names=1)
  genoDat = as.matrix(genoDat)
  if(isBase){
    genoDat[genoDat == 'NN'] <- NA
    genoDat[genoDat == ''] <- NA
    genoDat[grepl('-', genoDat, fixed = TRUE)] <- NA
  }else{
    genoDat[genoDat == -1] <- NA
  }
  
  # Geno filtering and imputing
  if(!isGRM){
    mrc <- raw.data(genoDat, frame="wide", base=isBase, sweep.sample= 1,
                    call.rate=0.1, maf=0.1, imput=TRUE, imput.type="mean", outfile="012", plot=TRUE)
    genoDat = mrc$M.clean
  }
  
  if(colFilter){
    colnames(genoDat) = sapply(strsplit(colnames(genoDat), '\\.'), '[[', 1)
    rownames(genoDat) = sapply(strsplit(rownames(genoDat), ':'), '[[', 1)
  }
  if(substr(rownames(phenoDat)[1], 1,1) != 'X'){
    rownames(phenoDat) = paste('X', rownames(phenoDat), sep = '') 
  }
  rownames(genoDat) = paste('X', rownames(genoDat), sep = '') 
  genoName = tools::file_path_sans_ext(basename(genofilename))
  
  # analysis execute commands
  genodir = file.path(outdir, paste(genoName, outfolder, sep = '.'))
  dir.create(genodir, showWarnings = FALSE)
  cmd = c()
  for(phenoIndex in 1:length(phenoDat[1,])){
    # phenoIndex = 1
    P = phenoDat[,phenoIndex]
    P = P[!is.na(P)]
    phenoName = colnames(phenoDat)[phenoIndex]
    geno = genoDat
    
    # Filter GRM
    lines = c()
    # headers = c()
    for(item in names(P)){
      if(item %in% rownames(geno)){
        lines = append(lines, item)
        # headers = append(headers, paste('X', item, sep=""))
      }
    }
    P = P[lines]
    if(isGRM){
      geno = geno[lines, lines] 
    }else{
      geno = geno[lines,]
    }
    
    phenodir = file.path(genodir, phenoName)
    dir.create(phenodir, showWarnings = FALSE)
    
    if(isGRM){
      dir.create(file.path(phenodir, '0'), showWarnings = FALSE)
      write.table(P, file = file.path(phenodir, '0', 'data.asd'), sep = '\t', col.names = !isGRM, quote = FALSE) 
      as0 <- file(file.path(phenodir, '0', paste(phenoName, '.as', sep = '')))
      writeLines(c(
        '!NODISPLAY !XML',
        paste('Cross Validation with', phenoName, sep = ' '),
        paste('', 'Genotype !A', sep = ' '),
        paste('', phenoName, sep = ' '),
        paste('', 'CVgroup 10 !=Genotype !-1 !MOD 10 !+1', sep = ' '),
        '!CYCLE 1:11',
        paste('../', genoName, '.grm', sep = ''),
        'data.asd !SKIP 0 MAXIT 100 !EXTRA 5 !FILTER CVgroup !EXCLUDE $I  !KCV grm1(Genotype)',
        '',
        paste(phenoName, '~ mu !r grm1(Genotype)', sep = ' ')
      ), as0)
      close(as0)
      
      cmd = append(cmd, paste('pushd ', phenoName, '/0', sep = ''))
      cmd = append(cmd, paste('asreml', paste(phenoName, '.as', sep = ''), sep = ' '))
      cmd = append(cmd, 'popd')
      
      nLines = length(P)
      foldSize=floor(nLines/10)
      currentFoldPos=1
      for(i in c(1:10)){
        Y <- as.matrix(P)
        Y <- cbind(rownames(Y), 0, Y[,1])
        colnames(Y) <- c('Genotype', 'Missing', phenoName)
        newpos <- min(currentFoldPos+foldSize, nLines+1)
        Y[currentFoldPos:(newpos-1), 2] <- 1
        Y[currentFoldPos:(newpos-1), 3] <- 'NA'
        dir.create(file.path(phenodir, toString(i)), showWarnings = FALSE)
        write.table(Y, file = file.path(phenodir, toString(i), 'data.asd'), sep = '\t', col.names = T, row.names = F, quote = FALSE, na = '')
        asfile <- file(file.path(phenodir, toString(i), paste(phenoName, '.as', sep = '')))
        writeLines(c(
          '!NODISPLAY !XML',
          paste('Phenotypic with', phenoName, sep = ' '),
          paste('', 'Genotype !A', sep = ' '),
          paste('', 'Missing !I', '2', sep = ' '),
          paste('', phenoName, sep = ' '),
          paste('../', genoName, '.grm', sep = ''),
          'data.asd !SKIP 1 MAXIT 100 !EXTRA 5 !MVINCLUDE',
          '',
          paste(phenoName, '~ mu !r grm1(Genotype)', sep = ' '),
          paste('predict', 'grm1(Genotype)', sep = ' ')
        ), asfile)
        close(asfile)
        
        cmd = append(cmd, paste('pushd ', phenoName, '/', toString(i), sep = ''))
        cmd = append(cmd, paste('asreml', paste(phenoName, '.as', sep = ''), sep = ' '))
        cmd = append(cmd, 'popd')
        
        currentFoldPos=newpos
      }
    }else{
      write.table(P, file = file.path(phenodir, 'data.asd'), sep = '\t', col.names = !isGRM, quote = FALSE)   
      cmd = append(cmd, paste(
        'acc <- crossvalidation(\"',
        file.path(phenodir, 'data.asd'), '\",\"',
        file.path(phenodir, paste(genoName, '.grm', sep = '')),
        '\")', sep = ''
      ))
      cmd = append(cmd, paste('lst_acc[[\"', phenoName, '\"]] <- acc', sep = ''))
    }
    write.table(geno, file = file.path(phenodir, paste(genoName, '.grm', sep = '')), 
                sep = '\t', col.names = FALSE, row.names = FALSE,quote = FALSE, na = '')
    # if(isGRM){
    #   asfile <- file(file.path(phenodir, '0', paste(phenoName, '.as', sep = '')))
    #   writeLines(c(
    #     '!NODISPLAY !XML',
    #     paste('Cross Validation with', phenoName, sep = ' '),
    #     paste('', 'Genotype !A', sep = ' '),
    #     paste('', phenoName, sep = ' '),
    #     paste('', 'CVgroup 5 !=Genotype !-1 !MOD 5 !+1', sep = ' '),
    #     '!CYCLE 1:6',
    #     paste(genoName, '.grm', sep = ''),
    #     'data.asd !SKIP 0 MAXIT 100 !EXTRA 5 !FILTER CVgroup !EXCLUDE $I  !KCV grm1(Genotype)',
    #     '',
    #     paste(phenoName, '~ mu !r grm1(Genotype)', sep = ' ')
    #   ), asfile)
    #   close(asfile)
    #   
    #   cmd = append(cmd, paste('pushd', phenoName, sep = ' '))
    #   cmd = append(cmd, paste('asreml', paste(phenoName, '.as', sep = ''), sep = ' '))
    #   cmd = append(cmd, 'popd')
    # }else{
    #   cmd = append(cmd, paste(
    #     'acc <- crossvalidation(\"',
    #     file.path(phenodir, 'data.asd'), '\",\"',
    #     file.path(phenodir, paste(genoName, '.grm', sep = '')),
    #     '\")', sep = ''
    #   ))
    #   cmd = append(cmd, paste('lst_acc[[\"', phenoName, '\"]] <- acc', sep = ''))
    # }
    
  }
  
  # write out asreml shell script
  if(isGRM){
    cmdfilename = file.path(genodir, 'runAsreml.sh')  
  }else{
    cmdfilename = file.path(genodir, 'runCV.R')
    cmd = append('lst_acc <- hash()', cmd)
    cmd = append(paste('setwd("',genodir,'\")', sep = ''), cmd)
    cmd = append('source(\"/home/yn259/workspace/GrapeGS/Rscripts/GrapeCV.R\")', cmd)
    cmd = append('library(hash)', cmd)
    cmd = append(cmd, 'df = cbind(names(lst_acc), values(lst_acc))')
    cmd = append(cmd, 'colnames(df) = c(\"Phenotype\", \"Accuracy\")')
    cmd = append(cmd, paste('write.table(df, file="',
                            file.path(genodir, paste(genoName, outfolder,'acc.txt',sep = '.')),
                            '", row.names=FALSE, col.names=TRUE, sep=\"\\t\")', sep = ''))
  }
  
  cmdfile <- file(cmdfilename)
  if(file.exists(cmdfilename)){
    cat(cmd, file=cmdfilename, append = TRUE, sep = '\n')
  }else{
    writeLines(cmd, cmdfile)
  }
  close(cmdfile)
}