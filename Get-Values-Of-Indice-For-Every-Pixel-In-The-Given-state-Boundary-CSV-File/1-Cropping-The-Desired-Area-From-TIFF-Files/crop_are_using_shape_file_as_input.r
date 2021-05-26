library(raster)
library(rgdal)
library(leaflet)

tempfile(tmpdir="D:/JOB/GIS/PIXEL_DATA/Temp")


built_up  <- raster('<tiff file location>')
denpasar  <- readOGR('<shape file location>') #shape file that lies under that tiff file provided

denpasar <- spTransform(x = denpasar, CRSobj = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
masked <- mask(x = built_up, mask = denpasar)
cropped <- crop(x = masked, y = extent(denpasar))
plot(cropped)