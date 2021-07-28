from sentinelsat import SentinelAPI
from collections import OrderedDict
import os,requests,html2text

h = html2text.HTML2Text()
h.ignore_links = True
os.chdir("D:/JOB/GIS/PIXEL_DATA/TS")
api = SentinelAPI('USERNAME', 'PASSWORD','https://scihub.copernicus.eu/dhus')
#tiles = ['43QHV','43QHA','43QHB','44QKM','44QKE']
tiles = ['43QHA','43QHB','43QHU','43QHV','44QKD','44QKE','44QKF','44QKG','44QLD','44QLE','44QLF','44QLG','44QME','44QMF']

query_kwargs = {
        'platformname': 'Sentinel-2',
        'producttype': 'S2MSI1C',
        'date': ('20200915', '20201015'),
        'cloudcoverpercentage': ('0', '30')}

products = OrderedDict()
for tile in tiles:
    kw = query_kwargs.copy()
    kw['tileid'] = tile  # products after 2017-03-31
    pp = api.query(**kw)
    products.update(pp)
print(len(products))

# the below 3 lines are used for revoking offline products gonna take 2-3 days

#for product in products:
#    r = requests.get("https://scihub.copernicus.eu/dhus/odata/v1/Products('"+product+"')/Online/$value", auth=('fake99', 'newpassword88'))
#    print(h.handle(r.text),sep="",end="")

api.download_all(products)
