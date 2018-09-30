library(shiny)

# Define simple UI for histogram and wordcloud plots 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Weak Signals"),

  fluidRow(
    column(12,tabsetPanel(
                          tabPanel("CATEGORY HISTOGRAM", plotOutput("histPlotCATEGORIES", width = "100%", height = "600px")),
                          tabPanel("CATEGORY WORDCLOUD", plotOutput("wordCloudPlotCATEGORIES", width = "100%", height = "600px") ),
                          tabPanel("STEEPLED", plotOutput("histPlotSTEEPLED", width = "100%", height = "600px"))
                          )
           )
    
          )
  )
  
)
