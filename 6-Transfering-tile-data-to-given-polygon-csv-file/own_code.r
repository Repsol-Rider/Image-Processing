
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
print(lat_longs_list)

#PLOTTING LONG LATS ON SPECIFIED TILE GIVEN IN CSV FILE

#APPENDING SPECIFIED TILE DATA TO THE POLYGON GIVEN IN CSV 