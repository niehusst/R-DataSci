#Liam Niehus-Staab
#text mining
#10/28/2018

require(stringi, quietly = TRUE,warn.conflicts = FALSE)
# install.packages("knitr")
require(knitr, quietly = TRUE, warn.conflicts = FALSE)
require(ggplot2, quietly = TRUE, warn.conflicts = FALSE) #for qplots

#read in blogs, twitter and news
Twitter1 <- readLines("~/Shared/F18MAT295/en_US.twitter.txt",encoding = "UTF-8", skipNul = TRUE, warn = FALSE)


#On my own questions
# 1. Are strings involving the words "love" longer or shorter than strings with the word "hate"?
#Strings with love appear to be a little be shorter on average.

# * How many rows contain the word hate (include upper and lower case letters)?
hate <- sum(grepl("[Hh][Aa][Tt][Ee]", Twitter1))

# * Give a 5 number summary for the number of characters in texts that include the word hate.
hate2 = grep("[Hh][Aa][Tt][Ee]", Twitter1)
hateTwit = Twitter1[hate2]
summary(nchar(hateTwit))

# * Give a 5 number summary for the number of characters in texts that include the word love.
love2 = grep("[Ll][Oo][Vv][Ee]", Twitter1)
loveTwit = Twitter1[love2]
summary(nchar(loveTwit))

# * Create bar charts for both text files.
TwL = stri_count_words(loveTwit) 
qplot(TwL, binwidth = 5, main = "Number of words in each line containing 'love'")
TwH = stri_count_words(hateTwit) 
qplot(TwH, binwidth = 5, main = "Number of words in each line containing 'hate'")



# text file data can be hard to visualize/analyze because it's not a dataframe
# To view the first 3 lines
head(Twitter1, 3)
# The number of lines
length(Twitter1)            
# The length of the longest line
max(nchar(Twitter1))        
# 5 number summary of line characters
summary(nchar(Twitter1))


# using the stringi package to calculate summary data (number of lines and chars)
Tw1 <- stri_stats_general(Twitter1)
data1 <- data.frame(Tw1)

#using the knitr package to make a well formatted (in RMD) summary table
kable(data1, caption = "Summary Table of the Blogs, Twitter, and News documents")

#This stringi function counts the number of words on each line in the Twitter document. 
Tw2 = stri_count_words(Twitter1) 
summary(Tw2)
qplot(Tw2, binwidth = 5, main = "Number of words in each line in the Twitter document")

# use regex to find certain str patterns
# Search for a particular word or phrase in a document (regular grep returns vecotr of posiitons/lines)
love <- sum(grepl("love", Twitter1))
love
# R is case sensitive, to include capitol letters we list both options [], see the "Regular Expressions" document for more options.
love <- sum(grepl("[Ll][Oo][Vv][Ee]", Twitter1)) #grepl is logic grep, T/F for each lin
love

# To find the line of text that contains the word biostats
biostats <- grep("biostats", Twitter1)
biostats  ### [1] 556,872
# To print the line that contains the word biostats
Twitter1[biostats]

phrase1 <- grep("A computer once beat me at chess, but it was no match for me at", Twitter1)
phrase1
#Print the first four lines that contain phrase1
head(Twitter1[phrase1],4)
