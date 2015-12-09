pollutantmean <- function(directory,pollutant,id = 1:332){
        files_list <- list.files(directory, full.names = TRUE)
        dat <- data.frame()
        for (i in 1:332) {
                dat <- rbind(dat,read.csv(files_list[i]))
        }
        dat <- na.omit(dat)
        print(dat)
        #median(dat[pollutant][which(dat$id == id),pollutant])
        #mean(dat[pollutant][which(dat[,"ID"] == id),])
        mean(dat[[pollutant]])
}