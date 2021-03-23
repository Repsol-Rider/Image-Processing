library(raster)
library(rgdal)

dir <- "D:/JOB/GIS/CRS_CHANGED/"
csv_dir <- paste(dir,"CSV",sep="")
dir.create(csv_dir,showWarnings=FALSE,recursive=FALSE,mode=0777)
indice_from_dir <- list.dirs(dir,recursive=FALSE,full.names=FALSE)
original_indice_list <- c("ndvi","ndwi","savi","npcri","lswi")
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
      csv_file_dir <- paste(paste(out_dir,file_name,sep="/"),"csv",sep=".")
      write.csv(data,csv_file_dir,row.names=FALSE)
      if(file.exists(csv_file_dir)){
        cat("Successfully stored ",file_name," values in ",paste(file_name,"csv",sep=".")," File \n")
      }else{
        cat("Failed To Store Values for tiff file ",paste(file_name,"tiff",sep="."),"\n")
      }
    }
  }
}