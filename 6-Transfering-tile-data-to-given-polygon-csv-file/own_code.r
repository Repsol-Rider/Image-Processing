library('raster')
library('rlist')

# GETTING LONGITUDES AND LATITUDES FROM A GIVEN CSV FILE
csv <- read.csv(file="E:/gis/polygon.csv",nrows=1,stringsAsFactors=FALSE)
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
latt <- list.remove(latt,5)
longg <- list.remove(longg,5)


#PLOT POLYGON ON MAP

ndvi <- raster("E:/GIS/DOWNLOADED_43PHR/INDICES/ndvi/reprojected/reprojetced_2/_T43PHR_20200925T050701.tif")
extent1 <- extent(78.0841966200489,78.0983266241176,14.0392004877398,14.0497157354592)
croped <- crop(x=ndvi,y=extent1)
plot(croped)

#PLOTTING LONG LATS ON SPECIFIED TILE GIVEN IN CSV FILE

#APPENDING SPECIFIED TILE DATA TO THE POLYGON GIVEN IN CSV 


#https://gis.stackexchange.com/questions/246273/how-to-plot-polygon-in-r-from-coordinates-string