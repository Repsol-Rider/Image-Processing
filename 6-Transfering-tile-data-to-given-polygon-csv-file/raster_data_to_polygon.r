library(sf)
library(raster)
library(exactextractr)

polygons <- st_read('testdata/Polygons.shp')
grid <- raster('testdata/Raster.tif')

polygons$result <- exact_extract(grid, polygons, fun = weighted.mean)
example <- polygons[c(1:4, 19:27), 'result']
st_geometry(example) <- NULLprint(example)
        
        
# result
# 1  -63.95060
# 2  -67.00000
# 3  -67.00000
# 4  -62.37653
# 19 -99.94981
# 20 -92.79999
# 21 -92.79999
# 22 -98.04804
# 23 -91.76212
# 24 -91.76212
# 25 -87.48955
# 26 -86.00000
# 27 -86.00000
