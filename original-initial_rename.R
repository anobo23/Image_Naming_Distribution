# version history
# v0319  #1  file.list에서 ColorTemperature 항목을 제거함



library(dplyr)
library(tidyr)
library(exifr)



rn.1st <- function(place){


                i.path <- paste0("C:/Users/JD/Dropbox/team_folder/raw_image/", place)

                file.list <- read_exif(i.path, recursive = TRUE) %>%
                        select(SourceFile, FileName, Directory, FileSize, FileType, DateTimeOriginal, Make, Model, 
                               ImageWidth, ImageHeight, Megapixels) %>%
                        filter(FileType == "JPEG")
                
                file.time <- strptime(file.list$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")


                file.list <- file.list %>% 
                        mutate(NewName = paste0("-", format(file.time, format = "%y%m%d"), "-", place, "-", FileName),
                               NewDirectory = paste0("C:/Users/JD/Dropbox/team_folder/raw_image/temp_for_rename/", NewName))

                file.rename(file.list$SourceFile, file.list$NewDirectory)
                
    
                
}




rn.1st("oproom")
rn.1st("child6")
rn.1st("adult1")
rn.1st("adult2")
#rn.1st("emroom")





