# version history
# v0319    #1 file.list 에서 'ColorTemperature' 변수를 제외





#install.packages("exifr")
#install.packages("devtools")
#library(devtools)
#install_github("plgrmr/readAny", force = TRUE)
library(exifr)
library(dplyr)
library(tidyr)
library(readAny)

rm(list = ls())


i.path <- paste0("C:/Users/JD/Dropbox/team_folder/raw_image/temp")


file.list <- read_exif(i.path, recursive = TRUE) %>%
        select(SourceFile, FileName, Directory, FileSize, FileType, DateTimeOriginal, Make, Model, 
               ImageWidth, ImageHeight, Megapixels) %>%
        filter(FileType == "JPEG")


file.nu <- length(file.list)


f1 <- file.list %>% mutate(xxx = FileName) %>% 
        separate(xxx, c("unit", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right")

f2 <- f1 %>% filter(!is.na(unit)) %>%
             filter(as.numeric(unit) < 500000 | unit == "unknown",  
                    nchar(date) == 6, 
                    place %in% c("oproom", "adult1", "adult2", "child6", "emroom"), 
                    grepl("JPG", raw_file, ignore.case = TRUE))  %>%
                    mutate(listup_date = as.character(Sys.time()) )




# 리스트에 추가
old.list <- read.any("C:/Users/JD/Dropbox/team_folder/image_list/image_list.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
new.list <- rbind(f2, old.list)
write.csv(new.list, "C:/Users/JD/Dropbox/team_folder/image_list/image_list.csv" , row.names = FALSE, fileEncoding = "UTF-8")




# 파일 복사 to 'renamed_image'
flist <- list.files(i.path, full.names = TRUE)
file.copy(f2$SourceFile, "C:/Users/JD/Dropbox/team_folder/renamed_image/" )




# 환자별 폴더로 파일 이동
f2.leng <- nrow(f2)


for (i in 1:f2.leng) {
        if (f2$FileName[i] %in% new.list$FileName) {
                  new.dir <- paste0("C:/Users/JD/Dropbox/team_folder/Image_DB/", f2$unit[i])
                  dir.create(new.dir, showWarnings = FALSE)
                  file.rename(paste0(f2$SourceFile[i]), 
                              paste0(new.dir, "/", f2$FileName[i]))
        }
        
  }

  

