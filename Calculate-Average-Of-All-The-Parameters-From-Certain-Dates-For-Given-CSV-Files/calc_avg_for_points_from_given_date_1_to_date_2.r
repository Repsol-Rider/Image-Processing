dir_for_csv_files <- "D:/JOB/GIS/NEW_PROGRAM/NEW/points/"  # directory where your csv file exist 
output_file_dir <- "D:/JOB/GIS/NEW_PROGRAM/NEW/output/"    # directory for the output file created
date_start <- "20180601"   # the old date 
date_end <- "20181112"     # the new date

# Make changes only when you understand the code

inc <- 0
sum <- 0
i <- 0
collect <- FALSE
stop <- FALSE
list_of_csvs <- list.files(path=dir_for_csv_files,patter=".csv",full.names=FALSE)
avg_df <- matrix(ncol = 10, nrow = length(list_of_csvs))
avg_df <- data.frame(avg_df)
for(csv in list_of_csvs){
  df <- read.csv(paste(dir_for_csv_files,csv,sep=""))
  temp_df = matrix(ncol = 0, nrow = 0)
  temp_df = data.frame(temp_df)
  cat("------------------------------\nRetrieving Data from file ",csv,"...")
  for(i in 1:nrow(df)){
    row <- df[i,]
    if(row["Dates"] == date_end){
      stop <- TRUE
      collect <- FALSE
    }
    if(row["Dates"] == date_start && !stop){
      collect <- TRUE
    }
    if(collect && !stop){
      temp_df <- rbind(temp_df,row)
      inc <- inc + 1
    }
    if(stop && !collect){
      temp_df <- rbind(temp_df,row)
      break
    }
  }
  collect <- FALSE
  stop <- FALSE
  cat("done\nNo.of rows in between ",date_start," and ",date_end," in file ",csv," are : ",inc,"\nCalculating avg values for file ",csv,"...")
  inc <- 0
  temp_vec <- vector(,ncol(temp_df))
  temp_vec[1] <- substr(date_start,1,4)
  for(i in 2:(ncol(temp_df)-2)){
    temp_vec[i] <- colMeans(temp_df[i], na.rm = TRUE)
  }
  temp_vec[i+1] <- temp_df$Latitude[1]
  temp_vec[i+2] <- temp_df$Longitude[1]
  cat("done\nAssigning calculated avg values to DataFrame...")
  df_col_temp_vec <- c(vector(,ncol(temp_df)))
  for(i in 1:ncol(temp_df)){
    df_col_temp_vec[i] <- colnames(temp_df)[i]
  }
  colnames(avg_df) <- df_col_temp_vec
  avg_df <- rbind(avg_df,temp_vec)
  avg_df <- avg_df[-c(1),]
  cat("done\n------------------------------\n\n\n")
}
write.csv(avg_df,paste(output_file_dir,paste(substr(date_start,1,4),"csv",sep="."),sep=""),row.names=FALSE)
cat("\nFile has been created with the avg values in the desired location")