extractLocations <- function(location,dataset) {        
        DS = dataset # data.frame
        ll = location # vector
        locTrack = subset(DS,loc%in%ll,c("id","loc","start","dura","provider","dname",
                                          "type","pktsize","numreq","countDummy"))
        return(locTrack)
}