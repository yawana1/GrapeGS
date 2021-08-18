library(ggfortify)

outdir = "/media/yn259/data/research/HIR/snp/none/"
filename = "matrix.incidence.txt"
pop = "samples.txt"

setwd(outdir)
df <- read.table(filename, header=TRUE, sep="\t", row.names=1)
# df <- df[colSums(!is.na(df)) > 0]
# df <- df[rowSums(!is.na(df)) > 0]

write.csv(rownames(df), pop, row.names = FALSE)

df_pop = read.table(pop, header=TRUE, sep="\t", row.names=1)
pca_res <- prcomp(df, scale. = FALSE)
autoplot(pca_res, data = df_pop, colour = 'population')
