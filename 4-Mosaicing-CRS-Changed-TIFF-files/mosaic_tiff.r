library(gdalUtils)
setwd("D:/JOB/GIS/CRS_CHANGED/ndvi/")
gdalbuildvrt(gdalfile = "*.tif", # uses all tiffs in the current folder
             output.vrt = "ndvi.vrt")
gdal_translate(src_dataset = "ndvi.vrt", 
               dst_dataset = "ndvi.tif", 
               output_Raster = TRUE,
               options = c("BIGTIFF=YES", "COMPRESSION=LZW"))
plot("ndvi.tif")


# https://stackoverflow.com/questions/50234139/using-mosaic-in-r-for-merge-multiple-geotiff
