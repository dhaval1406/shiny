library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Keyword Transition Ratio"),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
        dateRangeInput(inputId = "dateRange",  
                   label = "Date range", 
                   start = "2013-07-15",
                   separator = "-",
                   min = "2013-07-15",
                   format = "M-dd-yyyy",
                   weekstart = 1,
                   max = Sys.Date()
    ),
    
    selectInput("dataset", "Choose Analysis Type", 
                choices = c("Keyword Transition Ratio", "Keyword WebIds", "Keyword WebId Part Numbers", "Keyword Category", "Keyword Results-set Category")),

    selectInput("dataset", "Choose Keyword to Analyse", 
                choices = unique(analytics[total_search >20]$Q)),
    
    radioButtons(inputId = "outputType",
                 label = "Analysis Type",
                 choices = list("Monthly" = "monthly",
                                "Weekly" = "weekly")),
    

    numericInput("obs", "Number of observations to view:", 10)
  ),

  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    h3(textOutput("textDisplay")), 
    verbatimTextOutput("summary"),

    tableOutput("view")
  )
))