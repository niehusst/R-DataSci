# clean data to show:
# us <-> mexico trading total merchandise
# canada <-> us trading total merchandise
# canada <-> mex trading total merchandise

# FILE OBSOLETE. THE RENDERED DATA SHOWS NO INFORMATION BEFORE THE YEAR 2000
# AND THERE IS NO DATA AT ALL ON CANADA.

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
                     Reporter_description == "United States of America")

# clean out all traded data that is not total merchandise
mva_clean = filter(mva_clean, Indicator_description == "Total merchandise")
# remove the Indicator_description row now that all the values are the same
mva_clean = select(mva_clean, -Indicator_description)

# get us mexico inter trading data
us_mex = filter(mva_clean, (Reporter_description == "United States of America" & Partner_description == "Mexico") | 
                              (Reporter_description == "Mexico" & Partner_description == "United States of America"))

# get us canada inter trading data
us_can = filter(mva_clean, (Reporter_description == "United States of America" & Partner_description == "Canada") | 
                  (Reporter_description == "Canada" & Partner_description == "United States of America"))
# get canada mexico inter trading data
can_mex = filter(mva_clean, (Reporter_description == "Canada" & Partner_description == "Mexico") | 
                   (Reporter_description == "Mexico" & Partner_description == "Canada"))

# stitch separate data sets back together
inter_nafta_trading = rbind(us_mex, us_can, can_mex)

# give columns sensible names 
colnames(inter_nafta_trading) = c("Country", "TradePartner", "Transactions", "Year", "Value")

# write clean data to csv file
write.csv(inter_nafta_trading, "~/Desktop/Data\ Science/DataVisualizationProject/inter_nafta_trading_dataset_clean.csv")

