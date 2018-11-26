#Liam Niehus-Staab
#Relational Data Lab
#10/10/18

library(ggplot2)
library(dplyr)
library(tidyr)
library(dbplyr)
library(RSQLite)
#requires install of dbplyer and RSQLite packages

### On Your Own

# The **payroll_postseason** data table created above contains the variables `WCWin` 
#and `DivWin` which indicate whether a team won a wild card or divisional playoff
#game (`Y`) or not (`N`). 
# a. Use the `mutate` function in the `dplyr` package to fill in `N`s for the blanks
#in the `WCWin` and `DivWin` columns. (*Note*: If a team did not reach the playoffs, 
#then its entry for `WCWin` and `DivWin` will be blank.)
payroll_postseason$DivWin = sub("^$", "N", payroll_postseason$DivWin)
payroll_postseason$WCWin = sub("^$", "N", payroll_postseason$WCWin)

# b. Create a dotplot of payroll by year, highlighting teams that won the wild card
#round. Briefly summarize your findings.
ggplot(data = payroll_postseason, mapping = aes(x = yearID, y = adj.payroll/1000000, color = WCWin)) +
  geom_point(data = filter(payroll_postseason, WCWin == "N")) + 
  geom_point(data = filter(payroll_postseason, WCWin == "Y")) + 
  labs(title = "Wild card round win", x = "Year", y = "Payroll(mils)") + 
  scale_color_manual("Wild Card Round Win", values = c("gray80", "darkorange"))
# Winning the wild card round appears to have no corelation to payroll, the winners come from a 
# wide spread of variously paid teams.

# c. Create a dotplot of payroll by year, highlighting teams that won their division. 
#Briefly summarize your findings.
ggplot(data = payroll_postseason, mapping = aes(x = yearID, y = adj.payroll/1000000, color = DivWin)) +
  geom_point(data = filter(payroll_postseason, DivWin == "N")) + 
  geom_point(data = filter(payroll_postseason, DivWin == "Y")) + 
  labs(title = "Division win", x = "Year", y = "Payroll(mils)") + 
  scale_color_manual("Div Win", values = c("gray80", "darkorange"))
# Having a division win seems to have a mild positive correlation with payroll. However there
# are also many teams that won their division that had low to average payrolls.

# d. The distribution of payroll values is quite skewed. One way to adjust for this 
#would be to look at a log transformation of team payroll. Remake both graphs from 
#the "Payroll and Wins" section (wins v payroll overall, and wins v payroll faceted 
#by year) using a natural log transform of the payroll values. Do the general trends
#appear the same in the log-transformed data? What features of the data may be easier
#to see in the log scale? What features may be obscured by using logs?
ggplot(data = payroll_teams, aes(x = log(adj.payroll/1e6), y = W)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  labs(x = "log of payroll (millions)", y = "wins")
# Taking the log of payroll really destroys any shape the data had; the points form a 
# blob. While the tred lines appear similar, the shape of the graph really shows that
# there is no correlation between payroll and wins.

#facet by year to see if trend goes across all seasons
ggplot(data = payroll_teams, aes(x = log(adj.payroll/1e6), y = W)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_wrap(~ yearID, ncol = 5) + 
  labs(x = "log of payroll (millions)", y = "wins")
# Faceting by year shows a similar blobiness. The trend lines appear to all be mostly
# flat.  This provides support for the hypothesis that there is no strong correlation.

# Taking the log of the payroll makes it easier to see that there isn't much of a 
# correlation between wins and pay, as the data appears in blobs. However it makes
# it harder to see that the teams that are paid the most by far do tend to win more
# than average. However, that does not mean that a strong trend exists because teams
# that are paid a lot less also have the same amount or more wins.









lahman_db <- src_sqlite("~/Shared/F18MAT295/case-studies-master/baseball-salaries/data/lahman.sqlite", create = TRUE)
inflation <- read.csv("~/Shared/F18MAT295/case-studies-master/baseball-salaries/data/inflation.csv")


### Compare payroll across years 

#select salaries table from the db
slaries_tbl = tbl(lahman_db, "salaries")

#get the salaries and payroll
salaries_grouped <- group_by(salaries_tbl, teamID, yearID)
payroll <- summarize(salaries_grouped, payroll = sum(salary))

#the collect command pulls the db data into R
payroll <- collect(payroll)

#join the payroll and inflation data so we can see how payroll is affected by inflation rates
payroll = left_join(payroll, inflation, by = c("yearID" = "year"))
#mutate data to add inflation adjusted payrool col 
payroll <- mutate(payroll, adj.payroll = payroll * multiplier)

#graph the data with box plot
ggplot(data = payroll, mapping = aes(x = factor(yearID), y = adj.payroll/1e6)) + 
  geom_boxplot() + 
  labs(x = "year", y = "payroll (millions)") + 
  theme(axis.text.x = element_text(angle = 90))


### Compare payroll across leagues

#get team data from the SQL db
teams_tbl <- collect(tbl(lahman_db, "teams"))

#join payroll data with team data
payroll_teams = left_join(payroll, teams_tbl, by = c("teamID", "yearID"))

#compare differences between NL and AL
ggplot(data = payroll_teams) + 
  geom_boxplot(mapping = aes(x = factor(yearID), y = adj.payroll/1e6, fill = lgID), alpha = 0.7) + 
  labs(x = "year", y = "payroll (millions)") +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_fill_manual("league", values = c("darkorange", "deepskyblue"))
# there don't appear to be any differences


### Payroll and wins

#graph data
ggplot(data = payroll_teams, aes(x = adj.payroll/1e6, y = W)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  labs(x = "payroll (millions)", y = "wins")
# there apperas to be a relationship between pay and wins

#facet by year to see if trend goes across all seasons
ggplot(data = payroll_teams, aes(x = adj.payroll/1e6, y = W)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_wrap(~ yearID, ncol = 5) + 
  labs(x = "payroll (millions)", y = "wins")
# it kind of does


### Payroll and the playoffs

#collect postseason data from sql db
postseason <- collect(tbl(lahman_db, "seriespost"))
#narrow the data
postseason <- select(postseason, yearID, teamIDwinner, teamIDloser)

#gather the 'teamIDwinner' and 'teamIDloser' columns into 'teamID' and 'win' cols
postseason = gather(postseason, key = win, value = teamID, teamIDwinner, teamIDloser)

#drop the win col since we are not interested in who won 
postseason <- select(postseason,-win)
#now group by team and year so each team only has 1 entry per season
postseason_grouped <- group_by(postseason, yearID, teamID) 

#summarize the data
playoffs <- summarize(postseason_grouped, playoff = "Y")

#merge the payroll data with the playoff data
payroll_postseason = left_join(payroll_teams, postseason, by = c("teamID", "yearID"))

#mutate to add boolean playoff col var
payroll_postseason <- 
  mutate(payroll_postseason, 
         playoff = ifelse(is.na(playoff), "N", "Y"))

#see if there is correlation between pay and going to the playooffs
ggplot(data = payroll_postseason, aes(x = yearID, y = adj.payroll/1e6, color = playoff)) + 
  geom_point(data = filter(payroll_postseason, playoff == "N")) + 
  geom_point(data = filter(payroll_postseason, playoff == "Y")) + 
  labs(x = "payroll (millions)", y = "wins") + 
  scale_color_manual("Playoff berth?", values = c("gray80", "darkorange"))
# there really isn't


### Payroll and world series
#grpah it 
ggplot(data = payroll_teams, aes(x = yearID, y = adj.payroll/1e6)) + 
  geom_point(aes(color = WSWin)) + 
  labs(x = "season", y = "payroll (millions)")
# not much relation in current day

#fix 1994 data (from player strike) to fill in empty rows with 'N'
payroll_postseason <- mutate(payroll_postseason, WSWin = ifelse(WSWin == "Y", "Y", "N"))

#improve readability
ggplot(data = payroll_postseason, aes(x = yearID, y = adj.payroll/1e6, color = WSWin)) + 
  geom_point(data = filter(payroll_postseason, WSWin == "N")) + 
  geom_point(data = filter(payroll_postseason, WSWin == "Y")) + 
  labs(x = "season", y = "payroll (millions)") + 
  scale_color_manual("World Series\nChampion?", values = c("gray80", "darkorange"))


