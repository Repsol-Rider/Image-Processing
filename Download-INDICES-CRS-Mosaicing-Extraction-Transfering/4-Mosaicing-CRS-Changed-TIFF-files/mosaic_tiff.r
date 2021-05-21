library(gdalUtils)
library(raster)

indice_dir <- "D:/JOB/GIS/TILES_DATA/TS/INDICES/CRS_CHANGED/"
indice_list <- c("ndvi")
for(indice in indice_list){
  setwd(paste(indice_dir,paste(indice,"",sep="/"),sep=""))
  indice_file_vrt <- paste(indice,"vrt",sep=".")
  indice_file_tif <- paste(indice,"tif",sep=".")
  gdalbuildvrt(gdalfile = "*.tif", # uses all tiffs in the current folder
               output.vrt = indice_file_vrt)
  gdal_translate(src_dataset = indice_file_vrt, 
                 dst_dataset = indice_file_tif, 
                 output_Raster = TRUE,
                 options = c("BIGTIFF=YES", "COMPRESSION=LZW"))
  unlink(indice_file_vrt,force=FALSE,recursive=FALSE)
  plot(raster(paste(indice_dir,indice_file_tif,sep="/")))
}

# https://stackoverflow.com/questions/50234139/using-mosaic-in-r-for-merge-multiple-geotiff
