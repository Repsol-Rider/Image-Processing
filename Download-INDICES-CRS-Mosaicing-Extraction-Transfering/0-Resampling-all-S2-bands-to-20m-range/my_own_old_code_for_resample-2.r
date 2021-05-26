library(raster)
library(sp)

nir_b08 <- raster("D:/JOB/GIS/T43PHR/S2A_MSIL1C_20200528T050701_N0209_R019_T43PHR_20200528T082127.SAFE/GRANULE/L1C_T43PHR_A025756_20200528T051513/IMG_DATA/T43PHR_20200528T050701_B08.jp2")
swir_b11 <- raster("D:/JOB/GIS/T43PHR/S2A_MSIL1C_20200528T050701_N0209_R019_T43PHR_20200528T082127.SAFE/GRANULE/L1C_T43PHR_A025756_20200528T051513/IMG_DATA/T43PHR_20200528T050701_B11.jp2")
t <- resample(nir_b08,swir_b11, method='bilinear')
swir_r <- raster(t)
ndwi <- (nir_b08-swir_r)/(nir_b08+swir_r)
writeRaster(ndwi,
            "D:/JOB/ndwi_swir_r_nir.tif",
            datatype="FLT4S",
            format="GTiff"
            )

# plot(ndwi)
# writeRaster(ndwi,
#             "D:/JOB/new_ndwi_formula.tif",
#             datatype="FLT4S",
#             format="GTiff"
# )