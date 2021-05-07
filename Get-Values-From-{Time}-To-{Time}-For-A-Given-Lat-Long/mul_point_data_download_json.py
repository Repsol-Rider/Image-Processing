import os, sys, time, json, urllib3, requests, multiprocessing
urllib3.disable_warnings()
import numpy as np
import pandas as pd

def Get(Total):
    API_URL, FILE_DIR, tempLatitude, tempLongitude, tempSeries = Total
    API_RESPONSE = requests.get(url=API_URL, verify=False)
    JSON_RESPONSE = json.loads(API_RESPONSE.text)
    DataFrame = pd.DataFrame.from_dict(JSON_RESPONSE['features'][0]['properties']['parameter'])
    DataFrame.to_csv(FILE_DIR)
    DataFrame = pd.read_csv(FILE_DIR)
    DataFrame.to_csv(FILE_DIR,index=False,header=True)
    DataFrame = pd.read_csv(FILE_DIR)
    
    #code for horizontal formatting for csv
    
    #DataFrame.rename(columns={"Unnamed: 0":"Parameter"},inplace=True)
    #DataFrame = DataFrame.T
    #DataFrame.to_csv(FILE_DIR,index=True,header=False)
    #DataFrame = pd.read_csv(FILE_DIR)
    #DataFrame.insert(0,"Cordinate",str(tempLatitude)+","+str(tempLongitude), True)
    #DataFrame.to_csv(FILE_DIR,index=False,header=True)
    
    #code for vertical formatting for csv
    
    DataFrame.rename(columns={"Unnamed: 0":"Dates"},inplace=True)
    DataFrame["Latitude"]=tempLatitude
    DataFrame["Longitude"]=tempLongitude
    DataFrame.to_csv(FILE_DIR,index=False,header=True)
    DataFrame = pd.read_csv(FILE_DIR)
    DataFrame.to_json(tempSeries)
    os.remove(FILE_DIR) #if you remove this line you can download csv and json at a time
class Operation():
    def __init__(self):
        self.processes = 10 # Please do not go more than 10 concurrent requests.
        start_date = "20100101"
        end_date = "20210430"
        parametersCustom = "PRECTOT,RH2M,T2M_RANGE,T2M_MAX,T2M_MIN,WS50M_RANGE,WS10M_RANGE"
        self.API_URL = r"https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=SinglePoint&tempAverage=DAILY&parameters="+parametersCustom+"&startDate="+start_date+"&endDate="+end_date+"&lat={latitude}&lon={longitude}&outputList=JSON&userCommunity=AG"
        self.FILE_DIR = "CSV/{serial}.csv"
        self.tempLatitude = "{templatitude}"
        self.tempLongitude = "{templongitude}"
        self.tempSeries = "JSON/{tempseries}.json"
        self.messages = []
        self.times = {}
    def Perform(self):
        BEGIN_TIME = time.time()
        Latitude_Longitude = []
        pointsDataFrame = pd.read_csv("D:/JOB/GITHUB/Image-Processing/Get-Values-From-{Time}-To-{Time}-For-A-Given-Lat-Long/points.csv", usecols=list)
        for Long,Lat,Serial in zip(pointsDataFrame['X'],pointsDataFrame['Y'],pointsDataFrame['W_GID']):
            Latitude_Longitude.append([Lat,Long,Serial])
        POINTS = []
        for Latitude, Longitude, Serial in Latitude_Longitude:
            LONG_LAT_QUERY = self.API_URL.format(longitude=Longitude, latitude=Latitude)
            LONG_LAT_FILE = self.FILE_DIR.format(serial=Serial)
            TempLat = self.tempLatitude.format(templatitude=Latitude)
            TempLong = self.tempLongitude.format(templongitude=Longitude)
            Tempseries = self.tempSeries.format(tempseries=Serial)
            POINTS.append((LONG_LAT_QUERY, LONG_LAT_FILE, TempLat, TempLong, Tempseries))
        MP_POOL = multiprocessing.Pool(self.processes)
        TEMP_X = MP_POOL.imap_unordered(Get, POINTS)
        DataFrames = []
        for i, DataFrame in enumerate(TEMP_X, 1):
            DataFrames.append(DataFrame)
            sys.stderr.write('\rExporting {0:%}'.format(i/len(POINTS)))
        self.times["Total Script"] = round((time.time() - BEGIN_TIME), 2)
        print ("\n")
        print ("Total Script Time:", self.times["Total Script"])
if __name__ == '__main__':
    Operation().Perform()