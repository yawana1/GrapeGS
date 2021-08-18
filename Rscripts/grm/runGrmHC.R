source("/home/yn259/workspace/GrapeGS/Rscripts/grm/SNPreadyGmatrix.R")

# GBS
gmatrix(outdir = '/media/yn259/data/research/HC/gbs/filtered',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/gbs/filtered',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE)
gmatrix(outdir = '/media/yn259/data/research/HC/gbs/filtered',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)

gmatrix(outdir = '/media/yn259/data/research/HC/gbs/none',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/gbs/none',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE)
gmatrix(outdir = '/media/yn259/data/research/HC/gbs/none',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)


# haplotype
gmatrix(outdir = '/media/yn259/data/research/HC/rh/filtered',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/rh/filtered',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE)
gmatrix(outdir = '/media/yn259/data/research/HC/rh/filtered',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)

gmatrix(outdir = '/media/yn259/data/research/HC/rh/none',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/rh/none',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE)
gmatrix(outdir = '/media/yn259/data/research/HC/rh/none',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)


# SNP
gmatrix(outdir = '/media/yn259/data/research/HC/snp/filtered',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/snp/filtered',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE) # errors out
gmatrix(outdir = '/media/yn259/data/research/HC/snp/filtered',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)

gmatrix(outdir = '/media/yn259/data/research/HC/snp/none',
        infilename = 'matrix.incidence.txt',
        outfilename = 'grm.incidence.txt',
        base = FALSE)
gmatrix(outdir = '/media/yn259/data/research/HC/snp/none',
        infilename = 'matrix.snp.txt',
        outfilename = 'grm.snp.txt',
        base = TRUE) 
gmatrix(outdir = '/media/yn259/data/research/HC/snp/none',
        infilename = 'matrix.maf.txt',
        outfilename = 'grm.maf.txt',
        base = FALSE)


# rQTL
# gmatrix(outdir = '/media/yn259/data/research/HC/rqtl',
#         infilename = 'matrix.maf.txt',
#         outfilename = 'grm.maf.txt',
#         base = FALSE)

# source("/home/yn259/workspace/GrapeGS/scripts/grm.R")
# grm(outdir = "/media/yn259/data/research/HC/rqtl",
#     genoFilename = "matrix.M.txt",
#     freqFilename = "matrix.P.txt",
#     outfilename = "grm.maf.txt",
#     population = "Horizon_x_Illinois547-1")
