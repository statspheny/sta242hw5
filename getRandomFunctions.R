shell=system

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








