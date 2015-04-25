userSummary <- function(userId,dataset) {
        
        VV = dataset
        u11 = userId
        
        userTrack = subset(VV,id==u11,c("id","loc","start","dura","provider","dname",
                                        "type","pktsize","numreq","countDummy"))
        UU1 = userTrack
        u1_timeByLoc = aggregate(UU1$dura,list(UU1$loc),sum)
        u1_reqByService = aggregate(UU1$numreq,list(UU1$provider),sum)
        u1_reqByType = aggregate(UU1$numreq,list(UU1$type),sum)
        u1_flowByType = aggregate(UU1$pktsize,list(UU1$type),sum)
        u1_flowByService = aggregate(UU1$pktsize,list(UU1$provider),sum)
        u1_byType = data.frame(u1_flowByType$Group.1,u1_flowByType$x,u1_reqByType$x)
        u1_byService = data.frame(u1_flowByService$Group.1,u1_flowByService$x,
                                  u1_reqByService$x)
        u1_byLoc = data.frame(u1_timeByLoc$Group.1,u1_timeByLoc$x)
        colnames(u1_byType) = c("group","pktsize","numreq")
        colnames(u1_byService) = c("group","pktsize","numreq")
        colnames(u1_byLoc) = c("group","dura")
        u1_byType$row = 1:dim(u1_byType)[1]
        u1_byService$row = 1:dim(u1_byService)[1]
        u1_byLoc$row = 1:dim(u1_byLoc)[1]
        return(list(u1_byType,u1_byService,u1_byLoc))
}
