#! /usr/bin/env Rscript
# KKD for Sage Bionetworks
# May 17, 2016

library(argparse)

parser = ArgumentParser(description='Collect and sum assay level counts into a matrix file.')
parser$add_argument('--oPrefix', type="character", required=TRUE, help='Prefix for output files.')
parser$add_argument('--wd', default = getwd(), type="character", help='Directory for output files [default %(default)s].')
parser$add_argument('--splitChar', default = "_", help='Character on which to split the count file names.')
parser$add_argument('--segKeep', default = 2, type="integer", help='Number of filename seqments to retain for sample-level aggregation.')
parser$add_argument('--single', action='store_true', help='Use if combining single-end counts data.')
args = parser$parse_args()


setwd(args$wd)
x = dir()

shortNames = sapply(as.list(x),function(x){paste(unlist(strsplit(x,args$splitChar))[1:args$seqKeep],collapse = "_")})
samples = unique(shortNames)
head(samples)
length(x)
length(shortNames)


readHTS=function(inFile){
#  print(inFile)
  data = read.delim(inFile, header = FALSE, row.names =1)
  if (ncol(data) > 0) { return(data[,1]) }
  else {return(rep(NA,nrow(data))) }
}

sumAssayLevel=function(inSample,PEorSE="paired"){
    print(inSample)
    sample_assays = x[shortNames %in% inSample]
    samplePairedAssays = sample_assays[grep(PEorSE,sample_assays)]
    countsOriginal = sapply(as.list(samplePairedAssays), readHTS)
    return(rowSums(countsOriginal))
}

if (args$single) { collectedSums = sapply(as.list(samples),sumAssayLevel,PEorSE="single" )}
else { collectedSums = sapply(as.list(samples),sumAssayLevel) }
#save(collectedSums, file = paste(args$oPrefix, "collectedSums.Robj.gz", sep - "_"), compress = "bzip2")

tail(collectedSums)

data = read.delim(x[1], header = FALSE, row.names =1)
rownames(collectedSums) = rownames(data)
colnames(collectedSums) = samples
head(collectedSums)
write.table(collectedSums,file = paste(args$oPrefix, "counts_matrix.txt", sep = "_"), row.names = TRUE, col.names = TRUE, quote = FALSE, sep = "\t")


