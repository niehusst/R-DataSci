#Liam Niehus-Staab
#Intro Strings
#10/29/18

library(stringr) #string library



# On mY oWn ;}

# 1. Create a vector `veggies` containing 
veggies = c("carrot", "bean", "peas", "cabbage", "scallion", "asparagus")

# + Find those strings that contain the pattern "ea".
str_detect(veggies, "ea") 
# + Find those strings that end in "s".
str_detect(veggies, "s$")
# + Find those strings that contain at least two "a"'s.
str_detect(veggies, ".*a.*a")
# + Find those strings that begin with any letter except "c".
str_detect(veggies, "^[^c]")
# + Find the starting and ending position of the pattern "ca" in each string.
str_locate_all(veggies, "ca")
# 2. The regular expression `"^[Ss](.*)(t+)(.+)(t+)"` matches "scuttlebutt", "Stetson", and "Scattter", but not "Scatter." Why?
#it matches either S or s as first char, then any number of any char, then 1 or more t, then 1 or more of any character, then 1 or more t
#It doesn't match "Scatter" because after it matches the first 't' with t+, then the next 't' with .+, and it cant
# match the last t+ because there are only 2 't's in Scatter.



# Lab stuff
fruits <- c("apple", "pineapple", "Pear", "orange", "peach", "banana")

#substring method gets substring. (from 2nd to 4th char)
str_sub(fruits, 2, 4)

str_detect(fruits, "p")  #any occurrence of 'p'?

#get the index of first appearance of a string PATTERN (NA if not there)
str_locate(fruits, "an")

#or use all to get table of all occurences
str_locate_all(fruits,"an")


### REGEX
#all those funcs detect patterns, so they can be given regex expressions too
str_detect(fruits, "^[Pp]")
#'^' means start of string  
#anytihng in [] means or. ([Pp] either P or p is acceptable as first char in stirng)
#'$' means end of a string. (^ and $ are called anchors)
# . is wild card
# * matches 0 or more instances of the preceding char
# + matches 1 or more instances of preceding char
# () are used to seperate matching segments

#here is a phone number extractor
#info set up
a1 <- "Home: 507-645-5489"
a2 <- "Cell: 219.917.9871"
a3 <- "My work phone is 507-202-2332"
a4 <- "I don't have a phone"
info <- c(a1, a2, a3, a4)
#regex
phone <- "([2-9][0-9]{2})[-.]([0-9]{3})[-.]([0-9]{4})" #this detects - or . as seperators because . loses wildcard meaning in []
str_extract(info, phone)

#meta chars have different meaining in []
str_detect(fruits, "^[Pp]")  #starts with 'P' or 'p'
str_detect(fruits, "[^Pp]")  #any character except 'P' or 'p'
str_detect(fruits, "^[^Pp]") #start with any character except 'P' or 'p'
# `[^]]*` matches 0 or more instances of anything but the right bracket

#to escape special characters use double backslash. eg,
# \\.
# \\]
# \\<