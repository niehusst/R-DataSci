#Liam Niehus-Staab
#Maps with shapefiles Lab
#10/3/18

# load required packages
library(maptools) # creates maps and work with spatial files
library(broom)    # assists with tidy data
library(ggplot2)  # graphics package
library(leaflet)  # interactive graphics (output does not show in RMD files)
library(dplyr)    # joining data frames
library(readr)    # quickly reads files into R
# Reads the shapefile into the R workspace.
TerrorismData <- read_csv("~/Shared/F18MAT295/r-tutorials-master/maps-shapefiles/data/terrorismData.csv")

Worldshapes <- readShapeSpatial("~/Shared/F18MAT295/r-tutorials-master/maps-shapefiles/data/ne_50m_admin_0_countries")
Worldshapes_tidied <- tidy(Worldshapes)
str(Worldshapes, max.level = 2)

###  On your own question
# Both **Worldshapes** and **TerrorismData** files have a column that defines a 
# region as `Europe and Central Asia` 
# (see `Worldshapes@data$region_wb` and`TerrorismData$region2`). 
# Create a map of all incidents that occured in `Europe and Central Asia` during 2013. 
# What countries appear to have the most incidents? Give a short (i.e. one paragraph) 
# description of the graph. This description should include an identification of the 
# countries with the most incidents. 

#filter correct data
inc2013Eurasia = filter(TerrorismData, iyear == 2013, region2 == "Europe & Central Asia")

#graph incidents on map
eurasia <- ggplot() + geom_point(data = inc2013Eurasia, 
                                aes(x = longitude, y = latitude, size = severity), 
                                color = "red", alpha = .5) + 
  coord_cartesian(xlim = c(-10,70), ylim = c(35, 67)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3) +
  labs(title = "Terrorism in Europe & Central Asia (2013)", x = "Longitude", y = "Lattitude")
eurasia #visualize

# It appears that the UK and Russia have the most incidents of the Eurasian countries
# in 2013. The highest concentration of incidents are in Northern Ireland (UK) and 
# the Russia-Georgia border area in the Caucasus mountains. This makes sense as Northern
# Ireland is the main opperating turf of the the Irish Republican Army, and the 
# Caucasus mountians has been the location of fighting between Russia and Islamic State
# forces.


### lab work through ###


# The `readShapeSpatial` from the `maptools` package allows us to load all component files simultaneously.
# The `str` command allows us to see that the `Worldshapes` object is of the class `SpatialPolygonsDataFrame`. This means that R is representing this shapefile as a special object consisting of 5 slots of geographic data. The first slot, (and the most relevant to us) is the data slot, which contains a data frame representing the actual data adjoined to the geometries. Similar to how we access a column in a data frame with the `$` infix, we can also access a slot in a shapefile with the `@` infix.
# The `max.level=2` limits the information that is printed from the `str` command. 


Worldshapes_tidied <- tidy(Worldshapes) # have to tidy it because shape files cant be read directly

g <- ggplot() +
  geom_polygon(data = Worldshapes_tidied, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black")
g #map of the world


# create a new terrorism data frame that includes only four years
Incidents2 <- filter(TerrorismData, iyear == 1975 | iyear == 1985 | iyear == 1995 |iyear == 2005)

p <- ggplot() + geom_point(data = Incidents2, 
                           aes(x = longitude, y = latitude, size = severity), 
                           size = 1, color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  coord_cartesian(xlim = c(-11, 3), ylim = c(51, 59)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3)
p #map of terrorism occurences in uk and ireland



##### QUESTIONS #########

# 1) Create a graph that shows the terrorism incidents that occured in the United 
#States during 2001. Have the size and color of the incident be determined by `severity`.
Incidents3 <- filter(TerrorismData, iyear == 2001)

us <- ggplot() + geom_point(data = Incidents3, 
                           aes(x = longitude, y = latitude, size = severity), 
                           color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  coord_cartesian(xlim = c(-125, -60), ylim = c(25, 50)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3) +
  labs(title = "Terrorism in the US (2001)", x = "Longitude", y = "Lattitude")
us

# 2) Suppose you want to look the effects of terrorism before, during, and after the 
#United States invasion of Iraq in 2003. Create three maps of the area, displayed 
#side-by-side. Hint: You might also want to center the map on Iraq using 
#`xlim = c(35,50)` and `ylim = c(28,38)`.
Iraqbefore <- filter(TerrorismData, iyear == 2002)
Iraqduring <- filter(TerrorismData, iyear == 2003)
Iraqafter <- filter(TerrorismData, iyear == 2004)

before <- ggplot() + geom_point(data = Iraqbefore, 
                            aes(x = longitude, y = latitude, size = severity), 
                            color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  coord_cartesian(xlim = c(35,50), ylim = c(28,38)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3) +
  labs(title = "Terrorism in Iraq (2002)", x = "Longitude", y = "Lattitude")

during <- ggplot() + geom_point(data = Iraqduring, 
                                aes(x = longitude, y = latitude, size = severity), 
                                color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  coord_cartesian(xlim = c(35,50), ylim = c(28,38)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3) +
  labs(title = "Terrorism in Iraq (2003)", x = "Longitude", y = "Lattitude")

after <- ggplot() + geom_point(data = Iraqafter, 
                               aes(x = longitude, y = latitude, size = severity), 
                               color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  coord_cartesian(xlim = c(35,50), ylim = c(28,38)) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               fill = "lightblue", color = "black", alpha = .3) +
  labs(title = "Terrorism in Iraq (2004)", x = "Longitude", y = "Lattitude")

before
during
after

# 3) Create a world map colored by the square root of the estimated population 
#`sqrt(pop_est)` from the `Worldshapes@data`. Does it appear that population is highly
#correlated with the number of incidents that occur?
pop = tidy(Worldshapes2@data$pop_est) 

world = ggplot() +
  geom_point(data = Incidents3, aes(x = longitude, y = latitude, size = severity), 
             color = "red", alpha = .5) + 
  facet_wrap(~iyear) + 
  geom_polygon(data = Worldshapes2, 
               aes(x = long, y = lat, group = group),
               color = "black", alpha = .3) +
  scale_fill_continuous()
  labs(title = "Terrorism vs Square root of population", x = "Longitude", y = "Lattitude")
world #trash


#### Leaflets ####

library(leaflet)

# Subset terrorism database to only contain events in Europe in 1984
US2000.05Incidents <- filter(TerrorismData, iyear == 2000 | iyear == 2001 | iyear == 2002 | iyear == 2003 | iyear == 2004 | iyear == 2005) 
                              #country_txt == "United States")

# addTiles()  Add background map
# setView( Set where the map should originally zoom to
leaflet() %>%
  addTiles() %>% 
  setView(lng = -125, lat = -100, zoom = 4) %>% 
  addCircleMarkers(data = data,
                   lat = ~latitude, lng = ~longitude,
                   radius = ~severity, popup = ~info,
                   color = "red", fillColor = "yellow")
