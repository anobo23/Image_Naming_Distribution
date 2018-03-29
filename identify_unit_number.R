library("readxl")
library(dplyr)
library(readAny)
library(tidyr)


p <- read_excel("~/Dropbox/Github/Digital_Image_Management/data/prescription_time_1803.xlsx", sheet = 1, skip = 0)

names(p) <- c("id", "date", "time", "department", "doctor")

p2 <- ptime %>% mutate(time = sprintf("%04d", time)) %>%
                    arrange(date, time)



t <- dummy <- read.any("~/Dropbox (My working)/team_folder/image_list/image_list.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE) %>%
                  arrange(DateTimeOriginal) %>% select(FileName, DateTimeOriginal)

t2 <- t %>% separate(FileName, c("id", "date", "place", "raw_file", "etc"), "-", extra = "merge", fill = "right") %>%
            separate(DateTimeOriginal, c("date", "time"), " ") %>%
            separate(time, c("hour", "min", "sec"), ":") %>%
            mutate(time = paste0(hour, min))

d <- strptime(t2$date, format = "%Y:%m:%d")


t3 <- t2 %>% mutate(date = format(d, format = "%Y%m%d"))



cor <- data.frame(cor = NA, pre = NA)

i <- 64

for (i in 1:1120) {
        
        f1 <- filter(p2, department == ifelse(t3$place[i] %in% c("adult1", "adult2"), "42", "43"), date == t3$date[i]) %>%
                mutate(diff = abs(as.numeric(time) - as.numeric(t3$time[i]))) %>%
                arrange(desc(diff))
                   
             
        cor <- rbind(cor,       c(t3$id[i], f1$id[1]))
}



cor <- mutate(cor, x = ifelse(cor == pre, "1", "0"))


sum(as.numeric(cor$x), na.rm = T)
