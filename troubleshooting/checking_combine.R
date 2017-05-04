#! /usr/bin/env Rscript
# KKD for Sage Bionetworks
# 13 Jul 2016
 
 
setwd("TCX")
queryDir = dir()
length(queryDir)

firstData = read.delim(queryDir[1], header = FALSE, row.names =1, stringsAsFactors = FALSE)
ENSGnames = rownames(firstData)
expectedLength = nrow(firstData)


readHTS=function(inFile,rNames=ENSGnames,nrows=expectedLength){
  print(inFile)
  data = read.delim(inFile, header = FALSE, row.names =1, stringsAsFactors = FALSE)
  if (! nrow(data) == nrows) {
  	print(paste("Different number of input lines", inFile, sep = " ")) 
  	break
	}  
  nameCheck = which((rownames(data) == rNames) == FALSE)
  if (length(nameCheck) > 0) { 
  	print(paste("Mismatch of rownames at file", inFile, sep = " ")) 
  	break
  	}
  if (ncol(data) > 0) { return(data[,1]) }
  else {return(rep(NA,nrow(data))) }
}



pairedNames = queryDir[grep("paired",queryDir)]
length(pairedNames)
head(pairedNames) 
tail(pairedNames)

allDataPaired = sapply(as.list(pairedNames), readHTS)
# allDataRMpaired = matrix(NA, nrow = length(ENSGnames), ncol = length(pairedNames))
# iters = ceiling(length(pairedNames)/1000)
# for (i in 1:iters){
#	j = (i-1)*1000+1
#	print(j)
#	if (j == 14001) {
#		allDataRMpaired[,j:14188] = sapply(as.list(pairedNames[j:14188]),readHTS)	
#	}
#	else {
#		allDataRMpaired[,j:(j+999)] = sapply(as.list(pairedNames[j:(j+999)]),readHTS)
#	}
# }

colnames(allDataPaired) = pairedNames
rownames(allDataPaired) = ENSGnames
head(allDataPaired)
write.table(allDataPaired, file = "allDataMAYOpaired.txt", row.names = TRUE, col.names = TRUE, quote = FALSE)

