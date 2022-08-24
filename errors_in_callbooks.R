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

districte <- c("YO2", "YO3", "YO4", "YO5", "YO6", "YO7", "YO8", "YO9")
total_callsigns <- data.frame(districte)
print("TOTAL Callsigns:")
print(total_callsigns)
cs <- data.frame()

for (f in files) {
  print(f)
  fname <- tools::file_path_sans_ext(f)
  a <- stringr::str_split(fname, "_")
  d <- toDate(a[[1]][4], a[[1]][3], a[[1]][2])
  col_name = as.character(as.Date(d))
  print(col_name)
  
  #read XLSX file
  callbook <- read_xlsx(f)
  #make column with only first 3 chrs from the callsign
  callbook$ShortIndicativ <- substr(callbook$INDICATIVUL, 1,3)
  callbook$FullAddress <- paste(callbook$ADRESA, callbook$LOCALITATEA, callbook$JUDETUL, sep = ", ")
  glimpse(callbook)
  print("Errors in CLASS vs Callsign:")
  err <- callbook %>%
    filter(stringr::str_length(INDICATIVUL)<6 & CLASA > 2)
  print(err)
  
  print("Errors in callsign name:")
  err2 <- callbook %>%
    filter(!ShortIndicativ %in% districte)
  print(err2)
#  expire <- callbook %>%
#    filter( `DATA EXPIRARII` < date())
#  print(expire) 

  print("Nr callsigns per CLASA:")
  clasa <- callbook %>%
    group_by(CLASA) %>%
    summarize(nr = n())
  print(clasa)
  
  print("Nr callsigns per CLASA per district:")
  clasa_per_yo <- callbook %>%
    group_by(ShortIndicativ) %>%
    count(CLASA)
    #summarize(nr = n())
  print(clasa_per_yo)
  
  print("Nr callsigns care expira in 2022:")
  expirate <- callbook %>%
    filter(as.Date(`DATA EXPIRARII`) < as.Date("2023-01-01")) %>%
    summarize(nr = n())
  print(expirate)

  print("Nr callsigns care pierd rezervarea in 2023:")
  limita <- callbook %>%
    filter(as.Date(`DATA LIMITA A REZERVARII`) < as.Date("2023-01-01")) %>%
    summarize(nr = n())
  print(limita)
  
  #how many radioamateurs per district, county and city
  print("Nr callsigns per CLASA per district:")
  callsign_count <- callbook %>%
    filter(ShortIndicativ %in% districte) %>%
    count(ShortIndicativ) %>%
    mutate(quarter = col_name)
  cs <- rbind(cs, callsign_count)
  print(callsign_count)
  
  total_callsigns <- total_callsigns %>%
    inner_join(callsign_count, by = c("districte" = "ShortIndicativ")) %>%
    rename(!!col_name := n)
#  [col_name] <- callsign_count$ShortIndicativ
  beep(sound=10, expr=NULL)
}

DFtall <- total_callsigns %>% gather(key = Quarter, value = Value, `2020-11-16`:`2022-08-16`)

ggplot(DFtall, aes(indicativ, Value, fill = Quarter)) + geom_col(position = "dodge")
ggplot(clasa_per_yo, aes(x = ShortIndicativ, y = n, fill = CLASA)) + geom_col() + 
  labs(title = "Numar indicative 2022-08-16", x = "District", y = "Numar")
ggplot(clasa_per_yo, aes(x = ShortIndicativ, y = n, fill = CLASA)) + geom_bar(position = position_dodge(preserve = "single"))

ggplot(data = total_callsigns, mapping = aes(x = districte, y = `2020-11-16`:`2022-07-18`, fill = origin)) + geom_line()

cs %>% 
  ggplot(aes(x = n, colour = quarter)) + 
  facet_wrap(vars(ShortIndicativ), ncol = 2) +
  geom_point(stat = "count") +
  geom_line(stat = "count") +
  labs(x="resp (1 to 5)", y="Number of ...")

cs %>% 
  ggplot(aes(x=quarter ,y = n, fill = quarter)) + 
  geom_bar() + 
  facet_wrap(vars(ShortIndicativ), ncol = 2) +
  labs(x="resp (1 to 5)", y="Number of ...")

ggplot(data = cs, mapping = aes(x = quarter, y=n)) +
  geom_point()
  facet_wrap(~ ShortIndicativ, ncol = 2)


