#Liam Niehus-Staab
#Tidy Data Lab
#9/5/18

# Import the csv data
under5mortality <- read_csv("/data/home/Shared/F18MAT295/r-tutorials-master/tidying-data/data/under5mortality.csv")
MLB2016 <- read_csv("/data/home/Shared/F18MAT295/r-tutorials-master/tidying-data/data/mlb2016.csv")
UBSprices2 <- read_csv("/data/home/Shared/F18MAT295/r-tutorials-master/tidying-data/data/UBSprices2.csv")

########### QUESTIONS AND ANSWERS ##############
# 1. Explain why the 538 data is clean?
# Firstly, the data ISNT clean because it contains extranious information; the Show column and the Year column share information, 
# as each contain the year in which the episode of the daily show aired. However, other than that, the data is cleanly organized
# with each episode observation stored in its own row and each variable stored in its own column. By definition, tidy data.
# 
# 
# 2a. Briefly describe why the child mortality data is not considered to be tidy data and what changes need to be made to tidy it.
# The under5mortality data is untidy because the columns are all labeled with individual years, Falsely implying that the country is a
# different variable each year. Instead, there should 1 column called years that contains all that data in a pair value relationship
# with each country and the child mortality rate for that year. Also, the country name column isnt labeled correctly, so its column head
# should be renamed to better fit the data it contains.
# 
# 2b. Use `gather` to create a tidy data set with columns `country`, `year` and `mortality`. 
#     Use `extract_numeric` to ensure that the `year` column is numeric.
#  u5m, put all data from years into 1 col w/ key value pair
u5mTidy = gather(data = under5mortality, key = year, value = mortality, 2:ncol(under5mortality))
u5mTidy$year = extract_numeric(u5mTidy$year)
#rename country column
colnames(u5mTidy)[1] = "country"
# 
# 
# 3a. Briefly describe why the MLB 2016 data is not considered to be tidy data and what changes need to be made to tidy it.
# The data is very nearly tidy, however, the years colum should be Begin and End columns, each cell containing a single number 
# instead of a range of years. Also, the columns that have dollar sign values should be extracted to only numeric values.
# 
# 3b. Use `separate` and `extract_numeric` to tidy this data set.
# mlb, separate the years colum data into years played and range fo years
mlbTidy = separate(data = MLB2016, col = Years, into = c("YearsPlayed", "Range"), sep = " ")
#clean up dollar signs and commas from salaries etc
mlbTidy$Salary = extract_numeric(mlbTidy$Salary)
mlbTidy$Total.Value = extract_numeric(mlbTidy$Total.Value)
mlbTidy$Avg.Annual = extract_numeric(mlbTidy$Avg.Annual)
#ideally, the range column would be split into a Begin and End column containing a year, but idk how to prepend a value
# 
# 
# 4a. Briefly describe why UBSprices2 data is not considered to be tidy data and what changes need to be made to tidy it.
# The product and year are combined in the column headers and the values in each column are unexplained by those headers.
# Header names aught to be separated into a year column and a product column, with previous column values being put into a price column.
# 
# 4b. Use `gather` and `separate` to tidy this data set. 
# ubs, gather data into a years column pair valued with a price column
ubsTidy = gather(data = UBSprices2, key = years, value = price, 2:ncol(UBSprices2))
#sep the combined year and and product colum into unique columnn, separating on the 4th char from the right
ubsTidy = separate(data = ubsTidy, col = years, into = c("year", "product"), sep = -5)

