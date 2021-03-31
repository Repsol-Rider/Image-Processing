library('raster')

options(warn=-1,max.print=10)

# GETTING LONGITUDES AND LATITUDES FROM A GIVEN CSV FILE
csv <- read.csv(file="E:/GIS/polygon.csv",nrows=1,stringsAsFactors=FALSE)
one_row <- csv[1]
csv_len <- nchar(one_row)
csv_sub_str <- substr(one_row,11,csv_len-2)
whole_chr <- ""
lat_longs_list <- c()
for(chr in 1:nchar(csv_sub_str)){
    one_chr <- substr(csv_sub_str,chr,chr)
    if(one_chr == "," || one_chr == " "){
        one_chr <- ""
    }
    whole_chr <- paste(whole_chr,one_chr,sep="")
    if(nchar(whole_chr) == 16){
        lat_longs_list <- append(lat_longs_list,whole_chr,after=length(lat_longs_list))
        whole_chr <- ""
    }
}
csv_sub_str <- gsub(" ",",",csv_sub_str)
latt <- c()
longg <- c()
for(val in 1:length(lat_longs_list)){
    if(val %% 2 == 0){
        latt <- append(latt,lat_longs_list[val],after=length(latt))
    }else if(val %% 2 == 1){
        longg <- append(longg,lat_longs_list[val],after=length(longg))
    }
}
#PLOT POLYGON WITH NDVI RASTER

ndvi <- raster("E:/GIS/DOWNLOADED_43PHR/INDICES/ndvi/reprojected/reprojetced_2/_T43PHR_20200925T050701.tif")
new_extent <- extent(min(longg),max(longg),min(latt),max(latt))
poly <- ndvi
poly <- setExtent(ndvi,new_extent,keepres=TRUE)
plot(poly)
dimen <- dim(poly)
num_of_pixels <- dimen[1]*dimen[2]
cat("Read",num_of_pixels,"Pixels in the given polygon")
ndvi
raster(poly)
pts <- rasterToPoints(poly,spatial=TRUE)
data <- data.frame(pts)
data[1]
# m1 <- matrix(as.numeric(strsplit(csv_sub_str,",")[[1]]),ncol=2,byrow=TRUE)
# map <- leaflet()
# map <- addTiles(map)
# map <- addPolygons(map,data=m1,color="blue",weight=4,smoothFactor=0.5,opacity=1.0,fillOpacity=0.5,fillColor='red')
# map

#PLOTTING LONG LATS ON SPECIFIED TILE GIVEN IN CSV FILE

#APPENDING SPECIFIED TILE DATA TO THE POLYGON GIVEN IN CSV 


#https://gis.stackexchange.com/questions/246273/how-to-plot-polygon-in-r-from-coordinates-string