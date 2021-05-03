library(raster)
library(sp)

r <- raster("test_raster_10m_band.jp2")
s <- raster("test_raster_20m_band.jp2")
t <- resample(r, s, method='bilinear')
plot(t)