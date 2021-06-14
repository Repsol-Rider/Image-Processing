from osgeo import gdal
import pandas as pd
import numpy as np
import os
import matplotlib.pyplot as plt

# change this directory to the tiff file location
tiff_dir = "D:/JOB/GIS/PIXEL_DATA/TS_CLIPED/ts_clipped.tif"

# change this directory for temporary storage of data should be > 100gb
temp_data_storage_dir = "D:/JOB/GIS/PIXEL_DATA/TS_CLIPED/data/"

ds = gdal.Open(tiff_dir)

# TIFF to CSV 
xyz_file_path = temp_data_storage_dir+"ts_clipped.xyz"
xyz = gdal.Translate(xyz_file_path, ds)
xyz = None

df = pd.read_csv(xyz_file_path, sep = " ", header = None)
df.columns = ["x","y", "value"]

# we will get pixel values that are '0', to delete those pixel rows use this method
df = df[df.value != 0]

# generating unique ids and storing them in a list to attach to the dataframe
uids = []
for i in range(len(df)):
    uids.append("TS_"+str((len(df)-len(str(i+1)))*"0")+str(i+1))

# now add an unique id list into the dataframe.
df["Unique_ID"] = uids
uids = []

# save it in csv
df.to_csv(temp_data_storage_dir+"ts_clipped.csv", index = False)

