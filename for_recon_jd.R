# version history
# 180320-1238 : 생성


#install.packages("exifr")
#install.packages("devtools")
#library(devtools)
#install_github("plgrmr/readAny", force = TRUE)
library(exifr)
library(dplyr)
library(tidyr)
library(readAny)



i.path <- paste0("~/Dropbox (My working)/team_folder/raw_image/re_jd4")


file.list <- read_exif(i.path, recursive = TRUE) %>%
        select(SourceFile, FileName, Directory, DateTimeOriginal) %>%
        filter(FileType == "JPEG")

file.time <- strptime(file.list$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")


file.list <- file.list %>% 
        mutate(NewName = paste0("-", format(file.time, format = "%y%m%d"), "-re_jd4-", FileName),
               NewDirectory = paste0("//Burndoc3/김종대 의국4/_재건외래 JD/temp", NewName))

file.rename(file.list$SourceFile, file.list$NewDirectory)
