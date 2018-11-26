# Liam Niehus-Staab
# Assignment 1
# 9/4/18

#make a vector
lst = seq(from=3, to=8, by=.5)
#make a matrix
mat = matrix(c(3,7,4,2,5,6),nrow = 2, byrow = TRUE)
#print
lst
mat

#load csv data
AmesHouseing = read.csv("~/Shared/F18MAT295/r-tutorials-master/data-viz/data/AmesHousing.csv")
#get mean
m = mean(AmesHouseing$SalePrice, na.rm=TRUE)
#get standard deviation
stddev = sd(AmesHouseing$SalePrice, na.rm=TRUE)
#print
m
stddev