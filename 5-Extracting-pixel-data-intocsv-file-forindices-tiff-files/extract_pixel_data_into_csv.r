library(raster)
library(rgdal)

dir <- "E:/GIS/DOWNLOADED_43PHR/INDICES/"
csv_dir <- paste(dir,"CSV",sep="")
dir.create(csv_dir,showWarnings=FALSE,recursive=FALSE,mode=0777)
indice_from_dir <- list.dirs(dir,recursive=FALSE,full.names=FALSE)
original_indice_list <- c("ndvi")
for(dir_indice in indice_from_dir){
    if(dir_indice %in% original_indice_list){
        set_dir <- paste(dir,dir_indice,sep="")
        out_dir <- paste(csv_dir,dir_indice,sep="/")
        dir.create(out_dir,showWarnings=FALSE,recursive=FALSE,mode=0777)
        indice_tiff_files <- list.files(set_dir,full.names=TRUE)
        for(tiff in indice_tiff_files){
            r <- raster(tiff)
            file_name <- names(r)
            pts <- rasterToPoints(r,spatial=TRUE)
            data <- data.frame(pts)
            tile_name <- substr(file_name,1,6)
            unique_id <- sprintf(paste(tile_name,"%d",sep="_"),seq(nrow(data[1])))
            unique_id <- data.frame(Unique_ID=unique_id,stringsAsFactors=FALSE)
            data <- data.frame(unique_id,data[2],data[3],data[1])
            names(data)[names(data) == file_name] <- dir_indice
            csv_write_dir <- paste(csv_dir,paste(names(r),"csv",sep="."),sep="/")
            csv_file_final <- write.csv(data,csv_write_dir,row.names=FALSE)
            if(file.exists(csv_write_dir)){
                cat("Successfully stored ",file_name," values in ",paste(file_name,"csv",sep=".")," File \n")
            }else{
                cat("Failed To Store Values for tiff file ",paste(file_name,"tiff",sep="."),"\n")
            }
        }
    }
}
