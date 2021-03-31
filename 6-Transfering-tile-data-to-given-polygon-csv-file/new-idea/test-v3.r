library(raster)
# library(zoom)

ndvi <- raster("D:/INDICES/ndvi/reprojected/_T43PHR_20180906T050651.tif")
new_extent <- extent(78.0841966200489,78.0983266241176,14.0392004877398,14.0497157354592)
poly <- ndvi
poly <- setExtent(ndvi,new_extent,keepres=TRUE)
plot(poly)
dimen <- dim(poly)
num_of_pixels <- dimen[1]*dimen[2]
cat("Read",num_of_pixels,"Pixels in the given polygon")
ndvi
raster(poly)
values(poly)

# em <- merge(extent(ndvi),extent(poly))
# plot(em,type="n")
# # plot(ndvi,add=TRUE,legend=FALSE)
# plot(poly,add=TRUE,legend=FALSE,col="darkblue")
# # zm()