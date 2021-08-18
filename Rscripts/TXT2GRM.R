ip <- installed.packages()
if (length(grep("AGHmatrix", ip)) == 0) install.packages("AGHmatrix")
library(AGHmatrix)

genoFilename = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq/matrix.codominant.txt"
outdir = "/home/yaw/Documents/Grape/Horizon_x_Illinois547-1/rhampseq"
data_table = read.table(genoFilename, header=TRUE, sep="\t", row.names=1)
data_matrix = as.matrix(data_table)

#Computing the additive relationship matrix based on VanRaden 2008
G_VanRadenPine <- Gmatrix(SNPmatrix=data_matrix, missingValue=-1, maf=0., method="VanRaden", ploidy = 2)

outfilename = paste(outdir,"/GRM.txt", sep="")
write.table(G_VanRadenPine, file=outfilename, row.names=TRUE, col.names=TRUE, sep="\t")

data(snp.pine)
#Computing the additive relationship matrix based on VanRaden 2008
G_VanRadenPine <- Gmatrix(SNPmatrix=snp.pine, missingValue=-9,
                          maf=0.05, method="VanRaden")
