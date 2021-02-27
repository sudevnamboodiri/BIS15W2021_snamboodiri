---
title: "Lab 13 Homework"
author: "Please Add Your Name Here"
date: "2021-02-26"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---



## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your final lab report should be organized, clean, and run free from errors. Remember, you must remove the `#` for the included code chunks to run. Be sure to add your name to the author header above. For any included plots, make sure they are clearly labeled. You are free to use any plot type that you feel best communicates the results of your analysis.  

Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  

## Libraries

```r
if (!require("tidyverse")) install.packages('tidyverse')
```

```
## Loading required package: tidyverse
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.3     v purrr   0.3.4
## v tibble  3.1.0     v dplyr   1.0.4
## v tidyr   1.1.2     v stringr 1.4.0
## v readr   1.4.0     v forcats 0.5.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


```r
library(tidyverse)
library(shiny)
library(shinydashboard)
library(naniar)
library(lubridate)
```

## Data
The data for this assignment come from the [University of California Information Center](https://www.universityofcalifornia.edu/infocenter). Admissions data were collected for the years 2010-2019 for each UC campus. Admissions are broken down into three categories: applications, admits, and enrollees. The number of individuals in each category are presented by demographic.  

```r
UC_admit <- readr::read_csv("data/UC_admit.csv")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   Campus = col_character(),
##   Academic_Yr = col_double(),
##   Category = col_character(),
##   Ethnicity = col_character(),
##   `Perc FR` = col_character(),
##   FilteredCountFR = col_double()
## )
```

**1. Use the function(s) of your choice to get an idea of the overall structure of the data frame, including its dimensions, column names, variable classes, etc. As part of this, determine if there are NA's and how they are treated.**  

```r
glimpse(UC_admit)
```

```
## Rows: 2,160
## Columns: 6
## $ Campus          <chr> "Davis", "Davis", "Davis", "Davis", "Davis", "Davis", ~
## $ Academic_Yr     <dbl> 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2018, ~
## $ Category        <chr> "Applicants", "Applicants", "Applicants", "Applicants"~
## $ Ethnicity       <chr> "International", "Unknown", "White", "Asian", "Chicano~
## $ `Perc FR`       <chr> "21.16%", "2.51%", "18.39%", "30.76%", "22.44%", "0.35~
## $ FilteredCountFR <dbl> 16522, 1959, 14360, 24024, 17526, 277, 3425, 78093, 15~
```

```r
UC_admit$`Perc FR` <- as.numeric(sub("%","",UC_admit$`Perc FR`))

UC_admit$Academic_Yr <- as.factor(UC_admit$Academic_Yr)

glimpse(UC_admit)
```

```
## Rows: 2,160
## Columns: 6
## $ Campus          <chr> "Davis", "Davis", "Davis", "Davis", "Davis", "Davis", ~
## $ Academic_Yr     <fct> 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2018, ~
## $ Category        <chr> "Applicants", "Applicants", "Applicants", "Applicants"~
## $ Ethnicity       <chr> "International", "Unknown", "White", "Asian", "Chicano~
## $ `Perc FR`       <dbl> 21.16, 2.51, 18.39, 30.76, 22.44, 0.35, 4.39, 100.00, ~
## $ FilteredCountFR <dbl> 16522, 1959, 14360, 24024, 17526, 277, 3425, 78093, 15~
```


**2. The president of UC has asked you to build a shiny app that shows admissions by ethnicity across all UC campuses. Your app should allow users to explore year, campus, and admit category as interactive variables. Use shiny dashboard and try to incorporate the aesthetics you have learned in ggplot to make the app neat and clean.**

```r
ui <- fluidPage(
    selectInput("Year", "Select Academic Year", choices=unique(UC_admit$Academic_Yr)),
    selectInput("Campus", "Select Campus", choices=unique(UC_admit$Campus)),
    selectInput("Category", "Select Category", choices=unique(UC_admit$Category)),
                
  plotOutput("plot", width = "500px", height = "400px")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
  UC_admit %>%
  filter(Academic_Yr== input$Year)%>%
  filter(Campus == input$Campus) %>%
  filter(Category == input$Category) %>%
  ggplot(aes(x = Ethnicity, y = `Perc FR`, fill = `Ethnicity`, label = `Perc FR`)) + geom_col(position = 'dodge') + geom_text(size = 3) + theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.text=element_text(size=12))

  })
  # stop the app when we close it
  session$onSessionEnded(stopApp)
}


shinyApp(ui, server)
```

`<div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div>`{=html}


**3. Make alternate version of your app above by tracking enrollment at a campus over all of the represented years while allowing users to interact with campus, category, and ethnicity.**


```r
ui <- fluidPage(
    selectInput("Ethnicity", "Select Ethnicity", choices=unique(UC_admit$Ethnicity)),
    selectInput("Campus", "Select Campus", choices=unique(UC_admit$Campus)),
    selectInput("Category", "Select Category", choices=unique(UC_admit$Category)),
                
  plotOutput("plot", width = "500px", height = "400px")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
  UC_admit %>%
  filter(Ethnicity== input$Ethnicity)%>%
  filter(Campus == input$Campus) %>%
  filter(Category == input$Category) %>%
  ggplot(aes(x = Academic_Yr, y = `Perc FR`, group = 1)) + geom_point() + geom_line() + theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.text=element_text(size=12))

  })

  # stop the app when we close it
  session$onSessionEnded(stopApp)
}

  


shinyApp(ui, server)
```

`<div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div>`{=html}



## Push your final code to GitHub!
Please be sure that you check the `keep md` file in the knit preferences. 
