---
title: "Lab 9 Homework"
author: "Sudev Namboodiri"
date: "2021-02-14"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Load the libraries

```r
library(tidyverse)
library(janitor)
library(here)
library(naniar)
```

For this homework, we will take a departure from biological data and use data about California colleges. These data are a subset of the national college scorecard (https://collegescorecard.ed.gov/data/). Load the `ca_college_data.csv` as a new object called `colleges`.

```r
colleges <- readr::read_csv('data/ca_college_data.csv')
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   INSTNM = col_character(),
##   CITY = col_character(),
##   STABBR = col_character(),
##   ZIP = col_character(),
##   ADM_RATE = col_double(),
##   SAT_AVG = col_double(),
##   PCIP26 = col_double(),
##   COSTT4_A = col_double(),
##   C150_4_POOLED = col_double(),
##   PFTFTUG1_EF = col_double()
## )
```

The variables are a bit hard to decipher, here is a key:  

INSTNM: Institution name  
CITY: California city  
STABBR: Location state  
ZIP: Zip code  
ADM_RATE: Admission rate  
SAT_AVG: SAT average score  
PCIP26: Percentage of degrees awarded in Biological And Biomedical Sciences  
COSTT4_A: Annual cost of attendance  
C150_4_POOLED: 4-year completion rate  
PFTFTUG1_EF: Percentage of undergraduate students who are first-time, full-time degree/certificate-seeking undergraduate students  
<style>
div.blue { background-color:#e6f0ff; border-radius: 5px; padding: 20px;}
</style>
<div class = "blue">

1. Use your preferred function(s) to have a look at the data and get an idea of its structure. Make sure you summarize NA's and determine whether or not the data are tidy. You may also consider dealing with any naming issues.

```r
colleges 
```

```
## # A tibble: 341 x 10
##    INSTNM CITY  STABBR ZIP   ADM_RATE SAT_AVG PCIP26 COSTT4_A C150_4_POOLED
##    <chr>  <chr> <chr>  <chr>    <dbl>   <dbl>  <dbl>    <dbl>         <dbl>
##  1 Gross~ El C~ CA     9202~       NA      NA 0.0016     7956        NA    
##  2 Colle~ Visa~ CA     9327~       NA      NA 0.0066     8109        NA    
##  3 Colle~ San ~ CA     9440~       NA      NA 0.0038     8278        NA    
##  4 Ventu~ Vent~ CA     9300~       NA      NA 0.0035     8407        NA    
##  5 Oxnar~ Oxna~ CA     9303~       NA      NA 0.0085     8516        NA    
##  6 Moorp~ Moor~ CA     9302~       NA      NA 0.0151     8577        NA    
##  7 Skyli~ San ~ CA     9406~       NA      NA 0          8580         0.233
##  8 Glend~ Glen~ CA     9120~       NA      NA 0.002      9181        NA    
##  9 Citru~ Glen~ CA     9174~       NA      NA 0.0021     9281        NA    
## 10 Fresn~ Fres~ CA     93741       NA      NA 0.0324     9370        NA    
## # ... with 331 more rows, and 1 more variable: PFTFTUG1_EF <dbl>
```




</div>

2. Which cities in California have the highest number of colleges?

```r
colleges %>%
  group_by(CITY) %>%
  summarise( count = n())%>%
  arrange(desc(count))
```

```
## # A tibble: 161 x 2
##    CITY          count
##    <chr>         <int>
##  1 Los Angeles      24
##  2 San Diego        18
##  3 San Francisco    15
##  4 Sacramento       10
##  5 Berkeley          9
##  6 Oakland           9
##  7 Claremont         7
##  8 Pasadena          6
##  9 Fresno            5
## 10 Irvine            5
## # ... with 151 more rows
```

3. Based on your answer to #2, make a plot that shows the number of colleges in the top 10 cities.

```r
top_10 <- colleges %>%
  group_by(CITY) %>%
  summarise( count = n())%>%
  arrange(desc(count)) %>%
  head(10)

top_10 %>%
  ggplot(aes(x = CITY, y = count)) + geom_col()
```

![](lab9_hw_files/figure-html/unnamed-chunk-7-1.png)<!-- -->
<style>
div.blue { background-color:#e6f0ff; border-radius: 5px; padding: 20px;}
</style>
<div class = "blue">

4. The column `COSTT4_A` is the annual cost of each institution. Which city has the highest average cost? Where is it located?

```r
colleges %>%
  group_by(CITY) %>%
  summarise(avg_cost = mean(COSTT4_A, na.rm = T))
```

```
## # A tibble: 161 x 2
##    CITY        avg_cost
##  * <chr>          <dbl>
##  1 Alameda        12038
##  2 Anaheim        16877
##  3 Angwin         41700
##  4 Aptos          14686
##  5 Arcata         23139
##  6 Atherton       56035
##  7 Azusa          48284
##  8 Bakersfield    15327
##  9 Barstow        14789
## 10 Belmont        50415
## # ... with 151 more rows
```
</div>

5. Based on your answer to #4, make a plot that compares the cost of the individual colleges in the most expensive city. Bonus! Add UC Davis here to see how it compares :>).

```r
expensive_city <- colleges %>%
  group_by(CITY) %>%
  summarise(avg_cost = mean(COSTT4_A, na.rm = T)) %>%
  arrange(desc(avg_cost)) %>%
  head(1)

expensive_city <- expensive_city$CITY[1]

colleges %>%
  filter(CITY == expensive_city)%>%

  ggplot(aes(x = INSTNM, y = COSTT4_A)) + geom_col()
```

```
## Warning: Removed 2 rows containing missing values (position_stack).
```

![](lab9_hw_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

6. The column `ADM_RATE` is the admissions rate by college and `C150_4_POOLED` is the four-year completion rate. Use a scatterplot to show the relationship between these two variables. What do you think this means?

```r
colleges %>%
  select(ADM_RATE,C150_4_POOLED) %>%
  ggplot(aes(x = ADM_RATE, y = C150_4_POOLED)) + geom_point()
```

```
## Warning: Removed 251 rows containing missing values (geom_point).
```

![](lab9_hw_files/figure-html/unnamed-chunk-10-1.png)<!-- -->



This means that colleges that have a higher admission rate have a lower four year completion rate

7. Is there a relationship between cost and four-year completion rate? (You don't need to do the stats, just produce a plot). What do you think this means?

```r
colleges %>%
  select(COSTT4_A,C150_4_POOLED) %>%
  ggplot(aes(x = COSTT4_A, y = C150_4_POOLED)) + geom_point()
```

```
## Warning: Removed 225 rows containing missing values (geom_point).
```

![](lab9_hw_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

There is a postiive correlation between cost of attendance and four year completion rate. This is more likely because private colleges are better funded and more expensive, and many top colleges are private with high completion rates, whereas state schools are generally cheaper.

8. The column titled `INSTNM` is the institution name. We are only interested in the University of California colleges. Make a new data frame that is restricted to UC institutions. You can remove `Hastings College of Law` and `UC San Francisco` as we are only interested in undergraduate institutions.

```r
UC <- colleges %>%
  filter_all(any_vars(str_detect(., pattern = "University of California"))) 
```

Remove `Hastings College of Law` and `UC San Francisco` and store the final data frame as a new object `univ_calif_final`.

```r
univ_calif_final <- UC %>%
  filter(!is.na(C150_4_POOLED)) #graduate institutions don't have four year completion rate on file
```

Use `separate()` to separate institution name into two new columns "UNIV" and "CAMPUS".

```r
univ_calif_final <- univ_calif_final %>%
  separate(INSTNM, c("UNIV", "CAMPUS"), sep = "-")
univ_calif_final
```

```
## # A tibble: 8 x 11
##   UNIV  CAMPUS CITY  STABBR ZIP   ADM_RATE SAT_AVG PCIP26 COSTT4_A C150_4_POOLED
##   <chr> <chr>  <chr> <chr>  <chr>    <dbl>   <dbl>  <dbl>    <dbl>         <dbl>
## 1 Univ~ San D~ La J~ CA     92093    0.357    1324  0.216    31043         0.872
## 2 Univ~ Irvine Irvi~ CA     92697    0.406    1206  0.107    31198         0.876
## 3 Univ~ River~ Rive~ CA     92521    0.663    1078  0.149    31494         0.73 
## 4 Univ~ Los A~ Los ~ CA     9009~    0.180    1334  0.155    33078         0.911
## 5 Univ~ Davis  Davis CA     9561~    0.423    1218  0.198    33904         0.850
## 6 Univ~ Santa~ Sant~ CA     9506~    0.578    1201  0.193    34608         0.776
## 7 Univ~ Berke~ Berk~ CA     94720    0.169    1422  0.105    34924         0.916
## 8 Univ~ Santa~ Sant~ CA     93106    0.358    1281  0.108    34998         0.816
## # ... with 1 more variable: PFTFTUG1_EF <dbl>
```

9. The column `ADM_RATE` is the admissions rate by campus. Which UC has the lowest and highest admissions rates? Produce a numerical summary and an appropriate plot.

```r
univ_calif_final %>%
  select(CAMPUS, ADM_RATE) %>%
  ggplot(aes(x=CAMPUS, y = ADM_RATE)) + geom_col()
```

![](lab9_hw_files/figure-html/unnamed-chunk-15-1.png)<!-- -->


```r
univ_calif_final %>%
  summarise(CAMPUS, "admission rate" = ADM_RATE) %>%
  arrange(`admission rate`)
```

```
## # A tibble: 8 x 2
##   CAMPUS        `admission rate`
##   <chr>                    <dbl>
## 1 Berkeley                 0.169
## 2 Los Angeles              0.180
## 3 San Diego                0.357
## 4 Santa Barbara            0.358
## 5 Irvine                   0.406
## 6 Davis                    0.423
## 7 Santa Cruz               0.578
## 8 Riverside                0.663
```

10. If you wanted to get a degree in biological or biomedical sciences, which campus confers the majority of these degrees? Produce a numerical summary and an appropriate plot.

```r
univ_calif_final %>%
  select(CAMPUS, PCIP26) %>%
  ggplot(aes(x=CAMPUS, y = PCIP26)) + geom_col()
```

![](lab9_hw_files/figure-html/unnamed-chunk-17-1.png)<!-- -->


```r
univ_calif_final %>%
  summarise(CAMPUS, "Percent of degrees awarded in the biomedical sciences" = PCIP26) %>%
  arrange(desc(`Percent of degrees awarded in the biomedical sciences`))
```

```
## # A tibble: 8 x 2
##   CAMPUS        `Percent of degrees awarded in the biomedical sciences`
##   <chr>                                                           <dbl>
## 1 San Diego                                                       0.216
## 2 Davis                                                           0.198
## 3 Santa Cruz                                                      0.193
## 4 Los Angeles                                                     0.155
## 5 Riverside                                                       0.149
## 6 Santa Barbara                                                   0.108
## 7 Irvine                                                          0.107
## 8 Berkeley                                                        0.105
```

## Knit Your Output and Post to [GitHub](https://github.com/FRS417-DataScienceBiologists)
