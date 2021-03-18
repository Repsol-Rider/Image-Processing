library(raster)

dir <- "E:/GIS/INDICES"
indice_list <- list.dirs(dir,recursive=FALSE,full.names=FALSE)
copy_dir <- "E:/GIS/INDICES/CRS_CHANGED/"
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
            crs(r) <- "+proj=longlat +zone=43 +datum=WGS84 +units=m +no_defs"
            proj4string(r) <- crs("+proj=longlat +zone=43 +datum=WGS84 +units=m +no_defs")
            writeRaster(r,
                        filename=paste(copy_dir,paste(indice,indice_one_file_name,sep="/"),sep=""),
                        formate="GTiff",
                        datatype="FLT4S",
                        overwrite=TRUE
            )
            cat(paste("Projections for ",indice_one_file_name,": "))
            cat(projection(raster(paste(paste(copy_dir,indice,sep=""),indice_one_file_name,sep="/")),asText=TRUE),"\n")
        }
    }
    cat("\n")
}