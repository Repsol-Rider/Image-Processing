library('raster')
library('rlist')

options(warn=-1,max.print=50,digits=14)

# GETTING PROJECTION COORDINATES FROM A GIVEN CSV FILE
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
error_lst <- c()
for(csv_row in csv$WKT){
  tryCatch({
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

    mean <- mean/val
    get_date <- names(croped)
    get_date <- substr(get_date,8,15)
    get_date <- paste(substr(get_date,1,4),paste(substr(get_date,5,6),substr(get_date,7,8),sep="-"),sep="-")
    
    numlst <- append(numlst,csv$pid[pi],after=length(numlst))
    datelst <- append(datelst,get_date,after=length(datelst))
    meanlst <- append(meanlst,mean,after=length(meanlst))
    maxlst <- append(maxlst,max(ndvi_df$NDVI),after=length(maxlst))
    minlst <- append(minlst,min(ndvi_df$NDVI),after=length(minlst))

    i <- i + 1
  }
  cat(pi,csv$pid[pi]," Polygon Data Calculated\n")
  numlst <- append(numlst," ",after=length(numlst))
  datelst <- append(datelst," ",after=length(datelst))
  meanlst <- append(meanlst," ",after=length(meanlst))
  maxlst <- append(maxlst," ",after=length(maxlst))
  minlst <- append(minlst," ",after=length(minlst))
  pi <- pi + 1
  },error=function(e){
    err <- paste(paste("ERROR : ",paste(pi,csv$pid[pi])),paste("Polygon",conditionMessage(e)))
    error_lst <- append(error_lst,err,after=length(error_lst))
  })
}
full_df <- data.frame(PID=numlst,Date=datelst,Mean=meanlst,Max=maxlst,Min=minlst)
write.csv(full_df,polygon_dir,col.names=FALSE,row.names=FALSE)
write.table(error_lst,paste(tile_dir,"error.txt",sep="/"),sep="\n",row.names=FALSE,col.names=FALSE)
cat("All Wrong polygons are specified in error.txt located in",tile_dir)

#https://www.neonscience.org/resources/learning-hub/tutorials/dc-crop-extract-raster-data-r
