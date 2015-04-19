extractUsers <- function(userId,dataset) {        
        DS = dataset # data.frame
        uid = userId # vector
        userTrack = subset(DS,id%in%uid,c("id","loc","start","dura","provider","dname",
                                        "type","pktsize","numreq","countDummy"))
        return(userTrack)
}
