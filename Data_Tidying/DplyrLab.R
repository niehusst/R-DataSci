#Liam Niehus-Staab
#DPLYR Lab
#9/10/18

# load dplyr package and data set
colleges <- read.csv("data/colleges2015.csv")
library(dplyr)



### OnMyOwn questions
# 1. Filter the rows for colleges in Great Lakes or Plains regions.
glAndPlains = filter(colleges, region == "Great Lakes" | region == "Plains")

# 2. Arrange the subset from part #1 to reveal what school has the highest 
# first-year retention rate in this reduced data set.
glpRetention = arrange(glAndPlains, desc(FYretention))
# it's a 4 way tie for 1st, all the colleges had 100% retention;
#Sacred Heart Major Seminary
#Cleveland University-Kansas City
#Kenrick Glennon Seminary
#Yeshiva Gedolah of Greater Detroit

# 3. Arrange the subset from part #1 to reveal what school has the lowest 
# admissions rate in this reduced data set.
glpLowAdmit = arrange(glAndPlains, admissionRate)
# University of Chicago has the lowest admission rate of these regions
 
# 4. Using the full data set, create a column giving the cumulative average 
# cost of attendance, assuming that students finish in four years and that  
# costs increase 3% per year. Name this new column `total.avg.cost4`.
colleges = mutate(colleges, 
                  total.avg.cost4 = cost + (cost + cost*(3.0/100)) + 
                    (cost + cost*(6.0/100)) + (cost + cost*(9.0/100)))

# 5. Using the full data set, summarize the distribution of total cost of 
# attendance by region using the five number summary. Briefly describe any 
# differences in total cost that you observe.
summarize(colleges, 
          min = min(total.avg.cost4, na.rm = TRUE), 
          Q1 = quantile(total.avg.cost4, .25, na.rm = TRUE), 
          median = median(total.avg.cost4, na.rm = TRUE), 
          Q3 = quantile(total.avg.cost4, .75, na.rm = TRUE), 
          max = max(total.avg.cost4, na.rm = TRUE))
# There is a massie disparity between the least and most expensive schools; it costs over $200,000 more to attend the
# most expensive school for 4 years. Also, judging by the greater range of values in the 3rd and 4thquartiles (when compared 
# with the ranges of the 1st and 2nd quartiles), total tuition costs hike up non-linearly for the more expensive schools.





#lab notes

### Filtering

#extract and keep all rows that have the "WI" value in a cell
wi <- filter(colleges, state == "WI")
# to eleminate rows that have NA values in a certain column, do:
#colleges <- filter(colleges, !is.na(cost))

########## QUESTION 1 ###########
# how many colleges are in Maryland?
md = filter(colleges, state == "MD")
length(md)
#output: 15
# There are 15 colleges in Maryland

########## QUESTION 2 ###########
# number of private colleges in maryland?
mdPriv = filter(colleges, type == "private", state == "MD")
length(mdPriv)
#output: 15
# There are 15 private colleges in Maryland



### Slicing

#extract rows 10-16
slice(colleges, 10:16)
# extracting rows that are non-consecutive use a vector; c(3, 6)



### Arranging

# sorting the rows by a column value (default smallest at top)
costDFmin <- arrange(colleges, cost)
# sort in reverse order, with largest at top
costDFmax <- arrange(colleges, desc(cost))

########## QUESTION 3 ###########
# what college is most epensive?
head(costDFmax)
#output:Sarah Lawrence College           62636   
# Sarah Lawrence College is the most expensive college in the data.

########## QUESTION 4 ###########
# what wisconsin college has least expensive tution?
cheap = arrange(wi, cost)
head(cheap)
#output: University of Wisconsin-Parkside   15218
# U of Wisconsin-Parkside is the least expensive college in WI



### Selecting Cols

# to slice out only a few columns, the select function can be used;
# select the 6 specified rows (keep only the 6 here)
lessCols <- select(colleges, college, city, state, undergrads, cost)

#to do opposite and remove only specified, use a negative sign
drop_unitid <- select(colleges, -unitid)



### Mutate

# use the mutate function to create a new column using data in other cols
#create a admit% col from the admitRate col
colleges <- mutate(colleges, admissionPct = 100 * admissionRate)

#multiple columns can be added at once too; comma separated
colleges <- mutate(colleges, FYretentionPct = 100 * FYretention,
                   gradPct = 100 * gradRate)



### Summarize Rows

#squash values of many rows into 1 using the summarize func
#create a new col (called medianCost) by calling a function on every val of a column 
summarize(colleges, medianCost = median(cost, na.rm = TRUE))

# multiple cols can be added to the single produced row
summarize(colleges, 
          min = min(cost, na.rm = TRUE), 
          Q1 = quantile(cost, .25, na.rm = TRUE), 
          median = median(cost, na.rm = TRUE), 
          Q3 = quantile(cost, .75, na.rm = TRUE), 
          max = max(cost, na.rm = TRUE))

########## QUESTION 5 ###########
# what happens if there is no na.rm = TRUE?
summarize(colleges, medianCost = median(cost, na.rm = FALSE))
#ouput: NA
# We get NA because one of the values in the column was NA, so a numerical operation
# could not be performed on it, messing up the summarization of the column. Since R 
# doesn't know what to do with an NA value, it just returns NA as the output.



### Groupwise manipulation

# When we print the data frame it tells us the variables that define the groups and how many 
# groups are in the data frame. This provides sanity checks, so be sure to pay attention to 
# if this matches your expectation! For example, if there were any typos in the column or if 
# just one value is capitalized (such as Public) we would be told there are more than two groups.
colleges_by_type <- group_by(colleges, type)
# more than 1 var can be specified with comma sep

# groups can be combined with other commands as well;
#five number summary of cost by institution type is obtained below
summarize(colleges_by_type, 
          min = min(cost, na.rm = TRUE), 
          Q1 = quantile(cost, .25, na.rm = TRUE), 
          median = median(cost, na.rm = TRUE), 
          Q3 = quantile(cost, .75, na.rm = TRUE), 
          max = max(cost, na.rm = TRUE))

# We can also calculate new variables within groups, 
#such as the standardized cost of attendance within each state
colleges_by_state <- group_by(colleges, state)
colleges_by_state <- mutate(colleges_by_state, 
                            mean.cost = mean(cost, na.rm = TRUE), 
                            sd.cost = sd(cost, na.rm = TRUE),
                            std.cost = (cost - mean.cost) / sd.cost)





