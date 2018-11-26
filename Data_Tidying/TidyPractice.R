#tidy data practice

### 1. Definition of a tidy data set

# 
# In R, it is easiest to work with data that follow five basic rules:
#   
# 1. Every **variable** is stored in its own **column**.
# 2. Every observation is stored in its own **row**---that is, every row corresponds to a single **case**.
# 3. Each **value** of a variable is stored in a **cell** of the table.
# 4. Values should not contain units. Rather, units should be specified in the supporting documentation for the data set, often called a *codebook*.
# 5. There should be no extraneous information (footnotes, table titles, etc.).
# 
# A data set satisfying these rules is said to be **tidy**, a term popularized by Hadley Wickham.
# 

#load libs
library(tidyr)   # contains tools to tidy data
library(ggplot2) # for plotting

# add data files
UBSprices <- read.csv("~/Shared/F18MAT295/r-tutorials-master/tidying-data/data/UBSprices.csv", as.is = TRUE)
polls <- read.csv("~/Shared/F18MAT295/r-tutorials-master/tidying-data/data/rcp-polls.csv", na.strings = "--", as.is = TRUE)
airlines <- read.csv("~/Shared/F18MAT295/r-tutorials-master/tidying-data/data/airline-safety.csv", as.is = TRUE)

### UBS DATA ###

#gather the columns on year(and product) and put into its own column, year, with the proper values corresponding in rows 
tidy_ubs <- gather(data = UBSprices, key = year, value = price, rice2003, rice2009) 

# separate prodcut from year by extracting the number value of the year from data
tidy_ubs$year <- extract_numeric(tidy_ubs$year)


### POLLS ###

# separate poll dates into begining and end
tidy_polls <- separate(data = polls, col = Date, into = c("Begin", "End"), sep = " - ")

# separate the sample col data into size and population
tidy_polls <- separate(data = tidy_polls, col = Sample, into = c("size", "population"), sep = " ")

# gather last 4 cols into a candidate col that is paired with the percent they got 
tidy_polls <- gather(data = tidy_polls, key = candidate, value = percentage, 7:10)

# separate candidate names form their political party into 2 cols
tidy_polls <- separate(tidy_polls, candidate, into= c("candidate", "party"))


### AIRLINES ###

# gather the last 5 cols into 2 cols; accidensts and count
tidy_airlines <- gather(airlines, key = accidents, value = count, 3:8)
head(tidy_airlines)

# separate the accitendts col into the var and years cols, using \. char as seperator
tidy_airlines <- separate(tidy_airlines, accidents, into = c("var", "years"), sep = "[.]")

#
tidy_airlines <- spread(data = tidy_airlines, key = var, value = count)

#separate the year col into a begin and end cols for dates
tidy_airlines <- separate(tidy_airlines, years, c("Begin", "End"), sep="_")




#visualize tidy data
head(UBSprices)
head(polls)
head(airlines)
