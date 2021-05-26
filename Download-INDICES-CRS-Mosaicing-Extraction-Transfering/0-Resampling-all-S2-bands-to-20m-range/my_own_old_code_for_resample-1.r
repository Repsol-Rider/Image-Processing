library(raster)

b8 <- raster("D:/JOB/GIS/T43PHR_20210314T050651_B08.jp2")
b11 <- raster("D:/JOB/GIS/T43PHR_20210314T050651_B11.jp2")
data <- extent(b8)
r <- raster(nrows=5490,ncol=5490)
extent(r) <- c(data[1],data[2],data[3],data[4])
lst <- values(b8)
lst
new_avg_lst <- c()
if(length(lst) %% 2 == 0){
  ind <- 1
  while(ind < length(lst)){
    avgg <- (lst[ind]+lst[ind+1])/2
    new_avg_lst <- append(new_avg_lst,avgg,after=length(new_avg_lst))
    ind <- ind + 2
  }
}else{
  cat("Odd number of pixels detected")
}
new_avg_lst