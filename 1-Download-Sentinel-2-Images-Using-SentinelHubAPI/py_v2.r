from sentinelsat import SentinelAPI
from collections import OrderedDict
import os

os.chdir("D:/JOB/GIS/TS/")
# username2 - ninadobrev
# password2 - imageprocessing
api = SentinelAPI('porav43844', 'sourcecode88')
tiles = ['43PHR']
#'44QME','4EQHV','44QKF','44QLF','44QLG','44DMF','43QGU','43QHV','43QHB','43PHT','43QHU','44PKC'
#,'44QKD','44QKE','44QKG','44QLD','44QLE','44QME','43PGT','43QGA','43QGB','44QMD','44QNE','43QHA'
query_kwargs = {
        'platformname': 'Sentinel-2',
        'producttype': 'S2MSI1C',
        'date': ('20200528', '202103015'),
        'cloudcoverpercentage': ('0', '30')}

products = OrderedDict()
for tile in tiles:
    kw = query_kwargs.copy()
    kw['tileid'] = tile  # products after 2017-03-31
    pp = api.query(**kw)
    products.update(pp)

api.download_all(products)