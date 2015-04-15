#=======Formating======
weather$time = strptime(as.character(weather$time), 
                        "%Y%m%d%H%M")
trans$time = strptime(as.character(trans$time), 
                      "%Y-%m-%d %H:%M:%S")
trans$time = as.POSIXct(trans$time)
weather$time = as.POSIXct(weather$time)

#=======Tstest=======
ts1 = subset(trans, to==1000001, select=c("val","time"))
colnames(ts1) = c("val","time")

#group every 30seconds, from 05:00 to 07:00

ts1$II = tscluster(ts1$time,"2014-09-01 05:00:00 UTC",30,240)
ts1 = aggregate(ts1$val,list(ts1$II),sum)
ts1f = data.frame(c(1:240),0)
colnames(ts1) = c("group","val")
colnames(ts1f) = c("group","val")
ts1f = merge(ts1,ts1f,by.x = "group", by.y = "group", all = TRUE)
ts1f[is.na(ts1f)] = 0
colnames(ts1f) = c("timemins","val","0")


fig1 = qplot(ts1f$timemins,ts1f$val,data = ts1f)
fig1+geom_line()