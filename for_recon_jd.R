# version history
# 180320-1238 : 생성
# 180325-1849 : 하위 폴더는의 파일은 제외
# 180327-1229 : 하위 폴더를 다른 폴더로 독립시켜버림


# error Hx.
#             : 이동 대상경로에 동일 차트번호의 폴더가 두개 있는 경우 복사 안됨
# 180327-1229 : EMR에 사진이 물려있는 경우 사진 이름 변경 안됨



#install.packages("exifr")
#install.packages("devtools")
#library(devtools)
#install_github("plgrmr/readAny", force = TRUE)
library(exifr)
library(dplyr)
library(tidyr)
library(readAny)



# 1st renaming

i.path <- paste0("~/Dropbox (My working)/team_folder/raw_image/re_jd4")


file.list <- read_exif(i.path, recursive = TRUE) %>%
        select(SourceFile, FileName, Directory, DateTimeOriginal, FileType) %>%
        filter(FileType == "JPEG") %>%
        filter(!grepl("temp|uk", Directory))

temp <- file.list

file.time <- strptime(file.list$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")


file.list <- file.list %>% 
        mutate(NewName = paste0("-", format(file.time, format = "%y%m%d"), "-re_jd4-", FileName))
               

file.rename(file.list$SourceFile, paste0(file.list$Directory, "/", file.list$NewName))




# copy to imageDB according to unit number

rena.list.1 <- data.frame(FileName = list.files("~/Dropbox (My working)/team_folder/raw_image/re_jd4"))

rena.list.2 <- rena.list.1 %>% mutate(xxx = FileName) %>%
                        separate(xxx, c("unit", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right") %>%
                        filter(!is.na(date)) %>% filter(as.numeric(unit) < 500000)



list.leng <- nrow(rena.list.2)


for (i in 1:list.leng) {
                new.dir <- paste0("~/Dropbox (My working)/team_folder/Image_DB/", rena.list.2$unit[i])
                dir.create(new.dir, showWarnings = FALSE)
                file.copy(paste0("~/Dropbox (My working)/team_folder/raw_image/re_jd4/", rena.list.2$FileName[i]), 
                          paste0(new.dir, "/", rena.list.2$FileName[i]))
        
        
}


# move to JD_DB


recon <- data.frame(Directory = list.files("//Burndoc3/김종대 의국4/_재건외래 JD/_0. Pts"))

for (i in 1:list.leng) {
        
        
        a <- rena.list.2$unit[i]
        
        if (sum(grepl(a, recon$Directory)) == 1 ) {
             b <- recon[grepl(a, recon$Directory), "Directory"]
             new.dir <- paste0("//Burndoc3/김종대 의국4/_재건외래 JD/_0. Pts/", b)
             
             file.rename(paste0("~/Dropbox (My working)/team_folder/raw_image/re_jd4/", rena.list.2$FileName[i]), 
                         paste0(new.dir, "/", rena.list.2$FileName[i]))
        }
        if (sum(grepl(a, recon$Directory)) == 0 ){
             new.dir <- paste0("//Burndoc3/김종대 의국4/_재건외래 JD/_0. Pts/", rena.list.2$unit[i])
             dir.create(new.dir, showWarnings = FALSE)
             file.rename(paste0("~/Dropbox (My working)/team_folder/raw_image/re_jd4/", rena.list.2$FileName[i]), 
                         paste0(new.dir, "/", rena.list.2$FileName[i]))
        }
        
}



