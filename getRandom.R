shell = system

numObservationsPlusOne = shell("wc -l data/2000.csv", intern=TRUE)
numObservations = as.numeric(unlist(strsplit(numObservationsPlusOne," "))[1])-1

hundredKSample = sample(numObservations,10000)+1
hundredKSample = sort(hundredKSample)

hundredKSampleString = paste(hundredKSample, collapse="p -e ")

#cmd = sprintf("for i in %s; do head -$i data/2000.csv | tail -1 >> 2000sample.csv;\n done",hundredKSampleString)

cmd = sprintf("sed -n -e %sp data/2000.csv >> 2000sample.csv",hundredKSampleString)
shell("rm 2000sample.csv")
shell(cmd)

system.time(shell(cmd))

printSampleFromFile = function(infilename,outfilename,numSample=1000,numSplits=10){

  ## get the number of observations, but the first line is the header
  numObservationsCmd = sprintf("wc -l %s",infilename)
  numObservationsTmp = shell(numObservationsCmd,intern=TRUE)
  numObservations = as.numeric(unlist(strsplit(numObservationsTmp," "))[1])-1
  # print(numObservations)

  ## get numSample=100000 samples
  sampleIndex = sample(numObservations,numSample)
  sampleIndex = sort(sampleIndex)
  # print(sampleIndex)

  ## split to output numSplits=10 times for system
  if(numSample %% numSplits !=0)
    warning("numSample is not evenly divided by numSplits")

  shell(sprintf(">%s",outfilename))

  groupSample = matrix(sampleIndex,ncol=numSplits)

  split = apply(groupSample,2,groupPrintSampleFromFile,infilename,outfilename)


  ## groupSampleSize = numSample/numSplits
  
  ## for (i in 1:numSplits) {
  ##   groupSampleIndex = sampleIndex[(1:groupSampleSize)+((i-1)*groupSampleSize)]
  ##   groupSampleIndexString = paste(groupSampleIndex, collapse="p -e ")

  ##   groupSampleCmd = sprintf("sed -n -e %sp %s >> %s",
  ##     groupSampleIndexString,infilename, outfilename)
  ##   # print(groupSampleCmd)
  ##   shell(groupSampleCmd)
  ## }
    

}


groupPrintSampleFromFile = function(groupSampleIndex,infilename,outfilename) {
  groupSampleIndexString = paste(groupSampleIndex, collapse="p -e ")
  # print(groupSampleIndex)

  groupSampleCmd = sprintf("sed -n -e %sp %s >> %s",
    groupSampleIndexString, infilename,outfilename)
  shell(groupSampleCmd)
}


library(parallel)

cl = makeCluster(






