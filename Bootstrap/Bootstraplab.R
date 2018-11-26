#Liam Niehus-Staab
#Bootstrap lab
#11/25/18
library(ggplot2)
library(dplyr)
library(CarletonStats)
tv <- read.csv("/data/home/Shared/F18MAT295/TV.csv")

### 1 SAMPLE BOOTSTRAP ###
# Bootstrapping allows for an approximation of the sampling distribution. To utilize the bootstrap we must assume
# that the sample is representative of the population so that the population can be "recreated" by "pasting together"
# many copies of the original sample*; that is, we must be able to *simulate* the population from the sample. 
#STEPS FOR BOOTSTRAP
# Since we are focusing on only one sample, we use the **one-sample bootstrap procedure**:
#   
# i) Draw a random sample of n observations, with replacement, from the original sample. This creates one bootstrap sample (also known as a resample).
# 
# ii) Calculate the statistic of interest from this bootstrap sample. This statistic is called a bootstrap statistic.
# 
# iii) Repeat steps i. and ii. many times, say 10,000.
# 
# iv) Combine all of the bootstrap statistics to form the bootstrap distribution. 

#now lets do it:
#filter data to only have the basic channels
basic <- filter(tv, Cable == "Basic")
#draw a random sample with replacement
bootstrap_sample1 <- sample_n(basic, size = nrow(basic), replace = TRUE)
bootstrap_sample2 <- sample_n(basic, size = nrow(basic), replace = TRUE)
#howver doing that sampling technique thousands of times is slow an pointless, so we use
#the boot function from Carleton Stats

# THE GOLDEN RULE OF BOOTSTRAPPING
# **The Golden Rule of Bootstrapping: The bootstrap statistics are to the original sample statistic as
# the original sample statistic is to the population parameter.**
# This rule tells us a few important things:
# * If the center of the bootstrap distribution is approximately at the observed statistic, then the sampling distribution 
#   is centered approximately at the parameter.
# 
# * The shape of the bootstrap distribution will resemble the shape of the sampling distribution.
# 
# * The spread of the bootstrap distribution is approximately the same as the spread of the sampling distribution.
# 
# We can calculate a **plug-in bootstrap confidence interval** if the bootstrap distribution is normal;
# by using the standard deviation of the bootstrap distribution to approximate the standard error.

#create a bootstrap distribution for the mean commercial length in half-hour segments on basic channels
boot(basic$Times, B=10000) #makes a plot & gives output

#you can also set the confidence interval level
boot(basic$Times, B=10000, conf.level = .95)
# 	** Bootstrap interval for statistic
# 
#  Observed  basic$Times : 9.21 
#  Mean of bootstrap distribution: 9.21524 
#  Standard error of bootstrap distribution: 0.418 
# 
#  Bootstrap percentile interval
#  2.5% 97.5% 
#  8.38 10.01 
# 
# 		*--------------*

#now do the same steps for extended cable commercial length
extended = filter(tv, Cable == "Extended")
boot(extended$Times, B=10000)



### TWO SAMPLE BOOTSTRAP ###
# The process is a little different for the two-sample bootstrap:
#   
# i) Draw a random sample of $n_{1}$ observations, with replacement, from the original sample for the first group.
# 
# ii) Draw a random sample of $n_{2}$ observations, with replacement, from the original sample for the second group.
# 
# iii) Calculate the statistic of interest from these bootstrap samples (e.g., the difference in means). This statistic is called a bootstrap statistic.
# 
# iv) Repeat steps i–iii many times, say 10,000.
# 
# v) Combine all of the bootstrap statistics to form the bootstrap distribution. 

#beginning the same way as for the 1 sample, this is how finding a random sample wiht replacemnt looks 
grouped_tv <- group_by(tv, Cable) #group tv into 2 groups by Cable category: Basic and Extended
tsboot1 <- sample_frac(grouped_tv, size = 1, replace = TRUE) #apply finctuin to each of tahe groups
#however, this is still slow and inefficient, so we can just use boot to compare the 2 samples

#create a bootstrap distribution for the difference in mean commercial length in half-hour segments on basic channels
boot(Times ~ Cable, data = tv, B = 10000)
#notice how the differce in mean between the 2 groups in Cable is greater than 0. Thus, the same conclusion as earlier
#can be reached more efficiently

# Now that you understand the fundamentals of the one- and two-sample bootstrap procedures you can tackle a wide variety of
# problems. Using the bootstrap you are not restricted to inference for the mean, you can also conduct inference for the
# median, trimmed mean, and many other statistics. Using the `boot` function in the `CarletonStats` package this is done 
# by adding a `fun` argument, which specifies the statistic to be calculated. For example `fun = median` will create a 
# bootstrap distribution for the median, or difference in medians. 
