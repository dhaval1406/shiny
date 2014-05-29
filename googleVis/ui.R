### copied from http://stackoverflow.com/questions/18118861/why-is-my-googlevis-chart-causing-a-r-encountered-a-fatal-error-when-trying-to
library(shiny)

dataset <- list('Upload a file'=c(1))

shinyUI(pageWithSidebar(

  headerPanel("Text area to dataframe with shinyAce"),
  sidebarPanel(

    fileInput('file', 'Data file'),
    radioButtons('format', 'Format', c('CSV', 'TSV')),



      conditionalPanel(condition = "input.tsp == 'sort'",
                       checkboxInput(inputId = "pageable", label = "Make table pageable"),
                       conditionalPanel("input.pageable==true",
                                        numericInput(inputId = "pagesize",
                                                     label = "Entries per page",10))              


      ),
      conditionalPanel(condition = "input.tsp == 'multi' ",


          selectInput('x', 'X', names(dataset)),
          selectInput('y', 'Y', names(dataset),  multiple=T),
          selectInput('color', 'Color', c('None', names(dataset))),

          checkboxInput('jitter', 'Jitter'),
          checkboxInput('smooth', 'Smooth'),

          selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
          selectInput('facet_col', 'Facet Column', c(None='.', names(dataset)))

      )

  ),

  mainPanel( 
      tabsetPanel(
        tabPanel("Sortable Table", htmlOutput("gvisTable"),value="sort"),
        tabPanel("Multiplot", plotOutput('plotMulti'), value="multi"),
        id="tsp"
      )

  )
))