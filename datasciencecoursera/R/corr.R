## function that looks through a directory of files, computers complete cases,
## and calculates the correlation of the sulfate and nitrate variables in the 
## files that meet the minimum threshold for complete cases.  
corr <- function(directory,threshold = 0){
        files_list <- list.files(directory, full.names = TRUE)
        dat <- data.frame()
        for (i in 1:332) {
                dat <- rbind(dat,read.csv(files_list[i]))
        }
        
        id <- cbind(1:332)
        cases <- c()
        for(i in 1:332) {
                cases <- c(cases, sum(complete.cases(dat[which(dat[,"ID"]==i),])))
        }
        c <- as.data.frame(cbind(id,cases))
        print(c)
        
        holder <- c["V1"][which(c$cases>threshold),"V1"]
        
        answers <- numeric(0)
        for (i in holder){
                if (length(holder)>1)
                        answers <- c(answers,cor(na.omit(dat[which(dat[,"ID"]==i),])["sulfate"],na.omit(dat[which(dat[,"ID"]==i),])["nitrate"]))
                else
                        return(answers)
                
        }
        
        answers
}