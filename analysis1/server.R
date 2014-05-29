library(shiny)
library(datasets)
library(data.table)
# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
    passData <- reactive({
    
    file.names <- file_data[file_data$X1 >= from.date & file_data$X2 <= to.date, ]

    analytics <- data.table()
    
    for(i in 1:nrow(file.names)){
        xx <- fread(file.names$file_name[i], header = TRUE, sep = ",", na.strings=c("NA", ''))
        xx <- xx[total_search > 5]
        xx$Q <- gsub("(.+[^s])s$", "\\1", xx$Q)
        xx$from.date <- file.names$X1[i]
        xx$to.date <- file.names$X2[i]
        
        analytics <- rbind(analytics, xx)
    }
    
#     analytics <- rbindlist(lapply(file.names[1], function(x) {
#       xx <- fread(x, header = TRUE, sep = ",", na.strings=c("NA", ''))
#     }))
    
    analytics
    
  })


  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars)
  })

  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })

  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
  output$textDisplay <- renderText({ 
    "I am here, no fear...LOL!!"
#     paste(input$dateRange[1])
  })
  
})