library(leaflet)
m = leaflet() %>% addTiles()
m  # a map with the default OSM tile layer

m = m %>% setView(-93.65, 42.0285, zoom = 17)
m

m %>% addPopups(-93.65, 42.0285, 'Here is the <b>Department of Statistics</b>, ISU')

mm <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
