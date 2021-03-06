from sentinelsat.sentinel import SentinelAPI
from collections import OrderedDict
import os

os.chdir("D:/JOB/GIS/T43PHR/")
username_esa = "porav43844"
password_esa = "sourcecode88"
# username2 - ninadobrev
# password2 - imageprocessing
tiles = ['43PHR']
api = SentinelAPI(username_esa, password_esa, 'https://scihub.copernicus.eu/dhus')
query_kwargs = {
        'platformname': 'Sentinel-2',
        'producttype': 'S2MSI1C',
        'date': ('20200528','20210328'),
        'cloudcoverpercentage': ('0', '30')}
products = OrderedDict()
for tile in tiles:
    kw = query_kwargs.copy()
    kw['tileid'] = tile
    pp = api.query(**kw)
    products.update(pp)
print (products)
api.download_all(products)

''''date': ('20200520','20200309'),'''
