from time import sleep
import folium as fo
from folium.plugins import MarkerCluster
import pandas as pd
from geopy.geocoders import Nominatim

# code
app = Nominatim(user_agent="test")
# address = "STR. IZLAZ 6 TIMISOARA TIMIȘ" #"175 5th Avenue NYC" #"First St SE, Washington, DC 20004, United States"
# location = app.geocode(address)
# print(location)
# print(location.latitude, location.longitude)
markers = []

locations = pd.read_csv('latest_addresses.csv')
for index, row in locations.iterrows():
    print(row.full_address)
    l = app.geocode(row.full_address)
    if l is not None:
        markers.append(l)
        print(l.latitude, l.longitude)
    sleep(1.5) # avoid overloading the server

#Define coordinates of where we want to center our map
boulder_coords = [46.015, 25.2705]

#Create the map
map = fo.Map(location = boulder_coords, zoom_start = 7)

for m in markers:
    fo.Marker(location = [m.latitude, m.longitude], popup = m.address).add_to(map)

map.save('map.html')
