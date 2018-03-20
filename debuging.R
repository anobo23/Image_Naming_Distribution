#install.packages("exifr")
#install.packages("devtools")
#library(devtools)
#install_github("plgrmr/readAny", force = TRUE)
library(exifr)
library(dplyr)
library(tidyr)
library(readAny)



##### initial list up  180317

i.path <- paste0("~/Dropbox (My working)/team_folder/renamed_image/")


file.list <- read_exif(i.path, recursive = TRUE) %>%
        select(SourceFile, FileName, Directory, FileSize, FileType, DateTimeOriginal, Make, Model, 
               ImageWidth, ImageHeight, Megapixels, ColorTemperature) %>%
        filter(FileType == "JPEG") 



f1 <- file.list %>% mutate(xxx = FileName) %>% 
        separate(xxx, c("unit", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right") 

f2 <- f1 %>% filter(!is.na(unit)) %>%
        filter(as.numeric(unit) < 500000,  
               nchar(date) == 6, 
               place %in% c("oproom", "adult1", "adult2", "child6", "emroom"), 
               grepl("JPG", raw_file, ignore.case = TRUE)) %>%
        mutate(listup_date = as.character(Sys.time()))


write.csv(f2, "~/Dropbox (My working)/team_folder/image_list/image_list.csv" , row.names = FALSE, fileEncoding = "UTF-8")



##### renamed_image copy to image_DB         180317

i.path <- paste0("~/Dropbox (My working)/team_folder/renamed_image/")


file.list <- read_exif(i.path, recursive = TRUE) %>%
        select(SourceFile, FileName, Directory, FileSize, FileType, DateTimeOriginal, Make, Model, 
               ImageWidth, ImageHeight, Megapixels, ColorTemperature) %>%
        filter(FileType == "JPEG") 



f1 <- file.list %>% mutate(xxx = FileName) %>% 
        separate(xxx, c("unit", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right") 

f2 <- f1 %>% filter(!is.na(unit)) %>%
        filter(as.numeric(unit) < 500000 | unit == "unknown",  
               nchar(date) == 6, 
               place %in% c("oproom", "adult1", "adult2", "child6", "emroom"), 
               grepl("JPG", raw_file, ignore.case = TRUE)) %>%
        mutate(listup_date = Sys.time() )



f2.leng <- nrow(f2)


for (i in 1:f2.leng) {

                new.dir <- paste0("~/Dropbox (My working)/team_folder/Image_DB/", f2$unit[i])
                dir.create(new.dir, showWarnings = FALSE)
                file.copy(f2$SourceFile[i], new.dir)

}


##### temp_for_rename 폴더의 file name를 cleaning     180317


full.name <- list.files("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename", full.names = TRUE)
file.name <- list.files("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename")

flist1 <- data.frame(Source = full.name, FileName = file.name) %>%  
            mutate(xxx = FileName) %>% 
            separate(xxx, c("blank", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right") 

flist1$place <- as.factor(flist1$place)


levels(flist1$place) <- c("adult1", "adult2", "child6", "oproom", "adult2", "adult1",  "child6")

flist2 <- flist1 %>% mutate(raw_file_2 = raw_file,
                            raw_file_2 = ifelse(grepl("IMG", raw_file), paste0(substring(raw_file, first = 1, last = 8), ".JPG"), raw_file),
                            NewName = paste0("-", date, "-", place, "-", raw_file_2))
                     
file.rename(paste0("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename/", flist2$FileName), 
            paste0("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename/", flist2$NewName))
