# Installation

install.packages("shiny")


# Install devtools, if you haven't already.
install.packages("devtools")

library(devtools)
install_github("shinyAce", "trestletech")


# Example of shiny package - 1 Basic

library(shiny); 
runApp(system.file("examples/01-basic", package="shinyAce"));

# Example from shiny 01_hello
runExample("01_hello")
runExample("02_text")
runExample("03_reactivity")
runExample("04_mpg")
runExample("07_widgets")
runExample("08_html")
runExample("10_download")
runExample("11_timer")

shinyUI
headerPanel
sidebarPanel
sliderInput0
switch
renderPrint
reactive


##### ui.R
library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Hello Shiny!"),

  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("obs", 
                "Number of observations:", 
                min = 1,
                max = 1000, 
                value = 500)
  ),

  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
  )
))

##################################### server.R
library(shiny)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$distPlot <- renderPlot({

    # generate an rnorm distribution and plot it
    dist <- rnorm(input$obs)
    hist(dist)
  })
})

##########



