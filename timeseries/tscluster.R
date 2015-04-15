tscluster <- function(x, start, period, num.intervals) {
        return(findInterval(x, as.POSIXct(start)+0:num.intervals*period))
}

#:test
#2014-09-01 05:49:10
#cut(ts1$time, as.POSIXct("2014-09-01 05:00:00 CST")+0:900)
#findInterval(ts1$time, as.POSIXct("2014-09-01 05:00:00 UTC")+0:120*60)