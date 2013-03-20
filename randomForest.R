library(randomForest)

shell = system

alldata = read.csv("sampleall.csv",head=FALSE)
print("read data")

datanames = shell("head -1 data/2000.csv",intern=TRUE)
datanames = unlist(strsplit(datanames,","))
names(alldata) = datanames

# smalldataIndex = sample(2200000,1000)
# alldata = alldata[smalldataIndex,]

dataNotNA = !is.na(alldata[,15])
alldata = alldata[dataNotNA,]
response = alldata[,15]
response = cut(response,c(min(response),-10,0,10,max(response)),include.lowest=TRUE)

print("impute data...")
#data.imputed = rfImpute(x=alldata[,c(1:20)[-c(11,15,17,18)]],y=response,na.action=na.omit)

#data.rf = randomForest(x=data.imputed[,-1],y=response,proximity=TRUE)
data.imputed = na.roughfix(alldata[,c(1:20)])
#data.rf = randomForest(x=data.imputed[,c(1:20)[-c(11,15,17,18)]],y=response,
#                         na.action=na.omit)

#data.rf = randomForest(x=data.imputed[,c(1:3)],y=response,
#                         na.action=na.omit)

print("first random forest...")
subset = 1:1000000
#data.rf = randomForest(x=data.imputed[subset,c(1:20)[-c(11,15,17,18)]],y=response[subset],na.action=na.omit)

doRandomForest = function(x) {
  subset = sample(length(response),1000000)
  tmp.rf = randomForest(x=data.imputed[subset,c(1:20)[-c(11,15,17,18)]],y=response[subset],na.action=na.omit)
  return(tmp.rf)
}

save.image("randomforesthalf.rda")

print("do parallel...")
library(parallel)
cl = makeCluster(4,type="FORK")
clusterSetRNGStream(cl,iseed=1234)

allrf = clusterApply(cl,1:4,doRandomForest)

stopCluster(cl)
save.image("randomForestResults.rda")
