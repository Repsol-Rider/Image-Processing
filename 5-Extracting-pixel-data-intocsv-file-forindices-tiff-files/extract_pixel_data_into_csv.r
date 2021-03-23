library(raster)
library(rgdal)

ras <- raster ("D:/T43PHR_20200528T050701.tif")
pts <- rasterToPoints(ras, spatial = TRUE)
data <- data.frame(pts)

print(data)
