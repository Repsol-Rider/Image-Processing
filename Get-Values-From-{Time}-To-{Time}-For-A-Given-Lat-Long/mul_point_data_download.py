import os, sys, time, json, urllib3, requests, multiprocessing
urllib3.disable_warnings()
import numpy as np
import pandas as pd

def Get(Total):
    API_URL, FILE_DIR = Total
    API_RESPONSE = requests.get(url=API_URL, verify=False)
    JSON_RESPONSE = json.loads(API_RESPONSE.text)
    DataFrame = pd.DataFrame.from_dict(JSON_RESPONSE['features'][0]['properties']['parameter'])
    DataFrame.to_csv(FILE_DIR)
class Operation():
    def __init__(self):
        self.processes = 10 # Please do not go more than 10 concurrent requests.
        start_date = "20100101"
        end_date = "20200430"
        parametersCustom = "PRECTOT,RH2M,T2M,WS2M"
        self.API_URL = r"https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=SinglePoint&tempAverage=DAILY&parameters="+parametersCustom+"&startDate="+start_date+"&endDate="+end_date+"&lat={latitude}&lon={longitude}&outputList=JSON&userCommunity=AG"
        self.FILE_DIR = "pointsData/File_Lat_{latitude}_Lon_{longitude}.csv"
        self.messages = []
        self.times = {}
    def Perform(self):
        BEGIN_TIME = time.time()
        Latitude_Longitude = []
        pointsDataFrame = pd.read_csv("C:/Users/rakes/Downloads/grids_cordinates.csv", usecols=list)
        for Long,Lat in zip(pointsDataFrame['X'],pointsDataFrame['Y']):
            Latitude_Longitude.append([Lat,Long])
        POINTS = []
        for Latitude, Longitude in Latitude_Longitude:
            LONG_LAT_QUERY = self.API_URL.format(longitude=Longitude, latitude=Latitude)
            LONG_LAT_FILE = self.FILE_DIR.format(longitude=Longitude, latitude=Latitude)
            POINTS.append((LONG_LAT_QUERY, LONG_LAT_FILE))
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