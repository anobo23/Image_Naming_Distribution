# version control
## 180407 - 생성,    목적 : ER에서 촬영된 사진명을 변경
  
# 작업 History
## 180407 - 2,3 월 사진을 작업함


###################################


# 1. 코드실행 전 작업
### 1. ER에서 보내준 사진을 emroom 로 이동한다.
### 2. original-initial_rename.R 을 구동한다. (파일명 변경 후 temp_for_rename 폴더로 이동)
### 3. temp_for_rename 폴더에서 파일명의 형식을 수동으로 cleaning 한다.



# 2. working code
### 1. ER에서는 사진의 raw name 앞에 id를 추가해서 넘겨줌 ex)  123456IMG_111.JPG
### 2. 본 코드는 id와 raw name를 분리하고 기존에 설정된 name format으로 변경하는 작업을 위함


xxx <- list.files("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename")
yyy <- list.files("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename", full.names = T)

flist.0 <- data.frame(Directory = yyy, FileName = xxx, temp = xxx)


flist.1 <- flist.0 %>% separate(temp, c("id","date","location", "name"), "-", extra = "merge", fill = "right") %>%
                       separate(name, c("n_id","raw_name"), "I") %>%
                       mutate(raw_name = paste0("I", raw_name), id = n_id) %>%
                       mutate(NewName = paste0(id, "-", date, "-", location, "-", raw_name))


file.rename(paste0(flist.1$Directory), paste0("~/Dropbox (My working)/team_folder/raw_image/temp_for_rename/", flist.1$NewName))        


# 3. 코드실행 후 작업
### 1. temp_for_rename 폴더에서 파일명이 제대로 변경되었는지 확인.
### 2. 파일을 temp로 이동하고 'original-copy_transfer.R' 을 실행 한다. 













