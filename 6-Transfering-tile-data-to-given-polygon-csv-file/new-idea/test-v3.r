library(raster)
# library(zoom)

r1 <- raster("D:/JOB/GIS/CRS_CHANGED/ndvi/T43PHR_20180906T050651.tif")
new_extent <- extent(78.0841966200489,78.0983266241176,14.0392004877398,14.0497157354592)
r2 <- setExtent(r1,new_extent,keepres=TRUE)

raster(r2)
plot(r2)

# em <- merge(extent(r1),extent(r2))
# plot(em,type="n")
# # plot(r1,add=TRUE,legend=FALSE)
# plot(r2,add=TRUE,legend=FALSE,col="darkblue")
# # zm()