import pandas as pd
import os,rioxarray,warnings

warnings.filterwarnings("ignore")
polygons_csv_file_path = "D:/JOB/GIS/T43PHR_PROJECT/POLYGONS_SHAPE_FILE/FAST/FAST_CSV/test.csv"
indice_folder_path = "D:/JOB/GIS/T43PHR_PROJECT/INDICES"
output_csv_folder_path = "D:/JOB/GIS/T43PHR_PROJECT/CSV"
user_indice_list = ("evi2") #evi2,ndvi,ndwi,npcri,savi
date_arr,indice_mean_arr,indices_df,count = [],[],pd.DataFrame(),1
csv_df = pd.read_csv(polygons_csv_file_path)
indice_folders = os.listdir(indice_folder_path)
for indice_folder in indice_folders:
    if indice_folder in user_indice_list:
        indice_dir = indice_folder_path+"/"+indice_folder
        files_in_indice_dir = os.listdir(indice_dir)
        for polygon in csv_df["WKT"]:
            poly_geo = polygon
            polygon = polygon[16:len(polygon)-3]
            polygon = polygon.replace(","," ")
            polygon = polygon.split()
            gcords,coords = [],[]
            for i in range(0,len(polygon),2):
                coords.append([float(polygon[i]),float(polygon[i+1])])
            gcoords = [coords]
            geometries = [
                {
                    'type': 'Polygon',
                    'coordinates': gcoords
                }
            ]
            print("Calculating "+indice_folder+" For Polygon : "+str(count))
            for tif_file in files_in_indice_dir:
                # date formating
                fd = tif_file[7:15]
                fd = str(fd[0])+str(fd[1])+str(fd[2])+str(fd[3])+"-"+str(fd[4])+str(fd[5])+"-"+str(fd[6])+str(fd[7])
                date_arr.append(fd)
                file_full_path = indice_dir+"/"+tif_file
                clipped = rioxarray.open_rasterio(file_full_path,masked=True,).rio.clip(geometries, from_disk=True)
                clip_np = clipped.values
                x=len(clip_np[0])
                y=len(clip_np[0][0])
                indice_mean,str_len = 0,0
                for i in range(x):
                    for j in range(y):
                        if str(clip_np[0][i][j]) != "nan":
                            indice_mean = indice_mean + clip_np[0][i][j]
                            str_len = str_len + 1
                if str_len != 0:
                    indice_mean = indice_mean/str_len
                indice_mean_arr.append(indice_mean)
            count = count + 1
            if(indices_df.empty):
                dic = { "date" : date_arr, poly_geo : indice_mean_arr }
                indices_df = pd.DataFrame(dic)
            else:
                dic = { "date" : date_arr , poly_geo : indice_mean_arr }
                temp_df = pd.DataFrame(dic)
                indices_df = pd.merge(indices_df, temp_df, on="date")
            indice_mean_arr = []
            date_arr = []
        indices_df = indices_df.T
        indices_df.to_csv(output_csv_folder_path+"/"+indice_folder+".csv",header=False)