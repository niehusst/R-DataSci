#Liam Niehus-Staab
#Data Merge Lab
#10/8/18


library(dplyr)

#get csv files
orders <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/orders.csv", as.is = TRUE)
customers <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/customers.csv", as.is = TRUE)

#### On My Own Questions ####
#1. Read the three files into R, naming them **books**, **authors**, and 
#**book_authors**.
books <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/books.csv", as.is = TRUE)
authors <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/authors.csv", as.is = TRUE)
book_authors <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/book-authors.csv", as.is = TRUE)

#2. Use the appropriate `join` statement to add the ISBNs to the **authors** 
#data table. Why does the resulting data frame have 31 rows instead of 11?
isbn = left_join(authors, book_authors, by=c("authorid" = "authorID"))
#since there are 5 cases of George Martin rows in each dataset, each row in the left
#matches with each each row on the right 5 times. This causes George Martin to have
#25 rows, whereas the other authors only match once. So they only get 1 row. 

#3. To eliminate the duplicate rows of your data frame from #6 (which we'll assume 
#you named **df2**) run the following code (change the object names to align with 
#your code as necessary):    
isbn = unique(isbn)

#4. Use the appropriate `join` statement to add the author information table from #3 
#to the **books** data table. 
books = left_join(books,isbn, by = "ISBN")

#5. Are there any authors in the **authors** data table that do not correspond to 
#books in the **books** data table? Use an appropriate join statement to determine
#the answer.
sum(row(anti_join(books, authors)))
#0
# So there are no authors that appear in "authors" that arent in "books"

#6. After reading *A Game of Thrones* the student decides to read the rest of the
#series over the summer. `books2.csv` contains the updated books on the student's 
#reading list. Read this file into R, naming it **books2**.
books2 <- read.csv("~/Shared/F18MAT295/r-tutorials-master/merging/data/books2.csv", as.is = TRUE)

#7. Use the same join statement that you did in #4, but using **books2** rather 
#than **books**.
books2 = left_join(books2,isbn, by = "ISBN")



#### TYPES OF MERGING ####
#### inner_join
#joins together rows with specified "by" var that appear in both datasets
#columns for both datasets are joined (gets only complete data merge)
inner_join(orders, customers, by = "id")

#### left_join
#joins all data from left (preserving unmatched left values) with matching data from
#the right. unmatched left data is filled in with NA 
left_join(orders, customers, by = "id")

#### right_join
#joins all data from right (preserving unmatched right values) with matching data from
#the left. unmatched right data is filled in with NA 
right_join(orders, customers, by = "id")

#### full_join
#joins all rows and columns. preserves all data, filling empthy spots wiht NA
full_join(x = orders, y = customers, by = "id")

#### semi_join
#joins all rows from the left data with matching right data. Preserves only the
#columns from left. (only cuts data that doesn't appear in the right dataset)
semi_join(x = orders, y = customers, by = "id")

#### anti_join
#joins all rows from the left data where there are no matching values in right.
#keeps only the columns from left data
anti_join(x = orders, y = customers, by = "id")


#### MULTI VAR MERGING ####
# * If you want to join by multiple variables, then you need to specify a vector of 
#variable names: `by = c("var1", "var2", "var3")`. Here all three columns must match
#in both tables.

# * If you want to use all variables that appear in both tables, then you can leave 
#the `by` argument blank.

# * If the variable you wish to join by is not named identically in both tables,
#then you specify `by = c("left_var" = "right_var")`.
