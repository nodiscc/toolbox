#!/bin/bash:
#Description: WIP raspberry-pi based GPS device

aptitude install navit maptool navit-gui-internal navit-graphics-gtk-drawing-area
wget http://download.geofabrik.de/europe/france-latest.osm.bz2 #4.8GB, several hours on DSL
bzcat france-latest.osm.bz2 | maptool -6 navit-france.bin #92m 21s on Intel Q9400, outfile 2GB
rm *.tmp

#doc http://wiki.navit-project.org/index.php/OpenStreetMap
#doc http://wiki.navit-project.org/index.php/Basic_configuration
#Note: search must be done through menu > current coordinates > POI (city search does not work)
#TODO rPi see: http://wiki.navit-project.org/index.php/Raspberry_Pi
#TODO edit /etc/navit:
#     add navit-france.bin to http://wiki.navit-project.org/index.php/OpenStreetMap#Add_OSM_map_to_your_mapset
#     custom OSD widgets (speed, clock, etc;) -> http://wiki.navit-project.org/index.php/OSD
# TODO: SLOW, try with smaller maps, enable them one at a time in the mapset