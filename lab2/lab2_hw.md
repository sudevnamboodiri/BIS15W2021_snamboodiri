---
title: "Lab 2 Homework"
author: "Sudev Namboodiri"
date: "2021-01-11"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---

## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

1. What is a vector in R?  

A vector is like an array, in iterable set of values that can be called. 

2. What is a data matrix in R?  

A set of vectors arranged in a 2D grid. 

3. Below are data collected by three scientists (Jill, Steve, Susan in order) measuring temperatures of eight hot springs. Run this code chunk to create the vectors.  

```r
spring_1 <- c(36.25, 35.40, 35.30)
spring_2 <- c(35.15, 35.35, 33.35)
spring_3 <- c(30.70, 29.65, 29.20)
spring_4 <- c(39.70, 40.05, 38.65)
spring_5 <- c(31.85, 31.40, 29.30)
spring_6 <- c(30.20, 30.65, 29.75)
spring_7 <- c(32.90, 32.50, 32.80)
spring_8 <- c(36.80, 36.45, 33.15)
```

4. Build a data matrix that has the springs as rows and the columns as scientists.  


```r
totSprings <- c(spring_1,spring_2,spring_3,spring_4,spring_5,spring_6,spring_7,spring_8)
springMatrix <- matrix(totSprings,nrow=8)
springMatrix
```

```
##       [,1]  [,2]  [,3]
## [1,] 36.25 29.20 30.65
## [2,] 35.40 39.70 29.75
## [3,] 35.30 40.05 32.90
## [4,] 35.15 38.65 32.50
## [5,] 35.35 31.85 32.80
## [6,] 33.35 31.40 36.80
## [7,] 30.70 29.30 36.45
## [8,] 29.65 30.20 33.15
```


5. The names of the springs are 1.Bluebell Spring, 2.Opal Spring, 3.Riverside Spring, 4.Too Hot Spring, 5.Mystery Spring, 6.Emerald Spring, 7.Black Spring, 8.Pearl Spring. Name the rows and columns in the data matrix. Start by making two new vectors with the names, then use `colnames()` and `rownames()` to name the columns and rows.


```r
Springnames <- c('Bluebell Spring', 'Opal Spring', 'Riverside Spring', 'Too Hot Spring', 'Mystery Spring', 'Emerald Spring', 'Black Spring', 'Pearl Spring')
ScientistNames = c('Jill', 'Steve', 'Susan')
rownames(springMatrix) <- Springnames
colnames(springMatrix) <- ScientistNames
springMatrix
```

```
##                   Jill Steve Susan
## Bluebell Spring  36.25 29.20 30.65
## Opal Spring      35.40 39.70 29.75
## Riverside Spring 35.30 40.05 32.90
## Too Hot Spring   35.15 38.65 32.50
## Mystery Spring   35.35 31.85 32.80
## Emerald Spring   33.35 31.40 36.80
## Black Spring     30.70 29.30 36.45
## Pearl Spring     29.65 30.20 33.15
```


6. Calculate the mean temperature of all three springs.


```r
Mean_Temperature <- rowMeans(springMatrix)
Mean_Temperature
```

```
##  Bluebell Spring      Opal Spring Riverside Spring   Too Hot Spring 
##         32.03333         34.95000         36.08333         35.43333 
##   Mystery Spring   Emerald Spring     Black Spring     Pearl Spring 
##         33.33333         33.85000         32.15000         31.00000
```


7. Add this as a new column in the data matrix.  


```r
springMatrix <- cbind(springMatrix, 'Mean Temp Per Spring' = Mean_Temperature)
springMatrix
```

```
##                   Jill Steve Susan Mean Temp Per Spring
## Bluebell Spring  36.25 29.20 30.65             32.03333
## Opal Spring      35.40 39.70 29.75             34.95000
## Riverside Spring 35.30 40.05 32.90             36.08333
## Too Hot Spring   35.15 38.65 32.50             35.43333
## Mystery Spring   35.35 31.85 32.80             33.33333
## Emerald Spring   33.35 31.40 36.80             33.85000
## Black Spring     30.70 29.30 36.45             32.15000
## Pearl Spring     29.65 30.20 33.15             31.00000
```
8. Show Susan's value for Opal Spring only.

```r
SusanOpal <- springMatrix["Opal Spring","Susan"]
SusanOpal
```

```
## [1] 29.75
```

9. Calculate the mean for Jill's column only.  


```r
JillMean<- mean(springMatrix[,"Jill"])
JillMean
```

```
## [1] 33.89375
```


10. Use the data matrix to perform one calculation or operation of your interest.


```r
Mean_Temperature_All_Springs = mean(springMatrix[,'Mean Temp Per Spring'])
Mean_Temperature_All_Springs
```

```
## [1] 33.60417
```


## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences.  
