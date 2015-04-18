library(plyr)
library(scales)
library(e1071)
library(rpart)
library(ggplot2)
library(ttutils)

users = read.table("netuserssample.txt", 
                   sep=",", 
                   header = FALSE, 
                   fill=FALSE, 
                   strip.white=TRUE)

net = read.table("nettrafficsample.txt", 
                 sep=",", 
                 header = FALSE, 
                 fill=FALSE, 
                 strip.white=TRUE)

colnames(net) = c("id","loc","start","dura","provider","type",
                  "dname","pktsize","reqnum")
colnames(users) = c("id","gender","birth","grade")

obs = dim(net)[1]
features = dim(net)[2]

net$provider = strsplit(as.character(net$provider),';')
net$type = strsplit(as.character(net$type),';')
net$dname = strsplit(as.character(net$dname),';')
net$pktsize = strsplit(as.character(net$pktsize),';')
net$reqnum = strsplit(as.character(net$reqnum),';')
net$loc = as.vector(net$loc)

provvec = c()
dnamevec = c()
typevec = c()
sizevec = c()
nreqvec = c()
locvec = c()
idvec = c()
startvec = c()
duravec = c()

for (i in 1:obs) {
        provvec = c(provvec,net$provider[i][[1]])
        dnamevec = c(dnamevec,net$dname[i][[1]])
        typevec = c(typevec,net$type[i][[1]])
        sizevec = c(sizevec,net$pktsize[i][[1]])
        nreqvec = c(nreqvec,net$reqnum[i][[1]])
        idvec = c(idvec,rep(net$id[i],length(net$provider[i][[1]])))
        locvec = c(locvec,rep(net$loc[i],length(net$provider[i][[1]])))
        startvec = c(startvec,rep(net$start[i],length(net$provider[i][[1]])))
        duravec = c(duravec,rep(net$dura[i],length(net$provider[i][[1]])))
        
}
VV = data.frame(idvec,locvec,startvec,duravec,provvec,dnamevec,typevec,sizevec,nreqvec)
VV$loc = as.vector(VV$loc)
colnames(VV) = c("id","loc","start","dura","provider","dname","type","pktsize","numreq")

VV$countDummy = 1 
VV$provider = as.vector(VV$provider)
VV$dname = as.vector(VV$dname)
VV$type = as.vector(VV$type)
VV$pktsize = as.numeric(as.vector(VV$pktsize))
VV$numreq = as.numeric(as.vector(VV$numreq))

#=====

duraByLoc = tapply(VV$dura,VV$loc,sum)
sizeByLoc = tapply(VV$pktsize,VV$loc,sum)
numreqByLoc = tapply(VV$numreq,VV$loc,sum)
indvisitcountByLoc = tapply(VV$countDummy,VV$loc,sum)
sumbyLoc = data.frame(duraByLoc, sizeByLoc, numreqByLoc, indvisitcountByLoc)
sumbyLoc$row = 1:dim(sumbyLoc)[1]
colnames(sumbyLoc) = c("dura","pktsize","reqnum","count","rownum")

VV_u1 = unique(data.frame(VV$provider))
countByService = tapply(VV$countDummy,list(VV$provider),sum)
sizeByService = tapply(VV$pktsize,list(VV$provider),sum)
msizeByService = tapply(VV$pktsize,list(VV$provider),mean)
mesizeByService = tapply(VV$pktsize,list(VV$provider),median)
reqnumByService = tapply(VV$numreq,list(VV$provider),sum)
mreqnumByService = tapply(VV$numreq,list(VV$provider),mean)
mereqnumByService = tapply(VV$numreq,list(VV$provider),median)
sumbyService = data.frame(countByService,
                           sizeByService,msizeByService,mesizeByService,
                           reqnumByService,mreqnumByService,mereqnumByService)
sumbyService$row = 1:dim(sumbyService)[1]
colnames(sumbyService) = c("count","pktsize_sum","pktsize_mean",
                           "pktsize_median","reqnum_sum","reqnum_mean","reqnum_median","rownum")

#=====
#track location
t1 = "东上院"
locTrack = subset(VV,loc==t1,c("id","loc","start","dura","provider","dname",
                              "type","pktsize","numreq","countDummy"))

#=====
# user summary
u1 = 11000752 #
u2 = 11001313
userTrack = subset(VV,id==u1,c("id","loc","start","dura","provider","dname",
                                "type","pktsize","numreq","countDummy"))
summary_u1 = userSummary(u1,VV)
u1_byType = summary_u1[[1]]
u1_byService = summary_u1[[2]]
u1_byLoc = summary_u1[[3]]
#u1_byType$pktsize_log = log(u1_byType$pktsize)

summary_u2 = userSummary(u2,VV)
u2_byType = summary_u2[[1]]
u2_byService = summary_u2[[2]]
u2_byLoc = summary_u2[[3]]


cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", 
                "#0072B2", "#D55E00", "#CC79A7")
scale_fill_manual(values=cbPalette)

bp2 = ggplot(data=u1_byType, aes(x=row, y=pktsize, fill=row)) +
        geom_bar(colour="black", stat="identity") + guides(fill=FALSE)
bp2 = bp2 + scale_y_continuous(trans=log10_trans())

bp3 = ggplot(data=u1_byLoc, aes(x=row, y=dura, fill=row)) +
        geom_bar(colour="black", stat="identity") + guides(fill=FALSE)
bp3 = bp3 + scale_y_continuous(trans=log10_trans())
     #  + coord_trans(y="log10") # Package Bug

bp4 = ggplot(data=u1_byLoc, aes(x=factor(1), y=dura, fill=row))+
        geom_bar(width = 1, stat = "identity") + guides(fill=FALSE)
bp4 = bp4 + coord_polar("y", start=0)

bp5 = ggplot(data=u2_byLoc, aes(x=factor(1), y=dura, fill=row))+
        geom_bar(width = 1, stat = "identity") + guides(fill=FALSE)
bp5 = bp5 + coord_polar("y", start=0)

bp6 = ggplot(data=u1_byType, aes(x=factor(1), y=pktsize, fill=row))+
        geom_bar(width = 1, stat = "identity") + guides(fill=FALSE)
bp6 = bp6 + coord_polar("y", start=0)

bp7 = ggplot(data=sumbyLoc, aes(x=factor(1), y=duraByLoc,fill=row))+
        geom_bar(width = 1, stat = "identity") + guides(fill=FALSE)
bp7 = bp7 + coord_polar("y", start=0)

bp8 = ggplot(data=sumbyLoc, aes(x=row, y=duraByLoc)) +
        geom_bar(colour="black", stat="identity") + guides(fill=FALSE)
#bp8 = bp8 + scale_y_continuous(trans=log10_trans())
#=====

write.csv(VV,"netDataSplit.csv")
#write.csv(userTrack,"userTrack.csv")
write.csv(locTrack,"locationTrack.csv")
write.csv(userTrack,"userTrack.csv")
write.csv(sumbyLoc,"summary_by_location.csv")
write.csv(sumbyService,"summary_by_service.csv")
write.csv(u1_byLoc,"user11000752_location.csv")
write.csv(u1_byService,"user11000752_service.csv")
write.csv(u1_byType,"user11000752_type.csv")

# log2 coordinate transformation (with visually-diminishing spacing)

