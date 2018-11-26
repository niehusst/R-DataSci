#Liam Niehus-Staab
#Data Scraping
#11/12/18

#libs
library(rvest)
library(stringr)
library(dplyr)
library(mosaic)
library(ggplot2)

### TURN IN
baseball = read_html("https://en.wikipedia.org/wiki/Triple_Crown_(baseball)")

#pull out table elements from wiki page
ball = html_nodes(baseball, "table")

#choose pitching table
pitching = html_table(ball, header = TRUE, fill = TRUE)[[3]]

#rename columns
names(pitching)[5:7] = c("EarnedRunAverage", "Wins", "StrikeOuts")

#get rid of asterix in the 3 cols above
pitching$EarnedRunAverage = as.numeric(str_replace_all(pitching$EarnedRunAverage,
                                                       "\\*", ""))
pitching$Wins = as.numeric(str_replace_all(pitching$Wins,
                                                       "\\*", ""))
pitching$StrikeOuts = as.numeric(str_replace_all(pitching$StrikeOuts,
                                                       "\\*", ""))
#remove extra useless refs col
pitching$`Ref(s)` <- NULL

#get batting data
batting = html_table(ball, header = TRUE, fill = TRUE)[[2]]

#delete useless col
batting$`Ref(s)` <- NULL

#rename columns
names(batting)[6:8] = c("HomeRuns", "RunsBattedIn", "BattingAvg")

#get rid of asterix in the 3 cols above
batting$HomeRuns = as.numeric(str_replace_all(batting$HomeRuns,
                                                       "\\*", ""))
batting$RunsBattedIn = as.numeric(str_replace_all(batting$RunsBattedIn,
                                           "\\*", ""))
batting$BattingAvg = as.numeric(str_replace_all(batting$BattingAvg,
                                                 "\\*", ""))
#show tables
head(batting)
head(pitching)

#make plot
ggplot(data = pitching, aes(x = Year, y = Wins)) + 
  geom_point() + stat_smooth(method = lm) + labs(title = "Triple Crown Wins by Year")

# It can be seen that as time has gon one, winners of the pitching tripple crown
# in baseball have had a clearly decreasing ratio of wins. Because having the
# triple crown means that each player lead the league in wins, run average, and
# strike outs, that means that ever single pitcher in the whole league has been
# progressively getting fewer wins to their name as the years go on. This could
# say something about teams being more balanced as time goes on, or it may have
# something to do with there being more pitchers in each team (causing the wins
# to be spread out over a greater number of players) over time. 





###  WIKI EXAMPLE ###
#to scrape html data into a variable, use read_html from rves
popParse <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_population_in_1900")

#extract all tables from the parsed html data
popNodes <- html_nodes(popParse, "table")

#extract just one table from the tables
pop <- html_table(popNodes, header = TRUE, fill = TRUE)[[3]]

#CLEAN THE DATA
pop2 <- pop[-1, ]         #remove row 1

row.names(pop2) <- NULL    #reset row numbers to start at 1

pop2$Rank <- as.numeric(pop2$Rank) #coerce Rank to numeric

names(pop2)[3] <- "Population" #rename 3rd column

pop2$Population <- str_replace_all(pop2$Population, ",", "") #delete ',' in population

#reset Tavolara string, as it contains non-numeric values (59[citation needed])
pop2$Population = str_replace_all(pop2$Population, "\\[[^]]+\\]", "")

#convert population column to ints instead of strings
pop2$Population = as.numeric(pop2$Population)



### MOVIE THEATER EXSAMPLE ###
movieParse = read_html("http://www.boxofficemojo.com/alltime/world/?pagenum=1")

#convert to list of tables
movieTables = html_nodes(movieParse)

#this 3 is important, it selects which table from the html to load (wont necessarily always be 3)
movie = html_table(movieTables, header = TRUE, fill = TRUE)[[3]] 

#clean up column names
names(movie)[5:9] <- c("DomesticDollars", "DomesticPercentage", "OverseasDollars", "OverseasPercentage", "Year")

out <- str_replace_all(movie$Worldwide, "\\$|,", "" ) #replace $ and , chars
movie$Worldwide = as.numeric(out)

#clean out dollar signs from overseas and domestic dollars columns
movie$OverseasDollars = as.numeric(str_replace_all(movie$OverseasDollars, "\\$|,", ""))
movie$DomesticDollars = as.numeric(str_replace_all(movie$DomesticDollars, "\\$|,", ""))

#clean out percentage signs from overseas and dom percent cols
movie$OverseasPercentage = as.numeric(str_replace_all(movie$OverseasDollars, "\\%", ""))
movie$DomesticPercentage = as.numeric(str_replace_all(movie$DomesticDollars, "\\%", ""))

#clean ^ from year
movie$Year = as.numeric(str_replace_all(movie$Year, "\\^", ""))

#you can also get a dataframe of images from the website
moviesImg <- html_nodes(movieParse, "img")


### DETECT HEADERS ###
albumParse <- read_html("http://www.billboard.com/charts/billboard-200")

albumNodes <- html_nodes(albumParse, "h2")

index <- str_detect(albumNodes, "chart-row__song")
index[1:10]

albums <- albumNodes[index]

albums <- str_replace(albums, ".*\">(.+)</h2>", "\\1")








