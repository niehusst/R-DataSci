#Liam Niehus-Staab
#ggplot Lab
#9/12/18

# import libs and csv
library(dplyr)
library(ggplot2)
library(mosaic)
#important to use read.csv instead of read_csv, because _ keeps spaces in col names, 
#making ggplot impossible to use
AmesHousing <- read.csv("~/Shared/F18MAT295/r-tutorials-master/data-viz/data/AmesHousing.csv")

### On My Own Questions

#clean data;
#Restrict the `AmesHousing` data to only sales under normal conditions. 
cleanHousing = filter(AmesHousing, Condition.1 == "Norm")

#Create a new variable called `TotalSqFt` and remove homes with >3000 total sq feet.
cleanHousing = mutate(cleanHousing, TotalSqFt = Gr.Liv.Area  +  Total.Bsmt.SF)
cleanHousing = filter(cleanHousing, Total.Bsmt.SF <= 3000)

# Create a new var, `No` indicates no fp in home and `Yes` indicates fp(s) in home.
cleanHousing = mutate(cleanHousing, hasFireplace = cleanHousing$Fireplaces >= 1)
cleanHousing$hasFireplace[cleanHousing$hasFireplace == TRUE] = "Yes"
cleanHousing$hasFireplace[cleanHousing$hasFireplace == FALSE] = "No"

#### make a graphic involving no more than three explanatory variables to predict sales price. 
#overall.qula andn bsmt.qual both seem to be good predictors. Better one?
#x=bsmt.qula as a boxplot looks good (HOWEVER BSMT.QULA IS STRONGLY CORRELATED WITH YEAR.BUKLT)
#Full.Bath is decent predictor?
# garage stuff (Garage.Type)
ggplot(data = cleanHousing, aes(x = TotalSqFt, y = (SalePrice)/100000 )) + 
  geom_point()  + 
  aes(colour = Bsmt.Qual)  + 
  stat_smooth(method = lm) + 
  labs(title = "Ames Home Sale Price by Total Area", 
       x = "Total Area (ft^2)",
       y = "Sale Price ($100000)",
       colour = "Basement Quality") +
  scale_color_hue(labels = c("Excellent", "Fair", "Good", "Average", "NA")) 
#created with mplot(data) then render expression from the gear



# Lab notes

### qplot (quick plot)

#historgraam; by only specifying 1 var
qplot(data = AmesHousing, x = SalePrice, main = "Histogram of Ames Housing Prices")

# scatterplot; specify 2 vars (both quantitative)
qplot(data = AmesHousing, x = Gr.Liv.Area, y = SalePrice)

# color the data by a var; specify color
qplot(data = AmesHousing, x = Gr.Liv.Area, y = SalePrice, color = Kitchen.Qual)

# scat plot w/ log transformed vars; 
qplot(data = AmesHousing, x = log(Gr.Liv.Area), y = log(SalePrice), 
      color = Kitchen.Qual)

# create separate scat plots for each type of kitch qual and num fireplaces
qplot(data=AmesHousing,x=Gr.Liv.Area,y=SalePrice,facets=Kitchen.Qual~Fireplaces)

# dot plot; spec 2 vars (one quantitative, other qualitative)
qplot(data=AmesHousing, x=Kitchen.Qual, y=SalePrice)

#boxplot; specify geo
qplot(data=AmesHousing, x=Kitchen.Qual, y=log(SalePrice), geom="boxplot")

############ Question 1 ##############
# In this dataset, how many houses were sold with four fireplaces?
#There was 1 house sold with 4 fireplaces.

############ Question 2 ##############
# What is the `facet` argument used for?
#Faceting is used to make multiple graphs, each showing the x and y variable
#compared for the input categorical variables.

############ Question 3 ##############
# Based upon the data documentation, what are the five different levels for 
# kitchen quality?
#Excelent, Fair, Good, Poor, and Typical/Average

############ Question 4 ##############
# Do these graphs indicate that the quality of a kitchen could be related to the 
# sale price?
#It looks like there could be some sort of relationship, however, it does not
#appear to be a very strong one, and would need greater support than the 
#facetted graphs can give alone.

############ Question 5 ##############
# In the RStudio console, type `?qplot`. Modify the above code to create a barchart 
# (`geom=bar`) of sales by kitchen quality. Modify the x-axis label to state 
# "Sale Price of Individual Home" instead of "SalePrice"
qplot(data = AmesHousing, x = Kitchen.Qual, geom="bar", xlab= "Sale Price of Individual Home")
#this doesn't do exactly that


### ggplot

# all ggplot calls require a data frame, aesthetics (x,y), and geometry. e.g.
#ggplot(data) + geom_line(aes(x, y))

############ Question 6 ##############
#geom_point makes a scatter ploot
ggplot(data=AmesHousing,aes(x=Gr.Liv.Area, y=SalePrice)) + geom_point()

############ Question 7 ##############
# a scatter* plot of fireplaces vs sale price
ggplot(AmesHousing) + geom_point(aes(Fireplaces, SalePrice))

# ggplot extra stuff can be layered to add a lot of info to a graph
ggplot(data=AmesHousing) +                         
  geom_histogram(mapping = aes(SalePrice/100000),                          # HISTOGRAM
                 breaks=seq(0, 7, by = 1), col="red", fill="lightblue") + 
  geom_density(mapping = aes(x=SalePrice/100000, y = (..count..)))  +      # DENSITY LINE
  labs(title="Figure 9: Housing Prices in Ames, Iowa (in $100,000)",       # LABELS
       x="Sale Price of Individual Homes") 

# some types of plot fluf to increase the info analysis are::
#  `geom_smooth` adds a fitted line through the data.  
#  `method=lm` specifies a linear regression line. `method=loess`
#creates a smooth fit curve.
#  `se=FALSE` removes the shaded confidence regions around each line. 
#  `fullrange=TRUE` extends all regression lines to the same length
#  `facet_grid` and `facet_wrap` commands are used to create multiple plots.
#  When assigning fixed characteristics, (such as `color`, `shape` or `size`), 
#the commands occur outside the `aes`, as in Figure 10, `color="green"`. 
#When characteristics are dependent on the data, the command should occur within 
#the `aes`, such as in Figure 11 `color=Kitchen.Qual`.


############ Question 8 ##############
# historgram of GR.liv.arai
ggplot(AmesHousing) + geom_histogram(aes(Gr.Liv.Area))

############ Question 9 ##############
#scatterplot w/ `Year.Built` as the x and `SalePrice` as y.
# also has regression line, a title, and labels for the x y axes
ggplot(AmesHousing) + 
  geom_point(aes(Year.Built,SalePrice)) +
  geom_smooth(aes(Year.Built,SalePrice), method="lm", se = FALSE) +
  labs(title="Sale Price vs Year Built w/ regression",
       y = "Sale Price($)", x = "Year Built (CE)")

############ Question 10 ##############
#points are colored by the overall condition of the home, `Overall.Cond`. 
ggplot(AmesHousing) + 
  geom_point(aes(Year.Built,SalePrice, color = Overall.Cond)) +
  geom_smooth(aes(Year.Built,SalePrice), method="lm", se = FALSE) +
  labs(title="Sale Price vs Year Built w/ regression",
       y = "Sale Price($)", x = "Year Built (CE)")


### mplot
# The mplot function can be used for a helpful visual walkthrough of how to
# create a ggplot. useful stuff (just call mplot on the data in the console)


