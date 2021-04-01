library('raster')
library('rlist')

options(warn=-1,max.print=50)
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

# EXPORTING MEAN OF NDIV OF SPECIFIED POLYGON TO A CSV FILE

cname <- names(croped)
pts <- rasterToPoints(croped)
ndvi_df <- data.frame(pts)
ndvi_df <- data.frame(ndvi_df[3])
names(ndvi_df)[names(ndvi_df) == cname] <- "NDVI"
mean <- 0
for(val in 1:length(ndvi_df$NDVI)){
    mean <- ndvi_df$NDVI[val] + mean
}
mean <- mean/val
get_date <- names(croped)
get_date <- substr(get_date,10,17)
get_date <- paste(substr(get_date,1,4),paste(substr(get_date,5,6),substr(get_date,7,8),sep="-"),sep="-")
get_date
mean
# csv_file_name <- paste("E:/GIS/DOWNLOADED_43PHR/INDICES/POLYGON_CSV_FILES/",paste(cname,".csv",sep=""),sep="")
# write.csv(ndvi_df,csv_file_name,row.names=FALSE)

#https://www.neonscience.org/resources/learning-hub/tutorials/dc-crop-extract-raster-data-r
