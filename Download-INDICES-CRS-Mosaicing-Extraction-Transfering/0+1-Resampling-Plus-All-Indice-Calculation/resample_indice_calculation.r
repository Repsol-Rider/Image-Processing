library(raster)
library(RStoolbox)
library(sf)
library(gdalUtils)

options(warn=-1)
main_dir <- "D:/JOB/GIS/T43PHR_PROJECT"   #edit this directory to satellite downloaded tile files 
resulting_dir <- paste(main_dir,"INDICES/",sep="/")
setwd(main_dir)
dir.create(resulting_dir,recursive = FALSE,showWarnings = TRUE,mode = 0777)
folders <- list.dirs(main_dir, recursive=FALSE)
indices <- c("ndre1") #"ndvi","ndwi","savi","evi2","ndre1","ndre2","cire","npcri","lswi"
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
          formula <- (nir-red)/(nir+red+L)*(1.0+L) # (nir-red)*(1.0+L)/(nir+red+L) ?
        }else if(indices[j] == "evi2"){
          formula <- 2.4*(nir-red)/(nir+red+1.0)
        }else{
          print("Cannot define Indice Name!")
          break
        }
      }else if(indices[j] == "ndre1" || indices[j] == "ndre2" || indices[j] == "cire"){
        nir <- raster(paste(temp_dir,temp_bands_list[8],sep="",collapse = NULL))
        re1 <- raster(paste(temp_dir,temp_bands_list[5],sep="",collapse = NULL))
        re2 <- raster(paste(temp_dir,temp_bands_list[6],sep="",collapse = NULL))
        
        #resmapling NIR band resolution to REDEDGE band resolution
        resample_extent_var <- c(xmin(re1), ymin(re1), xmax(re1), ymax(re1))
        resample_resolution_var <- res(re1)
        resample_tmp_outname <- paste(tempdir(),"tmp_outfile.tif",sep="\\")
        resample_tmp_inname <- paste(tempdir(),"tmp_infile.tif",sep="\\")
        writeRaster(nir, resample_tmp_inname,format="GTiff",datatype="FLT4S")
        gdalwarp(resample_tmp_inname, resample_tmp_outname, tr = resample_resolution_var, te = resample_extent_var, r = 'bilinear')
        nir <- raster(resample_tmp_outname)
        
        if(indices[j] == "ndre1"){
          formula <- (nir-re1)/(nir+re1)
        }else if(indices[j] == "ndre2"){
          formula <- (nir-re2)/(nir+re2)
        }else if (indices[j] == "cire"){
          formula <- (nir/re1)-1
        }else{
          break
        }
        if(file.exists(resample_tmp_inname)){
          unlink(resample_tmp_inname)
        }
        if(file.exists(resample_tmp_outname)){
          unlink(resample_tmp_outname)
        }
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
      writeRaster(x = formula, #crs_changed_formula
                  filename= file_write_path,
                  format = "GTiff",
                  datatype='FLT4S'
      )
      #cat("Changing CRS from Projections to LongLat(EPSG:4326)")
      #crs_change_r <- raster(file_write_path)
      #crs_change_formula <- projectRaster(crs_change_r,crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
      #writeRaster(x = crs_change_formula,
      #           filename = file_write_path,
                  #format = "GTiff",
                  #datatype = "FLT4S",
      #           overwrite=TRUE)
      r_temp_dir <- paste(tempdir(),"raster",sep="/")
      if(dir.exists(r_temp_dir)){
        r_temp_file <- list.files(r_temp_dir,pattern=NULL,full.names=TRUE)
        for(rtmpfile in r_temp_file){
          unlink(rtmpfile,recursive=FALSE,force=TRUE)
        }
      }
    }
  }
}