from osgeo import gdal
import numpy as np
import matplotlib.pyplot as plt

ds = gdal.Open("D:/JOB/GIS/T43PHR_PROJECT/INDICES/ndvi/T43PHR_20180509T050701.tif")
array = ds.GetRasterBand(1).ReadAsArray()

dsReprj = gdal.Warp("D:/JOB/GIS/T43PHR_PROJECT/REPROJ/TEST.tif",ds,dstSRS = "EPSG:4326")
