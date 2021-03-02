library(tidyverse)
library(shiny)
library(shinydashboard)
library(naniar)
library(lubridate)
library(here)

if (!require("tidyverse")) install.packages('tidyverse')

UC_admit <- readr:: read_csv(here("lab13","data", "UC_admit.csv"))
UC_admit$`Perc FR` <- as.numeric(sub("%","",UC_admit$`Perc FR`))
UC_admit$Academic_Yr <- as.factor(UC_admit$Academic_Yr)


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