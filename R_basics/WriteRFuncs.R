#Liam Niehus-Staab
#Writing R Funcs
#9/9/18

#func to find mean of input params (with 'a' counted twice for some reason)
MyMean <- function(a,b,c,d) {
  temp = (2*a + b + c + d)/5
  return(temp)  
}

############ QUESTION 1 ###############
#works as expected; output 1
MyMean(1,1,1,1)

#works as expected: output 2
MyMean(1,2,3,3)

#error: there is no argument for the last param and there's no default
MyMean(1,2,3)

#error: too many arguments
MyMean(1,2,3,3,2)

#worksish; R actually runs the function once for each value in the vector as the parameter.
#output: 1.0 1.4 1.8
x = c(1,2,3)
MyMean(x,1,1,1)


### QUIZ PERCENTAGE COUNTING CODE ###
# Create a vector of 10 randomly generated quiz scores
quizScores = ceiling(runif(10, 0, 10))

# Create a histogram of the quiz scores w/ 11 breaks for the different possible grades
mybreaks = c(0,1,2,3,4,5,6,7,8,9,10)
hist(quizScores, breaks = mybreaks)

# This function counts the number of A's and number of B's in the Class
QuizGrades <- function(quizScores, val=9) { # x shoudl be a vector
  n <- length(quizScores)
  tempB <- quizScores ==8 # counts number of grades w/ a B
  tempA <- quizScores >= val # counts number of grasdes with a A

  B <- sum(as.numeric(tempB)) #converets bool to int (TRUE == 1, FALSE == 0)
  A <- sum(as.numeric(tempA))
  results <- c(B, A)
  names(results) <- c("B grades","A grades") # name table col headers
  return(results)
}


# ############ QUESTION 2 ###############
# The runif(x,y,z) function is actually a uniform distribution funciton, randoming getting
# x numbers in the range of y < _ < z. 
# 
# ############ QUESTION 3 ###############
# The ceiling function will round up any decimal value number to the next integer value.
# 
# ############ QUESTION 4 ###############
# The hist function creates a histogram of the input vector of values, counting the frequency of 
# each value in the vector. 
# The break argument is used to specify how many bars to place, and for what range of values each bar
# represents. The mybreaks variable sets 10 bars of width 1.

############ QUESTION 5 ###############

#calculate and neatly output the percentage of As, Bs, Cs, Ds, and Fs for a vector
#of any size that contains these 10 point quiz scores.
newQuizGrades <- function(quizScores) { 
  n = length(quizScores)
  Fs <- (sum(as.numeric(quizScores <= 5)) / n) * 100
  Ds <- (sum(as.numeric(quizScores == 6)) / n) * 100
  Cs <- (sum(as.numeric(quizScores == 7)) / n) * 100
  Bs <- (sum(as.numeric(quizScores == 8)) / n) * 100
  As <- (sum(as.numeric(quizScores >= 9)) / n) * 100
  results <- c(Fs, Ds, Cs, Bs, As)
  names(results) <- c("F grades","D grades","C grades","B grades","A grades") 
  return(results)
}


############ QUESTION 6 ###############

getMean = function(data) {
  return(sum(data) / length(data))
}

getSTD = function(data, mean) {
  SUM = 0
  for (x in data) {
    SUM = SUM + (x - mean)^2
  }
  
  return( (SUM / length(data))^0.5 )
}

# assuming 0 for the population mean, mu
testStat = function(data, mean, std) {
  return( mean / (std / length(data)^0.5) )
}

pVal.TwoSided = function(data, tStat) {
  #multiply by 2 because 2 tailed
  return( 2 * pt(q = tStat, df = length(data)-1, lower.tail = FALSE) )
}

getT.TestStatistics = function(data) {
 m = getMean(data)
 s = getSTD(data, m)
 t = testStat(data, m, s)
 p = pVal.TwoSided(data, t)
 ret = c(m, s, t, p)
 names(ret) = c("Mean", "Std Dev", "T Stat", "P Value")
 return(ret)
}
