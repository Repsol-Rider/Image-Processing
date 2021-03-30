csv <- read.csv(file="D:/JOB/GIS/polygon.csv",nrows=1,stringsAsFactors=FALSE)
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


plot(80, 14, col = "white", xlab = "X", ylab = "Y")

polygon(x = longg,
        y = latt,
        col = "#1b98e0")