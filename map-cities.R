# defining a data frame template to populate throughut geocoding process
data_df = as.data.frame(matrix(nrow=20,ncol=3))
colnames(data_df) = c("location","lat","long")

# adding city and town names as locations
data_df$location = c("Hamburg, Germany",      #1
                     "Dortmund, Germany",    #2
                     "Stuttgart, Germany",     #3
                     "Berlin, Germany",        #4
                     "Dresden, Germany", #5
                     "Bremen, Germany", #6
                     "Leipzig, Germany",   #7
                     "Kiel, Germany",    #8
                     "Rostock, Germany",  #9
                     "Karlsruhe, Germany",     #10
                     "Siegen, Germany",  #11
                     "Bonn, Germany",     #12
                     "Essen, Germany", #13
                     "Gelsenkirchen, Germany",     #14
                     "Marburg, Germany",       #15
                     "Frankfurt am Main, Germany",      #16
                     "Heidelberg, Germany",    #17
                     "Freiburg, Germany",      #18
                     "Pforzheim, Germany",    #19
                     "Flensburg, Germany"  #20
)

# importing tidygeocoder package in R
library(tidygeocoder)

# using the geo_osm() function to geocode locations
for(i in 1:nrow(data_df)){
  coordinates = geo_osm(data_df$location[i])
  data_df$long[i] = coordinates$long
  data_df$lat[i] = coordinates$lat
}

# importing leaflet, leaflet.extras and magrittr
library(leaflet)
library(leaflet.extras)
library(magrittr)

# creating a heat map for the burger search intensity according to Google trends
data_df %>%
  leaflet() %>% 
  addTiles() %>% 
  addProviderTiles(providers$OpenStreetMap.DE) %>% 
  setView(mean(data_df$long),mean(data_df$lat),5) %>%
  addMarkers()
library(mapview)
latticeview(data_df)
