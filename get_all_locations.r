library("readxl")
library("tidyr")


callbook_latest <- read_xlsx("Callbook_18_07_2022.xlsx")
cb_latest <- callbook_latest %>%
  filter(LOCALITATEA != "DATE PERSONALE") %>%
  unite(col = "full_address", c(ADRESA, LOCALITATEA, JUDETUL), sep = " ")
glimpse(cb_latest)

write.csv(cb_latest, "latest_addresses.csv")