################################################################
#   Analysis Code for Sochi Olympics                           #
################################################################

library(shiny)

shinyUI(
  pageWithSidebar(
      headerPanel(
          HTML(
          	'<div id="stats_header">
      		   <h3 align="center"> Sochi Olympics Medal Stats 
      			<a href="http://www.sochi2014.com/en" target="_blank">
      			<img id="olympic_logo" align="left" alt="Olympic Logo" src="/olympic.gif" />
      			</a></h3>
      			</div>'
      		),
      windowTitle = "Sochi Olympics Medal Stats"
      ),

      
    sidebarPanel(
      radioButtons("zero_medals", "Include Countries with 0 Medals", 
                   choices = c("Yes", "No"), selected = "No"),
      br(),br(),br(),
      helpText("The data for this plot comes from http://www.sochi2014.com/en/medal-standings."),
      
      
      tags$head(
            tags$style(type="text/css", ".radio { padding-left: 30px }"),
            tags$style(type='text/css', ".well { background-color: rgba(221, 221, 221, 0.62); 
                                                 border: 1px solid #a1a1a1; 
                                                 border-radius: 25px;
                                                 box-shadow: 10px 10px 5px #888888;}"),
            tags$style(type='text/css', ".btn { font-weight: bold; 
                                                margin-left: 45px;
                                                border: 1px solid #aaaaaa;
                                                border-radius: 10px;
                                                box-shadow: 1.5px 1.5px 11px 1px #888888;}"),
            tags$style(type='text/css', ".control-label{ font-weight: bold; }"),
            tags$style(type='text/css', ".table td{ padding: 1.5px; }")
         )
    ),

    
    mainPanel(
     tabsetPanel(
      tabPanel('Tabular Data', dataTableOutput("view")),
      tabPanel('Graph', plotOutput("myplot"))
     )
    )
  )
)
