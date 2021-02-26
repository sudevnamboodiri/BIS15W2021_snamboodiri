library(shiny)

readr::read_csv(homerange)

ui <- fluidPage(    
  
  titlePanel("Log 10 Homerange by Locomotion"), # give the page a title
  
  # generate a row with a sidebar
  sidebarLayout(      
    
    # define the sidebar with one input
    sidebarPanel(
      selectInput("Locomotion", " Select Locomotion of Interest:", 
                  choices=unique(homerange$locomotion)),
      hr(),
      helpText("Reference: Tamburello N, Cote IM, Dulvy NK (2015) Energy and the scaling of animal space use. The American Naturalist 186(2):196-211.")
    ),
    
    # create a spot for the barplot
    mainPanel(
      plotOutput("LocomotionPlot")  
    )
    
  )
)

# define a server for the Shiny app
server <- function(input, output) {
  
  # fill in the spot we created for a plot
  output$LocomotionPlot <- renderPlot({
    
    homerange %>% 
      filter(locomotion == input$locomotion) %>% 
      ggplot(aes(x=log10.hra)) + 
      geom_density(color="black", fill="steelblue", alpha=0.6)
  })
}

shinyApp(ui, server)

