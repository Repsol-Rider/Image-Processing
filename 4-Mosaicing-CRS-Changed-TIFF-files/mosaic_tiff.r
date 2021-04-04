library(gdalUtils)
library(raster)
setwd("D:/JOB/GIS/TS/INDICES/CRS_CHANGED/ndvi/")
gdalbuildvrt(gdalfile = "*.tif", # uses all tiffs in the current folder
             output.vrt = "ndvi.vrt")
gdal_translate(src_dataset = "ndvi.vrt", 
               dst_dataset = "ndvi.tif", 
               output_Raster = TRUE,
               options = c("BIGTIFF=YES", "COMPRESSION=LZW"))
plot(raster("D:/JOB/GIS/TS/INDICES/CRS_CHANGED/ndvi/ndvi.tif"))


# https://stackoverflow.com/questions/50234139/using-mosaic-in-r-for-merge-multiple-geotiff
