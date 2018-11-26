#Liam Niehus-Staab
#Coffee Truck Lab
#9/17/18

#libs
library(dplyr)
library(ggplot2)
library(mosaic)

# import csv
coffeeSales <- read.csv("~/MAT295/CoffeeLab/coffee.csv")

#make a graphs
ggplot(data = coffeeSales, aes(x = Location, y = Sales)) + 
  geom_boxplot()  + 
  labs(title = "Box Plot of Sales by Location")

# null Hypothesis: There is no difference in average sales between the 
#                  park and the buisness district
# alternate Hypothesis: There is a non 0 difference between the two locations
business = filter(coffeeSales, Location == "Business")
park = filter(coffeeSales, Location == "Park")
t.test(park$Sales, business$Sales)
#OUTPUT:
# t = -6.1196, df = 17.91, p-value = 9.025e-06
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -26.73432 -13.06568
# sample estimates:
#   mean of x mean of y 
# 72.8      92.7 

#REPORT:
# Dear Joe,
# My analysis of the sales data you collected is complete. I conducted a simple T test on 
# the data for number of sales by location and found some good evidence that there is a
# difference between the productivity of your shop at the two locations. Now I have some
# good news and some bad news. The good news is that the business district appears to 
# consistently make more sales than the park. The T test showed a very small p value, 
# signifying that the chance that these sales results being pure chance are tiny and gives
# us good reason to reject the hypothesis that there was no difference between the locations. 
# The mean number of sales for the business district is about 14% higher than that of the 
# park. If you wish to continue with your coffee truck, I would recommend selling in the 
# business district. That brings us to the bad news: you didnt make a positive profit
# for any of the days. Really consider if this is what you want to do with your money.
