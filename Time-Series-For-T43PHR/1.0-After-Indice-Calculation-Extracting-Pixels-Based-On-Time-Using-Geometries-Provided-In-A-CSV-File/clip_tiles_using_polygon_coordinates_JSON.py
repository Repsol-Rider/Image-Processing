import pandas as pd
import os,rioxarray,warnings,json,datetime

warnings.filterwarnings("ignore")
polygons_csv_file_path = "D:/JOB/GITHUB/Image-Processing/Time-Series-For-T43PHR/1.0-After-Indice-Calculation-Extracting-Pixels-Based-On-Time-Using-Geometries-Provided-In-A-CSV-File/test.csv"
indice_folder_path = "D:/JOB/GIS/T43PHR_PROJECT/INDICES"
json_file = "D:/JOB/GIS/T43PHR_PROJECT/TEST/JSON/only_ndvi.json"
cus_struc = { 'data' : {} }
user_indice_list = ('ndvi',) #evi2,ndvi,ndwi,npcri,savi
csv_df = pd.read_csv(polygons_csv_file_path)
indice_folders = os.listdir(indice_folder_path)
for indice in indice_folders:
    if(indice in user_indice_list):
        print("_________"+indice+"_________",sep="",end="\n")
        cus_struc['data'][indice] = {}
        indice_dir = indice_folder_path+"/"+indice
        files_in_indice_dir = os.listdir(indice_dir)
        for file in files_in_indice_dir:
            date = file[7:15]
            date = str(date[0])+str(date[1])+str(date[2])+str(date[3])+"-"+str(date[4])+str(date[5])+"-"+str(date[6])+str(date[7])
            start_time = datetime.datetime.now()
            print(" "+date+" ",sep="",end="")
            cus_struc['data'][indice][date],r = [],0
            for polygon in csv_df['WKT']:
                indice_file_path = indice_dir+"/"+file
                polygon_id = csv_df['PID'][r]
                r = r + 1
                poly_geo = polygon[16:len(polygon)-3]
                poly_geo = poly_geo.replace(","," ")
                poly_geo = poly_geo.split()
                gcords,coords = [],[]
                for s in range(0,len(poly_geo),2):
                    coords.append([float(poly_geo[s]),float(poly_geo[s+1])])
                gcoords = [coords]
                geometries = [
                    {
                        'type': 'Polygon',
                        'coordinates': gcoords
                    }
                ]
                clipped = rioxarray.open_rasterio(indice_file_path,masked=True,).rio.clip(geometries, from_disk=True)
                clip_np = clipped.values
                x=len(clip_np[0])
                y=len(clip_np[0][0])
                str_len,indice_min,indice_max,indice_mean,indice_sum = 0,99999,-99999,0,0
                for i in range(x):
                    for j in range(y):
                        if str(clip_np[0][i][j]) != "nan":
                            temp_min = str(clip_np[0][i][j])
                            if float(temp_min) <= float(indice_min):
                                indice_min = temp_min
                for i in range(x):
                    for j in range(y):
                        if str(clip_np[0][i][j]) != "nan":
                            temp_max = str(clip_np[0][i][j])
                            if float(temp_max) >= float(indice_max):
                                indice_max = temp_max
                for i in range(x):
                    for j in range(y):
                        if str(clip_np[0][i][j]) != "nan":
                            indice_mean = indice_mean + clip_np[0][i][j]
                            str_len = str_len + 1
                if str_len != 0:
                    indice_mean = indice_mean/str_len
                for i in range(x):
                    for j in range(y):
                        if str(clip_np[0][i][j]) != "nan":
                            indice_sum = indice_sum + clip_np[0][i][j]
                polygon_structure = {"PID":polygon_id,"Geometry":polygon,"min":indice_min,"max":indice_max,"mean":indice_mean,"sum":indice_sum }
                cus_struc['data'][indice][date].append(polygon_structure)
            end_time = datetime.datetime.now()
            print("Calculated Min,Max,Mean,Sum of "+str(r)+" Polygons, Time Taken : "+str(end_time-start_time)+"(HH:MM:SS)",sep="",end="\n")
with open(json_file,'w') as fp:
    json.dump(cus_struc,fp) 