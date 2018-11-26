#Clean census data for shiny app project 2

library(dplyr)
library(tidyr)
census2015 = read.csv("~/Downloads/acs2015_county_data.csv")

#filter so that only Iowa counties are kept
census2015 = filter(census2015, State == "Iowa")

#remove censusID and State columns, as they don't tell us anything
census2015 = select(census2015, -(CensusId), -(State))

#remove punctuation
census2015$County = gsub("[']+","", census2015$County)

Worldshapes <- readShapeSpatial("~/Shared/F18MAT295/r-tutorials-master/maps-shapefiles/data/ne_50m_admin_0_countries")
Worldshapes_tidied <- tidy(Worldshapes)
counties = map_data("county")                    # get US county data
counties = select(counties, -(order))  # delete useless columns
counties = filter(counties, region == "iowa")    # keep only Iowa counties

census2015$County = sapply(census2015$County, tolower) # make all county names lowercase for merging

# merge data together
merged = inner_join(counties, census2015, by = c("subregion" = "County"))

# write clean data to csv file
write.csv(merged, "~/MAT295/Project2/IowaCensusShapelyDataMerged.csv")
