#Liam Niehus-Staab
#CART lab
#11/19/18

library(ggplot2)
library(tree)  
library(dplyr)
library(mosaic)


ggplot(data = iris, aes(x = Sepal.Width, y = Sepal.Length)) + geom_point()  + aes(colour = Species) + labs(title = "Figure 1: Scatterplot of Iris Data")

### QUESTIONS ###
# 1) There are four explanatory variables in this model. Modify Figure 1 by choosing the two
# explanatory variables that creates the most distinct species groups. In other words, we 
# want each species of iris in its own cluster. 
ggplot(data = iris, aes(x = Petal.Width, y = Petal.Length)) + 
  geom_point()  + aes(colour = Species) + labs(title = "Figure 1.5: Scatterplot of Iris Data")

# 2) Create a new scatterplot with Petal.Width on the x-axis and Sepal.Width on the y-axis.
# Draw two verticle lines on this scatterplot. These lines will break up the predictor space
# into three regions. Ideally each region will contain only one species of iris. 
ggplot(data = iris, aes(x = Petal.Width, y = Sepal.Length)) + 
  geom_point()  + aes(colour = Species) + labs(title = "Figure 2: Scatterplot of Iris Data") + geom_vline(xintercept = 0.75)  + geom_vline(xintercept = 1.75)

# 3) Based upon the vertical lines created in Question 2, write mathematical rules to 
# identify the three regions. For example, when x is between 0 and 4, we are in setosa 
# region, when x is between 4 and 5 we are in versicolor region. These are called spliting
# rules and will be used to identify regions corresponding to specific species within our
# decision tree.
# 0 < x < .75    setosa
# .75 < x < 1.75 versicolor
# 1.75 < x < 2.6 verginica

# 4) Using the treeall model, if petal width = 1.5 and petal length = 5. what would you classify the species to be?
#virginica

#5) View the tree1table data frame. How many misclassifications were there? Using tree1, which species was the most difficult to accurately predict?
#There were 6 miscalculations: 1 versicolor was predicted to be a virginica and 5 virginica were predicted to be versicolor.

# 6) Based upon the summary table, what is the misclassification rate? 
#8%

# 7) How many rows are in the `iris[-train]` dataset?
#150

# 8) Why does changing the seed create different misclassification rates?
# The seed determines the random number generation order that is used in training the tree. As such, 
# the tree will be trained (and thus constructed) differently for each different random number seed.
# Obviously different trees will not always have the same misclassification rates. 



### recursive binary splitting of tree
#To construct a tree diagram, we divide the predictor space into n distinct, 
#non-overlapping regions. Then, every observation within that region is given the same *predicted* value.
tree1 <- tree(Species~Petal.Width,data=iris)
tree1
plot(tree1)
text(tree1)
summary(tree1)

#to visualize the tree:
tree2 <- tree(Species~Petal.Width + Sepal.Width,data=iris) #plot with just 2 variables
plot(tree2)
text(tree2)
treeall <- tree(Species~.,data=iris) #plot with all 4 vars
plot(treeall)
text(treeall)


### find accuracy of tree
predict(tree1) #show liklihood of values predicted by tree to be correct 
# Round only works since successful predictions are greater than 50%
predict1 <- round(predict(tree1))  # converts predictions into 1 or 0
# Create a new table showing predicted categories:
predict1 <- as.data.frame(predict1)
tree1table <- c(iris, predict1)

# Create a summary table (called a confusion matrix)
tree.pred <- predict(tree1, iris , type = "class") #output is the class instead of the probability
with(iris, table(tree.pred, iris$Species)) #create table


### training and testing data
#To pretect against overfitting, researchers typically create a model with 50% - 80% of their original data. 
set.seed(123)
train <- sample(1:nrow(iris), 100)
tree.iris <- tree(Species~., iris, subset=train)
plot(tree.iris)
text(tree.iris, pretty = 0)
tree.pred <- predict(tree.iris, iris[-train,], type = "class")
with (iris[-train,], table(tree.pred, Species))

#trees can sometimes get out of hand with the number of nodes they have (many of them being unnecessary to predicting the outcome)
#this can be ammended by pruning the tree to have the fewest nodes that have the best prediction rates
cv.iris <- cv.tree(tree.iris, FUN=prune.misclass) #get number of leaf nodes in tree
cv.iris
plot(cv.iris) #visualize the number of nodes that has best performance
prune.iris <- prune.misclass(tree.iris, best = 3) #prune tree to that number of nodes
plot(prune.iris)
text(prune.iris)
#evaluate pruned model to make sure it doesn't perform differently
tree.pred <- predict(prune.iris, iris[-train,], type = "class")
with (iris[-train,], table(tree.pred, Species))

### NOTE:
#to create trees of categorical variables, you must use the as.Factor method in the tree command:
#catTree = tree(as.Factor(responseVar) ~ predictionVars, data, subset=trainingData)
