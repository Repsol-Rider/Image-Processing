library(raster)
library(sf)

dir <- "D:/JOB/GIS"
indice_list <- list.dirs(dir,recursive=FALSE,full.names=FALSE)
copy_dir <- paste(dir,"CRS_CHANGED/",sep="/")
dir.create(copy_dir,showWarnings=FALSE,recursive=FALSE,mode=0777)
main_indices <- c("ndvi","ndwi","savi")
for(indice in indice_list){
  if(indice %in% main_indices ){
    indice_dir <- paste(dir,indice,sep="/")
    dir.create(paste(copy_dir,indice,sep="/"),recursive=FALSE,mode=0777,showWarnings=FALSE)
    indice_dir_list <- list.files(indice_dir,pattern="\\.tif$",full.names=TRUE)
    for(a_file in indice_dir_list){
      indice_one_file_name <- substr(a_file,nchar(indice_dir)+2,nchar(a_file))
      r <- raster(a_file)
      r2 <- projectRaster(r,crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
      writeRaster(r2,filename=paste(copy_dir,paste(indice,indice_one_file_name,sep="/"),sep=""),overwrite=TRUE)
      rtempdir <- paste(tempdir(),"raster",sep="\\")
      if(dir.exists(rtempdir)){
        rtempdir_files <- list.files(rtempdir,pattern=NULL,full.names=TRUE)
        for(temp_file in rtempdir_files){
          unlink(temp_file,force=FALSE)
        }
      }else{
        print("Raster Directory Doesn't exist!")
      }
      cat(paste("Projections for ",indice_one_file_name,": \n"))
      cat(raster(paste(paste(copy_dir,indice,sep=""),indice_one_file_name,sep="/")),"\n ------------------------------------ \n")
    }
  }
  cat("\n")
}