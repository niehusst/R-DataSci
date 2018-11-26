#Liam Niehus-Staab
#NYPDLab
#9/4/18

#NOTE: This code was not written by me, it was written by Jeff Jonkman(?)


# get packages
if( !require(maptools) ) install.packages("maptools")
require(maptools) # This package helps us work with spatial objects

if( !require(ggmap) ) install.packages("maptools")
require(ggmap) # This helps create a base map to give spatial context


# load csv files
SQFarrests <- read.csv("~/Shared/F18MAT295/SQFarrests.csv")
precincts <- read.csv("~/Shared/F18MAT295/precincts.csv")

# get averages for each race

# Percentage of people arrested overall
sum(SQFarrests$TotalArr)/sum(SQFarrests$Population)
# Percentage of white people arrested
sum(SQFarrests$WhiteArr)/sum(SQFarrests$White)
# Percentage of African-Americans arrested
sum(SQFarrests$BlackArr)/sum(SQFarrests$Black)


# make bar graph of proportions of arrests
# Defines the function. You only need to run this code once.
createRaceChart <- function(precinct = SQFarrests$Precinct){
  currentPrecinct <- colSums(SQFarrests[ SQFarrests$Precinct %in% precinct, ])
  pctPopulation <- as.numeric(currentPrecinct[c('White', 'Black', 'Hisp', 'AsPac', 'Native')])
  pctArrests <- as.numeric(currentPrecinct[c('WhiteArr', 'BlackArr', 'HispArr', 'AsPacArr', 'NativeArr')])
  graph_max <- max(pctArrests/pctPopulation * 100, na.rm=TRUE)+1
  
  barplot(
    rbind(
      pctArrests/pctPopulation *100, rep(graph_max,5)-pctArrests/pctPopulation*100
    ), # Arrested in precinct/Living in precinct
    
    main = paste0("Proportion of Population Arrested, by Race"),
    names.arg = c("White", "Afrn Am.", "Hispanic", "Asian", "Natv Am."),
    ylim = c(0,graph_max),
    xlab = "Race", ylab = "Percent in Precinct (%)")
  mtext("(Number of arrests divided by number living in selected precincts)", padj = -0.6)
}

createRaceChart()


# Grabs a map of New York City from Google's Open Street Map
NewYork <- get_map(location = "New York", zoom = 10, source = "osm")

#merge map data and arrest data
mapData <- merge(SQFarrests, precincts, by = "Precinct")


# Plots mapData on top of the New York City map.
ggmap(NewYork) + 
  ggtitle( "Population by Precinct" ) + 
  geom_polygon(data = mapData, alpha = 0.7,
               aes(x = long, y = lat, group = polygon, 
                   # Set `fill` to the column you want to color precincts by
                   fill = Population )) + 
  geom_path(data = mapData, size = 0.3,
            aes(x = long, y = lat, group = polygon)) +
  scale_fill_gradient(low = "yellow", high = "red", 
                      # Set trans = "identity" to get a linear scale
                      trans = "log" ) + 
  coord_cartesian(xlim = c(-74.27, -73.67), ylim = c(40.48, 40.94))


# set data without precinct 22
SQFarrests <- subset( SQFarrests, SQFarrests$Precinct != 22 )
mapData <- subset( mapData, mapData$Precinct != 22 )

# Plot mapData
SQFarrests$Precinct[ SQFarrests$Black == max(SQFarrests$Black) ]

# plot data for precint 67
pct67 <- SQFarrests[ SQFarrests$Precinct == 67, ]

pct67$BlackArr/pct67$Black
pct67$WhiteArr/pct67$White
createRaceChart(precinct = 67)

# Plots mapData on top of the New York City map.
ggmap(NewYork) + 
  ggtitle( "Proportion of African-Americans arrested, by Precinct" ) + 
  geom_polygon(data = mapData, alpha = 0.7,
               aes(x = long, y = lat, group = polygon, 
                   # Set `fill` to the column you want to color precincts by
                   fill = BlackArr/Black )) + 
  geom_path(data = mapData, size = 0.3,
            aes(x = long, y = lat, group = polygon)) +
  scale_fill_gradient(low = "yellow", high = "red", 
                      # Set trans = "identity" to get a linear scale
                      trans = "log" ) + 
  coord_cartesian(xlim = c(-74.27, -73.67), ylim = c(40.48, 40.94))

# show wehre are african americans most likely to be arrested
SQFarrests$Precinct[ SQFarrests$BlackArr/SQFarrests$Black == max(SQFarrests$BlackArr/SQFarrests$Black) ]
createRaceChart(14)


