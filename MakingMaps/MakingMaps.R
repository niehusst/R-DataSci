#Liam Niehus-Staab
#Making Maps
#10/1/18

#imports
library(ggplot2)  # The grammar of graphics package
library(maps)     # Provides latitude and longitude data for various maps
library(dplyr)    # To assist with cleaning and organizing data

# read the state population data
StatePopulation <- 
  read.csv("~/Shared/F18MAT295/r-tutorials-master/intro-maps/data/StatePopulation.csv",
           as.is = TRUE)

### On Your Own Questions
MainStates = map_data("state")
#* Restrict the `states` and `all.cities` files to only a few contiguous states
NewStates <- filter(MainStates,region ==  "new york" | region ==
                    "vermont" | region ==  "new hampshire" | region ==
                    "massachusetts" | region ==  "rhode island" | 
                    region ==  "connecticut" )

#* color each state by the number of electorial votes in that state.
merged = inner_join(NewStates, StatePopulation, by = "region")
graph = ggplot() + 
  geom_polygon(data = merged, aes(x= long, y = lat, group = group, fill = elect_votes),
               color = "black") +
  scale_fill_continuous(name = "Colored by Electoral votes",
                        low = "pink", high = "purple")

#* Add a point to represent each city in these states.
cities <- filter(us.cities, country.etc == "NY" | country.etc == "RI" | 
                 country.etc == "NH" | country.etc == "MA" |
                 country.etc == "CT" | country.etc == "VT")

graph = graph + geom_point(data=cities, aes(x=long, y=lat), 
           color = "black") 
graph

#* Color the cities so state capitals are clearly differentiated from other cities. 
capitals = filter(cities, capital == 2)

graph = graph + 
    geom_point(data = capitals, aes(x = long, y = lat), color = "red")
graph




#### 1 ####  Create a base map of United States counties. Make sure you
             #use the `map_data` function as well as the `ggplot` function.
counties = map_data("county")
ggplot() + geom_polygon( data=counties, aes(x=long, y = lat, group = group), 
                         color = "black", fill = "blue")


#### 2 ####  Use the `world` file to create a base map of the world with white borders and dark blue fill. 
world = map_data("world")
ggplot() + geom_polygon(data = world, aes(x = long, y = lat, group = group),
                        color = "white", fill = "dark blue")


#### 3 ####  What happens to your base map when group is ignored?

ggplot() + geom_polygon( data=MainStates, aes(x=long, y=lat), color = "black", fill = "light blue")
#the graphing gets all messed up, lines are connecting a bunch of spots that shouldn't be connected 





# Use the dplyr package to merge the MainStates and StatePopulation files
MergedStates <- inner_join(MainStates, StatePopulation, by = "region")

# Create a Choropleth map of the United States with each state colored by population
ggplot()+ 
  geom_polygon( data=MergedStates, 
                       aes(x=long, y=lat, group=group, fill = population/1000000), 
                       color="white", size = 0.2) + 
  scale_fill_continuous(name="Population(millions)", 
                      low = "lightgreen", high = "darkgreen",limits = c(0,40), 
                      breaks=c(5,10,15,20,25,30,35), na.value = "grey50") +
  labs(title="State Population in the Mainland United States")

#### 4 #### What two columns were added to the **MainStates** file when it was joined with the **StatePopulation** file?

#population and elect_votes were added


#### 5 ####Create a choropleth map showing state populations. Make the state borders purple with size = 1. Also change 
#the color scale for state populations, with low populations colored white and states with high populations colored dark red.
#grph of pupulton in millison
gr = ggplot() +
  geom_polygon(data = MergedStates, aes(x=long, y=lat, group = group,fill = population/1000000), 
               color = "purple", size = 1) +
  scale_fill_continuous(name="Population(mil)", low="white", high="dark red")
gr

#### 6 #### Modify the graph and legend in Question 5) to show the log of populations instead of the population in millions. 
#In this map, explain why you will need to set new `limits` and `breaks`. *Hint: create a map without setting specific 
#`limits` and `breaks` values. How does the graph change?*

gr2 =  ggplot() +
  geom_polygon(data = MergedStates, aes(x=long, y=lat, group = group,fill = log(population)), 
               color = "purple", size = 1) +
  scale_fill_continuous(name="Population(mil)", low="white", high="dark red")
gr2
#its necessary to change the limits and breaks so that they accurately represent the new breaks
# and data created by log(pop). all the color looks the same when the limits arent changed