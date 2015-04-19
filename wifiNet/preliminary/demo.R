#==========Dependencies==========
library(plyr)
library(e1071)
library(rpart)
library(ggplot2)

#================================


#==========Reading & Manipulating==========
D = 1


toacc = read.table("merchantdemo.txt", 
                   sep="\t", 
                   header = TRUE, 
                   fill=FALSE, 
                   strip.white=TRUE)

fromacc = read.table("accountdemo.txt", 
                     sep="\t", 
                     header = TRUE, 
                     fill=FALSE, 
                     strip.white=TRUE)

trans = read.table("tradedemo.txt", 
                   sep="\t", 
                   header = TRUE, 
                   fill=FALSE, 
                   strip.white=TRUE)

weather = read.table("shanghaiqixiangdemo.txt", 
                     sep="\t", 
                     header = TRUE, 
                     fill=FALSE, 
                     strip.white=TRUE)

colnames(trans) = c("from","to","sysc","time","val")
colnames(toacc) = c("sysc","codename","to","tname","addr","opendate")
colnames(fromacc) = c("from","fname","gender","birth","grade","ftype")
colnames(weather) = c("time","place","T","rain","wind_dir","wind_speed","fog","humidity",
                      "pressure","Tmax","Tmin","wsmax","wd_at_wsmax")
trans$time = strftime(trans$time,"%Y-%m-%d %H:%M:%S")

#create features

fromsum = tapply(trans$val,trans$from,sum)
tosum = tapply(trans$val,trans$to,sum)
frommean = tapply(trans$val,trans$from,mean)
tomean = tapply(trans$val,trans$to,mean)

FF = data.frame(fromsum,frommean)
FF$numTrans = fromsum/frommean
FF$numTranspD = FF$numTrans/D

TT = data.frame(tosum,tomean)
TT$numTrans = tosum/tomean
TT$numTranspD = TT$numTrans/D


colnames(FF) = c("sum","mean","numTrans","numTransPerDay")
colnames(TT) = c("sum","mean","numTrans","numTransPerDay")
#toacc = toacc[-1,]

#================Summary================
summary(FF)
plot(FF$sum)
#===============Visualize===============
qplot(TT$sum,TT$numTransPerDay,data = TT)
qplot(TT$sum,TT$mean,data = TT)
qplot(FF$sum, data=FF, geom="histogram")
qplot(factor(FF$numTransPerDay), FF$sum, data = FF, geom = "boxplot")
