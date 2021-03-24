library(raster)
library(RStoolbox)

main_dir <- "E:/GIS/DOWNLOADED_43PHR"
resulting_dir <- paste(main_dir,"INDICES/",sep="/")
setwd(main_dir)
dir.create(resulting_dir,recursive = FALSE,showWarnings = TRUE,mode = 0777)
folders <- list.dirs(main_dir, recursive=FALSE)
indices <- c("evi2","lswi","ndvi","ndwi","npcri","savi")
for(indice in indices){
  #print(paste(indice,"directory created successfully"))
  dir.create(paste(resulting_dir,indice,sep="/"),showWarnings = TRUE,recursive = FALSE,mode = 0777)
}
# ndre1.ndre2,crie are excluded from list due to differance in bands resolution

for(i in 1:length(folders)){
  if(substr(folders[i],nchar(folders[i])-3,nchar(folders[i])) == "SAFE"){
    temp_dir <- paste(folders[i],"GRANULE",sep="/")
    temp_list <- list.dirs(temp_dir,recursive="FALSE")
    temp_dir <- paste(temp_list[1],"IMG_DATA/",sep="/")
    temp_files <- list.files(temp_dir, pattern = "\\.jp2$")
    temp_bands_list <- vector()
    for(j in 1:length(temp_files)){
      if(substr(temp_files[j],nchar(temp_files)-6,nchar(temp_files[j])-4) != "TCI"){
        temp_bands_list <- append(temp_bands_list,temp_files[j])
      }
    }
    print(paste("----Selected Folder : ",paste(folders[i],"----",sep=""),sep=""))
    for(j in 1:length(indices)){
      indice <- indices[j]
      print(paste("calculating ",paste(indices[j],paste(" for",substr(temp_bands_list[1],1,nchar(temp_bands_list[1])-8)),sep=""),sep=""),sep="")
      if(indices[j] == "ndvi" || indices[j] == "ndwi" || indices[j] == "savi" || indices[j] == "evi2"){
        nir <- raster(paste(temp_dir,temp_bands_list[8],sep="",collapse = NULL))
        red <- raster(paste(temp_dir,temp_bands_list[4],sep="",collapse = NULL))
        if(indices[j] == "ndvi"){
          formula <- (nir-red)/(nir+red)
        }else if(indices[j] == "ndwi"){
          formula <- (red-nir)/(red+nir)
        }else if(indices[j] == "savi"){
          L <- 1.5
          formula <- (nir-red)/(nir+red+L)*(1.0+L)
        }else if(indices[j] == "evi2"){
          formula <- 2.4*(nir-red)/(nir+red+1.0)
        }else{
          print("Cannot define Indice Name!")
          break
        }
      }else if(indices[j] == "ndre1" || indices[j] == "ndre2"){
        nir <- raster(paste(temp_dir,temp_bands_list[8],sep="",collapse = NULL))
        if(indices[j] == "ndre1"){
          re <- raster(paste(temp_dir,temp_bands_list[5],sep="",collapse = NULL))
          formula <- (nir-re)/(nir+re)
        }else if(indices[j] == "ndre2"){
          re <- raster(paste(temp_dir,temp_bands_list[6],sep="",collapse = NULL))
          formula <- (nir-re)/(nir+re)
        }else{
          break
        }
      }else if(indices[j] == "cire"){
        nir <- raster(paste(temp_dir,temp_bands_list[8],sep="",collapse = NULL))
        re <- raster(paste(temp_dir,temp_bands_list[5],sep="",collapse = NULL))
        formula <- (nir/re)-1
      }else if(indices[j] == "npcri"){
        red <- raster(paste(temp_dir,temp_bands_list[4],sep="",collapse = NULL))
        blue <- raster(paste(temp_dir,temp_bands_list[2],sep="",collapse = NULL))
        formula <- (red-blue)/(red+blue)
      }else if(indices[j] == "lswi"){
        nnir <- raster(paste(temp_dir,temp_bands_list[13],sep="",collapse = NULL))
        swir <- raster(paste(temp_dir,temp_bands_list[11],sep="",collapse = NULL))
        formula <- (nnir-swir)/(nnir+swir)
      }else{
        break
      }
      file_write_path <- paste(paste(resulting_dir,indice,sep=""),paste(substr(temp_bands_list[1],1,nchar(temp_bands_list[1])-8),".tif",sep=""),sep="/",collapse = NULL)
      print(file_write_path)
      writeRaster(x = formula,
                  filename= file_write_path,
                  format = "GTiff",
                  datatype='FLT4S'
      )
      temp_dir <- paste(tempdir(),"raster",sep="/")
      if(dir.exists(temp_dir)){
          temp_file <- list.files(temp_dir,pattern=NULL,full.names=TRUE)
          for(tmpfile in temp_file){
              unlink(tmpfile,recursive=FALSE,force=TRUE)
          }
      }
    }
  }
}
