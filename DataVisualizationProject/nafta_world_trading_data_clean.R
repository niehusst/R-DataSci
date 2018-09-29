#Project 1
# CLEAN THE DATA TO ONLY HAVE WORLD TRADING VALUES FOR NAFTA COUNTRIES

#import dataset
merchandise_values_annual_dataset <- read.csv("Downloads/merchandise_values_annual_dataset.csv")

#import libraries
library(tidyr)   # contains tools to tidy data
library(ggplot2) # for plotting
library(dplyr)   # more data cleaning tools

# remove columns containing data that is irrelevant to analysis
# (Columns removed and why:
# Reporter_code : same info as Reporter_description
# Partner_code : same info as Partner_description
# Indicator_code : same info as Indicator_description
# Flow_Code : same info as Flow_Description
# Unit : all values are the same for every row
# Flag : no values for any row 
# Source_Description : same value for every row
# )
mva_clean = select(merchandise_values_annual_dataset,
                   Reporter_description,
                   Partner_description,
                   Indicator_description,
                   Flow_Description,
                   Year,
                   Value)

# clean out countries that are not NAFTA members 
# (and keep world values for comparison)
mva_clean = filter(mva_clean, 
                     Reporter_description == "Mexico" |
                     Reporter_description == "Canada" |
                     Reporter_description == "North American Free Trade Agreement (NAFTA)" |
                     Reporter_description == "United States of America" |
                     Reporter_description == "World excluding Hong Kong re-exports")

# remove non-world trade from data
mva_clean = filter(mva_clean, Partner_description == "World")
# remove the Partner_description column, as it now has the same value for all rows
mva_clean = select(mva_clean, -Partner_description)

# clean out all traded data that is not total merchandise
mva_clean = filter(mva_clean, Indicator_description == "Total merchandise")
# remove the Indicator_description row now that all the values are the same
mva_clean = select(mva_clean, -Indicator_description)

# give columns sensible names 
colnames(mva_clean) = c("Country", "Transactions", "Year", "Value")

# write clean data to csv file
write.csv(mva_clean, "~/Desktop/Data\ Science/DataVisualizationProject/merchandise_values_annual_dataset_clean.csv")
