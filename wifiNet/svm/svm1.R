library(e1071)
library(rpart)

#=== 4 classes svm
u1 = 11000752
u2 = 11001313
u3 = 11003224
u4 = 11004849
uid = c(u1,u2,u3,u4)
#===

netdata = read.csv("netDataSplit.csv")
netdata = extractUsers(uid,netdata)
index = 1:nrow(netdata)
netdata = subset(netdata,select=-c(countDummy))
netdata$id = as.factor(netdata$id)
testindex = sample(index, trunc(length(index)/3)) # 2/3 training
        testset = netdata[testindex,]
        trainset = netdata[-testindex,]
#===
svm.model = svm(id ~ .,data=trainset,cost=100,gamma=1)
svm.pred = predict(svm.model, testset[,-1])

#rpart.model = rpart(id ~ ., data = trainset)
#rpart.pred = predict(rpart.model, testset[,-1], type = "class")

table(pred = svm.pred, true = testset[,1])
