library(e1071)
library(rpart)
library(ggplot2)

#=== svm - predict location
loclist = read.csv("summary_by_location.csv")
locations = as.vector(loclist$X)
#===

netdata = read.csv("netDataSplit.csv")
netdata = extractLocations(locations,netdata)
index = 1:nrow(netdata)
netdata = subset(netdata,select=-c(countDummy))
netdata$loc = as.factor(netdata$loc)
testindex = sample(index, trunc(length(index)/3)) # 2/3 training
testset = netdata[testindex,]
trainset = netdata[-testindex,]
#===
svm.model = svm(loc ~ .,data=trainset,cost=100,gamma=1)
svm.pred = predict(svm.model, testset[,-2])

#rpart.model = rpart(id ~ ., data = trainset)
#rpart.pred = predict(rpart.model, testset[,-1], type = "class")

cmatrix = table(pred = svm.pred, true = testset[,2])
write.csv(cmatrix,"confusion_matrix.csv")

