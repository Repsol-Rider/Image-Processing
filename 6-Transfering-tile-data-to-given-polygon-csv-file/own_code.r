library('raster')
library('rlist')

options(warn=-1,max.print=50,digits=14)
# GETTING LONGITUDES AND LATITUDES FROM A GIVEN CSV FILE
# csv <- read.csv(file="E:/GIS/t43phr.csv",stringsAsFactors=FALSE)
csv <- read.csv(file="D:/JOB/GIS/t43phr.csv",stringsAsFactors=FALSE)
tile_dir <- "D:/JOB/GIS/T43PHR/INDICES/ndvi"
polygon_dir <- paste(tile_dir,"test_polygon.csv",sep="/")
file.create(polygon_dir,showWarnings=FALSE)
pi <- 1
numlst <- c()
datelst <- c()
meanlst <- c()
maxlst <- c()
minlst <- c()
for(csv_row in csv$WKT){
  csv_len <- nchar(csv_row)
  csv_row <- substr(csv_row,17,csv_len-3)
  lat_long_list <- c()
  cord <- ""
  for(chrid in 1:csv_len){
    chr <- substr(csv_row,chrid,chrid)
    if(chr == " " || chr == ","){
      lat_long_list <- append(lat_long_list,cord,after=length(lat_long_list))
      cord <- ""
    }else{
      cord <- paste(cord,chr,sep="")
    }
  }
  lat_long_list <- list.remove(lat_long_list,length(lat_long_list))
  
  # <- list.remove(lat_long_list)
  # csv_sub_str <- substr(csv_row,17,csv_len-3)
  # whole_chr <- ""
  # lat_longs_list <- c()
  # for(chr in 1:nchar(csv_sub_str)){
  #     one_chr <- substr(csv_sub_str,chr,chr)
  #     if(one_chr == "," || one_chr == " "){
  #         one_chr <- ""
  #     }
  #     whole_chr <- paste(whole_chr,one_chr,sep="")
  #     if(nchar(whole_chr) == 16){
  #         lat_longs_list <- append(lat_longs_list,whole_chr,after=length(lat_longs_list))
  #         whole_chr <- ""
  #     }
  # }
  # csv_sub_str <- gsub(" ",",",csv_sub_str)
  latt <- c()
  longg <- c()
  for(val in 1:length(lat_long_list)){
    if(val %% 2 == 0){
      latt <- append(latt,lat_long_list[val],after=length(latt))
    }else if(val %% 2 == 1){
      longg <- append(longg,lat_long_list[val],after=length(longg))
    }
  }
  
  # latt <- list.remove(latt,5)
  # longg <- list.remove(longg,5)
  
  x_max <- max(longg)
  x_min <- min(longg)
  y_max <- max(latt)
  y_min <- min(latt)
  
  x_max <- as.double(x_max)
  x_min <- as.double(x_min)
  y_max <- as.double(y_max)
  y_min <- as.double(y_min)
  
  # LOOP ONE TILE FOR TIME SERIES
  
  tile_files <- list.files(path=tile_dir,pattern="\\.tif$",full.names=TRUE)
  i <- 1
  for(a_file in tile_files){
    
    #PLOT POLYGON ON MAP
    
    ndvi <- raster(a_file)
    extent1 <- extent(x_min,x_max,y_min,y_max)
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
    # cat(val,"Pixels Found in",cname,"Polygon\n")
    mean <- mean/val
    get_date <- names(croped)
    get_date <- substr(get_date,8,15)
    get_date <- paste(substr(get_date,1,4),paste(substr(get_date,5,6),substr(get_date,7,8),sep="-"),sep="-")
    
    numlst <- append(numlst,csv$pid[pi],after=length(numlst))
    datelst <- append(datelst,get_date,after=length(datelst))
    meanlst <- append(meanlst,mean,after=length(meanlst))
    maxlst <- append(maxlst,max(ndvi_df$NDVI),after=length(maxlst))
    minlst <- append(minlst,min(ndvi_df$NDVI),after=length(minlst))
    
    # write.csv(csv_row_df,polygon_dir,append=TRUE,sep=",",quote=FALSE,row.names=FALSE)
    # cat(i,"  NDVI  ",get_date,"   ",mean,"   ",max(ndvi_df$NDVI),"    ",min(ndvi_df$NDVI),"\n")
    i <- i + 1
  }
  cat(pi,csv$pid[pi]," Polygon Data Calculated\n")
  numlst <- append(numlst," ",after=length(numlst))
  datelst <- append(datelst," ",after=length(datelst))
  meanlst <- append(meanlst," ",after=length(meanlst))
  maxlst <- append(maxlst," ",after=length(maxlst))
  minlst <- append(minlst," ",after=length(minlst))
  
  # if(pi == 50){
  #   polygon_dir <- paste(tile_dir,paste(pi,"csv",sep="."),sep="/")
  #   numlst <- c()
  #   datelst <- c()
  #   meanlst <- c()
  #   maxlst <- c()
  #   minlst <- c()
  # }
  pi <- pi + 1
}
full_df <- data.frame(PID=numlst,Date=datelst,Mean=meanlst,Max=maxlst,Min=minlst)
write.csv(full_df,polygon_dir,col.names=FALSE,row.names=FALSE)

#https://www.neonscience.org/resources/learning-hub/tutorials/dc-crop-extract-raster-data-r
