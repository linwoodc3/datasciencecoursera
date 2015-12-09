complete <- function(directory,id = 1:332){
        files_list <- list.files(directory, full.names = TRUE)
        dat <- data.frame()
        for (i in id) {
                dat <- rbind(dat,read.csv(files_list[i]))
        }
        
        cbind(id)
        nobs <- c()
        for(i in id) {
                nobs <- c(nobs, sum(complete.cases(dat[which(dat[,"ID"]==i),])))
        }
        c <- as.data.frame(cbind(id,nobs))
        print(c)
        
}