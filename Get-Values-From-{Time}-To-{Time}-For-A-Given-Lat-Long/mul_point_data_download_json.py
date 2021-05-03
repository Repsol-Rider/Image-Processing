import os, json, urllib, requests, webbrowser
import pandas as pd

output = "JSON" # JSON, CSV, ASCII, ICASA, NETCDF
start_date = "20100101"
end_date = "20200430"
parametersCustom = "PRECTOT,RH2M,T2M_RANGE,T2M_MAX,T2M_MIN,WS50M_RANGE,WS10M_RANGE"
output_folder = r'' # if r'' the location of the script is where the files will be outputted.
pointsDataFrame = pd.read_csv("points.csv", usecols=list)
for Long,Lat,Serial in zip(pointsDataFrame['X'],pointsDataFrame['Y'],pointsDataFrame['sno']):
    base_url = r"https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=SinglePoint&tempAverage=DAILY&parameters="+parametersCustom+"&startDate="+start_date+"&endDate="+end_date+"&lat={lat}&lon={long}&outputList={output}&userCommunity=AG"
    api_request_url = base_url.format(lat=Lat, long=Long, output=output.upper())
    json_response = json.loads(requests.get(api_request_url).content.decode('utf-8'))

    # Selects the file URL from the JSON response
    csv_request_url = json_response['outputs'][output.lower()]

    # Download File to Folder
    output_file_location = os.path.join(output_folder, os.path.basename("JSON/"+str(Serial)+".json"))
    urllib.request.urlretrieve(csv_request_url, output_file_location)