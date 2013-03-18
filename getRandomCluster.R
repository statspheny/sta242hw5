library(parallel)

source("getRandomFunctions.R")

printSampleFromFileWrapper = function(year) {
  infilename = sprintf("data/%s.csv",year)
  outfilename = sprintf("sampledata/sample%s.csv",year)
  numSample = 100000
  numSplits = 10
  printSampleFromFile(infilename,outfilename,numSample,numSplits)
  Sys.getpid()
}


cl = makeCluster(8,type="FORK")

clusterSetRNGStream(cl,iseed=1234)

years = 1987:2008

results = parSapplyLB(cl,years,printSampleFromFileWrapper)

stopCluster(cl)


shell("cat sampledata/*.csv >> sampleall.csv")


