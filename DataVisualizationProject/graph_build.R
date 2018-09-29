#build graphs
#project 1

library(tidyr)   # contains tools to tidy data
library(ggplot2) # for plotting
library(dplyr)   # more data cleaning tools

#import all data sets
data = read.csv("~/Desktop/Data\ Science/DataVisualizationProject/merchandise_values_annual_dataset_clean.csv")
inter_nafta = read.csv("~/Desktop/Data\ Science/DataVisualizationProject/inter_nafta_trading_dataset_clean.csv")

### GRAPH OF WORLD TRADING BY ALL NAFTA COUNTRIES

# get data on each country imports 
us_in = filter(data, Country == "United States of America" & 
                 Transactions == "Imports")
mex_in = filter(data, Country == "Mexico" & 
                  Transactions == "Imports")


#get data on each country exports
us_out = filter(data, Country == "United States of America" & 
                  Transactions == "Exports")
mex_out = filter(data, Country == "Mexico" & 
                   Transactions == "Exports")

# function to get the first Value data for a data set
normalize_func = function(dataset) {
  return(as.numeric(dataset$Value[1]))
}

# normalize Value column by dividing every value by the 1948 value of trading
us_in = mutate(us_in, percentage_of_1948_Value = Value / normalize_func(us_in))
mex_in = mutate(mex_in, percentage_of_1948_Value = Value / normalize_func(mex_in))

us_out = mutate(us_out, percentage_of_1948_Value = Value / normalize_func(us_out))
mex_out = mutate(mex_out, percentage_of_1948_Value = Value / normalize_func(mex_out))

#merge separate data back together
data_normalized = rbind(us_in, us_out, mex_in, mex_out)


# plot of Nafta countries imports and exports
ggplot(data = data_normalized, aes(x = Year, y = percentage_of_1948_Value)) + 
  geom_line()  + aes(colour = Country) + 
  facet_wrap(~Transactions, ncol = 4) + 
  labs(title = "Trade Percentage Growth by Year",
       y = "Percentage of 1948 Value")


### GRAPH OF HOW NAFTA AFFECTED INTER MEMBER TRADING RATES
#only has data from year 2000
ggplot(data = inter_nafta, aes(x = Year, y = Value)) + geom_line()  + aes(colour = Transactions) + 
  facet_wrap(~TradePartner, ncol = 4) + 
  labs(title = "Transaction Values Growth by Year")
