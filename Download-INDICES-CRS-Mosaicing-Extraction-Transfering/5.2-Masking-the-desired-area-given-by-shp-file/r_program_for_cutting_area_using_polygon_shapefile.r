library(raster)
library(rgdal)
#library(leaflet)

built_up  <- raster('D:/JOB/GIS/TILES_DATA/TS/INDICES/CRS_CHANGED/ndvi/ndvi.tif')
denpasar  <- readOGR('C:/Users/rakes/Downloads/Telangana/State_Boundary.shp')

denpasar <- spTransform(x = denpasar, CRSobj = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
masked <- mask(x = built_up, mask = denpasar)
cropped <- crop(x = masked, y = extent(denpasar))
plot(cropped)