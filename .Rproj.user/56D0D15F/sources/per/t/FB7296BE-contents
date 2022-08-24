library("readxl")
library(dplyr)
library(readr)
library(tidyr)
library(beepr)
library(ggplot2)

files <- c("Callbook_16_11_2020.xlsx", "Callbook_15_12_2020.xlsx", "Callbook_16_02_2022.xlsx", "Callbook_18_07_2022.xlsx", "Callbook_16_08_2022.xlsx")

toDate <- function(year, month, day) {
  ISOdate(year, month, day)
}

indicativ <- c("YO2", "YO3", "YO4", "YO5", "YO6", "YO7", "YO8", "YO9")
total_callsigns <- data.frame(indicativ)
print(total_callsigns)

for (f in files) {
  print(f)
  fname <- tools::file_path_sans_ext(f)
  a <- stringr::str_split(fname, "_")
  d <- toDate(a[[1]][4], a[[1]][3], a[[1]][2])
  col_name = as.character(as.Date(d))
  print(col_name)
  
  #read XLSX file
  callbook <- read_xlsx(f)
  #glimpse(callbook)
  
  #make column with only first 3 chrs from the callsign
  callbook$ShortIndicativ <- substr(callbook$INDICATIVUL, 1,3)
  glimpse(callbook$ShortIndicativ)
  callbook$FullAddress <- paste(callbook$ADRESA, callbook$LOCALITATEA, callbook$JUDETUL, sep = ", ")
  beep(sound=1, expr = NULL)
  
  #how many radioamateurs per district, county and city
  callsign_count <- callbook %>%
    count(ShortIndicativ)
  print(callsign_count)
  
  total_callsigns <- total_callsigns %>%
    inner_join(callsign_count, by = c("indicativ" = "ShortIndicativ")) %>%
    rename(!!col_name := n)
#  [col_name] <- callsign_count$ShortIndicativ
  beep(sound=10, expr=NULL)
}

DFtall <- total_callsigns %>% gather(key = Quarter, value = Value, `2020-11-16`:`2022-08-16`)

ggplot(DFtall, aes(Quarter, Value, fill = Quarter)) + 
  geom_col(position = "dodge") + 
  facet_wrap(vars(indicativ), ncol = 2) + 
  labs(title = "Numar indicative per district in timp.", x = "Data fisier", y = "Numar indicative")

#ggplot(data = total_callsigns, mapping = aes(x = indicativ, y = `2020-11-16`:`2022-08-16`, fill = origin)) +
#  geom_bar(position = "dodge")
