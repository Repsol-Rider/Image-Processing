import json,os
import pandas as pd

csv_list_dir = "D:/JOB/GITHUB/Image-Processing/Time-Series-For-T43PHR/1.0-After-Indice-Calculation-Extracting-Pixels-Based-On-Time-Using-Geometries-Provided-In-A-CSV-File/OUTPUT"
json_file = "D:/JOB/GIS/T43PHR_PROJECT/TEST/JSON/custom_structure.json"
csv_list = os.listdir(csv_list_dir)
csv_list = [folder for folder in csv_list if os.path.isdir(os.path.join(csv_list_dir, folder))]
cus_struc = { 'data' : {} }
for csv_folder in csv_list:
    cus_struc['data'][str(csv_folder)],files = {},[]
    indice_files = os.listdir(os.path.join(csv_list_dir, csv_folder))
    for file in indice_files:
        files.append(file)
    df_max = pd.read_csv(os.path.join(os.path.join(csv_list_dir, csv_folder), files[0]))
    df_mean = pd.read_csv(os.path.join(os.path.join(csv_list_dir, csv_folder), files[1]))
    df_min = pd.read_csv(os.path.join(os.path.join(csv_list_dir, csv_folder), files[2]))
    df_sum = pd.read_csv(os.path.join(os.path.join(csv_list_dir, csv_folder), files[3]))
    if(len(df_max) == len(df_mean) == len(df_min) == len(df_sum)):
        for i in range(0,len(df_max)):
            polygon = df_max["date"][i]
            cus_struc['data'][str(csv_folder)][polygon] = []
            for col in df_max.columns:
                if(col != "date"):
                    inner_struc = {
                                    "date"  :   col,
                                    "min"   :   df_min[col][i],
                                    "max"   :   df_max[col][i],
                                    "mean"  :   df_mean[col][i],
                                    "sum"   :   df_sum[col][i]
                                   }
                    cus_struc['data'][str(csv_folder)][polygon].append(inner_struc)
    else:
        print("CSV files have differant size.")
        break
with open(json_file,'w') as fp:
    json.dump(cus_struc,fp)