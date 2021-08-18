asremlCV <- function(
  outdir, 
  phenofilename,
  geno1filename,
  geno2filename
){
  library(reshape2)
  
  # test parameters
  # outdir = "/media/yn259/data/Grape/RupestrisB38_x_Horizon"
  # phenofilename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/phenos/phenotypes_all.csv"
  # geno1filename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/rqtl/grm.maf.txt"
  # geno2filename = "/media/yn259/data/Grape/RupestrisB38_x_Horizon/rqtl/grm.tabular.txt"
  
  outdir = "/home/yn259/ExpanDrive/Cornell/research/xyz_example"
  phenofilename = "/home/yn259/ExpanDrive/Cornell/research/xyz_example/phenos/FruitQuality.csv"
  fileGrm = c("/home/yn259/ExpanDrive/Cornell/research/xyz_example/filtered/grm.incidence.txt",
              "/home/yn259/ExpanDrive/Cornell/research/xyz_example/filtered/grm.tabular.txt")
  fileMatrix = c("/home/yn259/ExpanDrive/Cornell/research/xyz_example/filtered/matrix.incidence.txt",
                "/home/yn259/ExpanDrive/Cornell/research/xyz_example/filtered/matrix.snp.txt")
  
  outdir = "/media/yn259/data/Grape/Horizon_x_Illinois547-1"
  phenofilename = "/media/yn259/data/Grape/Horizon_x_Illinois547-1/phenos/phenotype_faq.txt"
  geno1filename = "/media/yn259/data/Grape/Horizon_x_Illinois547-1/rqtl/grm.maf.txt"
  geno2filename = "/media/yn259/data/Grape/Horizon_x_Illinois547-1/rqtl/grm.tabular.txt"
  
  outdir = file.path(outdir, "asreml")
  dir.create(outdir, showWarnings = FALSE)
  setwd(outdir)
  
  # load and prep phenotype data
  sep = ifelse(endsWith(phenofilename, ".csv"), ",", "\t")
  phenoDat = read.table(phenofilename, header=TRUE, sep=sep, row.names=1)
  phenoDat = as.matrix(phenoDat)
  
  # load genotype data
  geno1Dat = read.table(geno1filename, header=TRUE, sep="\t", row.names=1)
  geno1Dat = as.matrix(geno1Dat)
  geno1Dat[geno1Dat == -1] <- NA
  geno1Name = tools::file_path_sans_ext(basename(geno1filename))
  
  geno2Dat = read.table(geno2filename, header=TRUE, sep="\t", row.names=1)
  geno2Dat = as.matrix(geno2Dat)
  geno2Dat[geno2Dat == -1] <- NA
  geno2Name = tools::file_path_sans_ext(basename(geno2filename))
  
  # asreml execute command
  cmd = c()
  
  for(phenoIndex in c(1:length(phenoDat[1,]))){
    P = phenoDat[,phenoIndex]
    P = P[!is.na(P)]
      phenoName = colnames(phenoDat)[phenoIndex]
    G1 = geno1Dat
    G2 = geno2Dat
    
    # Filter genomic relationship matrix
    lines = c()
    headers = c()
    for(item in names(P)){
      if(item %in% rownames(G1) && item %in% rownames(G2)){
        lines = append(lines, item)
        headers = append(headers, paste('X', item, sep=""))
      }
    }
    P = P[lines]
    G1 = G1[lines, headers]  
    colnames(G1) = lines
    # GIV1 = melt(G1)
    G2 = G2[lines, headers]  
    colnames(G2) = lines
    # GIV2 = melt(G2)
    
    phenodir = file.path(outdir, phenoName)
    dir.create(phenodir, showWarnings = FALSE)
    write.table(P, file = file.path(phenodir, 'data.asd'), sep = '\t', col.names = FALSE, quote = FALSE)
    write.table(G1, file = file.path(phenodir, paste(geno1Name, '.grm', sep = '')), sep = '\t', col.names = FALSE, row.names = FALSE,quote = FALSE)
    write.table(G2, file = file.path(phenodir, paste(geno2Name, '.grm', sep = '')), sep = '\t', col.names = FALSE, row.names = FALSE, quote = FALSE)
    
    # write out .as files
    as1 <- file(file.path(phenodir, paste(geno1Name, '.as', sep = '')))
    
    writeLines(c(
      paste('!NODISPLAY !XML !OUTFOLDER', geno1Name, sep = ' '),
      paste('Cross Validation with', phenoName, sep = ' '),
      paste('', 'Genotype !A', sep = ' '),
      paste('', phenoName, sep = ' '),
      paste('', 'CVgroup 5 !=Genotype !-1 !MOD 5 !+1', sep = ' '),
      '!CYCLE 1:6',
      paste(geno1Name, '.grm', sep = ''),
      'data.asd !SKIP 0 MAXIT 100 !EXTRA 5 !FILTER CVgroup !EXCLUDE $I  !KCV grm1(Genotype)',
      '',
      paste(phenoName, '~ mu !r grm1(Genotype)', sep = ' ')
    ), as1)
    
    close(as1)
    cmd = append(cmd, paste('pushd', phenoName, sep = ' '))
    cmd = append(cmd, paste('asreml', paste(geno1Name, '.as', sep = ''), sep = ' '))
    
    as2 <- file(file.path(phenodir, paste(geno2Name, '.as', sep = '')))
    
    writeLines(c(
      paste('!NODISPLAY !XML !OUTFOLDER', geno2Name, sep = ' '),
      paste('Cross Validation with', phenoName, sep = ' '),
      paste('', 'Genotype !A', sep = ' '),
      paste('', phenoName, sep = ' '),
      paste('', 'CVgroup 5 !=Genotype !-1 !MOD 5 !+1', sep = ' '),
      '!CYCLE 1:6',
      paste(geno2Name, '.grm', sep = ''),
      'data.asd !SKIP 0 MAXIT 100 !EXTRA 5 !FILTER CVgroup !EXCLUDE $I  !KCV grm1(Genotype)',
      '',
      paste(phenoName, '~ mu !r grm1(Genotype)', sep = ' ')
    ), as2)
    
    close(as2)
    cmd = append(cmd, paste('asreml', paste(geno2Name, '.as', sep = ''), sep = ' '))
    cmd = append(cmd, 'popd')
  }
  
  # write out asreml shell script
  cmdFile <- file(file.path(outdir, 'runAsreml.sh'))
  writeLines(cmd, cmdFile)
  close(cmdFile)
}