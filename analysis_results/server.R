require(shiny)
require(data.table)
require(grid)
require(ggplot2)

#   setwd("P:/Data_Analysis/Analysis_Results/shiny_data/")
  setwd("/mnt/hgfs/Analysis_Results/shiny_data/")

# load("from_to_dates.RData")
from.to.dates <- fread("from_to_dates.csv", header = TRUE, sep = ",", na.strings=c("NA", '')) 

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # Get correct file names based on Ratio Type
  # Read all files and make a single frame/table
  passData <- reactive({
    
    # Select Optimized Vs Non-Optimized
    if(input$ratioType == "Conversion Ratio") {
      ratio.type <- ifelse(input$keywordType == "Optimized", "^total_conv_ratio", "^non_total_conv_ratio")
    }
    else{ #(input$ratioType == "Click Ratio") 
      ratio.type <- ifelse(input$keywordType == "Optimized", "^click_ratio", "^non_click_ratio") 
    }
    
    # Select files names for appropriate date range
    file.names <- from.to.dates[grep(ratio.type, file_name)][from_date >= input$dateRange[1] & to_date <= input$dateRange[2]]

    # Read all files and make a big Data Table
    analytics <- data.table()
    
    for(i in 1:nrow(file.names)){
        xx <- fread(file.names$file_name[i], header = TRUE, sep = ",", na.strings=c("NA", ''))
        xx$from.date <- file.names$from_date[i]
        xx$to.date <- file.names$to_date[i]
        
        analytics <- rbind(analytics, xx)
    }
    
    analytics
  })

  output$selectUI <- renderUI({ 
    
    # Making selection reactive on UI, to display selectable options for Y-Axis
    # based on the selection of the Ratio Type
    if(input$ratioType == "Conversion Ratio") choices.names <- c("Total Searches", "Conversion Ratio(%)" )
    if(input$ratioType == "Click Ratio") choices.names <- c("Total Searches", "Click Ratio(%)", "Total Clicks")
    
#      selectInput("yAxis", "Y-Axis Parameters for Graph", choices = choices.names)
     radioButtons("yAxis", "Y-Axis Parameters for Graph", choices = choices.names)
  })
  
  # Data Table output for Tabular Data tab
  output$view <- renderDataTable({
    dataset <- passData()
    dataset[order(-total_search)]
  }, options = list(aLengthMenu = c(10, 30, 45), 
                    iDisplayLength = 15, 
                    bSortClasses = TRUE
                    ))

  # Draw interactive graph for Graph tab
  output$monthGraph <- renderPlot({
    
    # Get data from reactive passData()
    dataset <- passData()

    # Sort based on Y-Axis parameter
#     if (input$yAxis == "Total Searches") dataset <- dataset[order(-total_search)]   
#     if (input$yAxis == "Conversion Ratio(%)") dataset <- dataset[order(-total_ConvRate)]              
#     if (input$yAxis == "Click Ratio(%)") dataset <- dataset[order(-click_ratio)]              
#     if (input$yAxis == "Total Clicks") dataset <- dataset[order(-total_clicks)]              

    # Sort based on total_search  
     dataset <- dataset[order(-total_search)]   

#     Exporting data to playwith it  
#     write.csv(dataset, file = "sample.csv", na = "0", row.names = FALSE)

# Making a list of unique keywords
     unique.keywords <- data.table("Q" = unique(dataset$Q), "sort_order" = 1:length(unique(dataset$Q)))

    #  Forming groups of 10 keywords in each
     if (input$keyGroup == "Top 10")       unique_keyGroup = unique.keywords[1:10]
     if (input$keyGroup == "Top 11 to 20") unique_keyGroup = unique.keywords[11:20]
     if (input$keyGroup == "Top 21 to 30") unique_keyGroup = unique.keywords[21:30]
     if (input$keyGroup == "Top 31 to 40") unique_keyGroup = unique.keywords[31:40]
     if (input$keyGroup == "Top 41 to 50") unique_keyGroup = unique.keywords[41:50]
     if (input$keyGroup == "Top 51 to 60") unique_keyGroup = unique.keywords[51:60]
     if (input$keyGroup == "Top 61 to 70") unique_keyGroup = unique.keywords[61:70]
     if (input$keyGroup == "Top 71 to 80") unique_keyGroup = unique.keywords[71:80]
     if (input$keyGroup == "Top 81 to 90") unique_keyGroup = unique.keywords[81:90]
     if (input$keyGroup == "Top 91 to 100") unique_keyGroup = unique.keywords[91:100]

    # Take data that match unique keyGroup    
    dataset <- dataset[Q %in% unique_keyGroup$Q]

    # Add sortorder as prefix
    unique_keyGroup$sort_order <- paste(unique_keyGroup$sort_order, unique_keyGroup$Q, sep = " - ")

    # Converting Dates to Char 
     dataset$from.date <- as.character(dataset$from.date)
     dataset$to.date <- as.character(dataset$to.date)
    
    # Merge to get the sort_order column 
     dataset <- merge(dataset, unique_keyGroup, by="Q")
    # Converting Q to ordered factor to control facet order
#      dataset$Q <- factor(dataset$Q, levels=unique(dataset[order(-total_search)]$Q), ordered=TRUE)
    dataset$Q <- factor(dataset$sort_order, levels=unique(dataset[order(-total_search)]$sort_order), ordered=TRUE)

    # Determine Y-Axis parameter
    if (input$yAxis == "Total Searches"){
       # Converting Q to ordered factor to control facet order
#        dataset$Q <- factor(dataset$Q, levels=unique(dataset[order(-total_search)]$Q), ordered=TRUE)
       
       # plot the graph
       theGraph <- ggplot(data=dataset, aes(x=to.date, y=total_search, fill=Q)) 
      
    }

    if (input$yAxis == "Conversion Ratio(%)"){
      # Converting Q to ordered factor to control facet order
#       dataset$Q <- factor(dataset$Q, levels=unique(dataset[order(-total_ConvRate)]$Q), ordered=TRUE)

      # plot the graph
      theGraph <- ggplot(data=dataset, aes(x=to.date, y=total_ConvRate, fill=Q))
    }

    if (input$yAxis == "Click Ratio(%)"){
      # Converting Q to ordered factor to control facet order
#       dataset$Q <- factor(dataset$Q, levels=unique(dataset[order(-click_ratio)]$Q), ordered=TRUE)

      # plot the graph
      theGraph <- ggplot(data=dataset, aes(x=to.date, y=click_ratio, fill=Q))
    }

    if (input$yAxis == "Total Clicks"){
      # Converting Q to ordered factor to control facet order
#       dataset$Q <- factor(dataset$Q, levels=unique(dataset[order(-total_clicks)]$Q), ordered=TRUE)

      # plot the graph
      theGraph <- ggplot(data=dataset, aes(x=to.date, y=total_clicks, fill=Q))
    }


    # Extra options for the ggplot2 graph
    theGraph <-   theGraph +
                  xlab("Ending Weeks") + ylab(input$yAxis) + 
                  ggtitle( paste0("Weekly Analysis of ", input$yAxis)) +
                  # Bar chart
                  geom_bar(color="black", stat="identity") +
                  # Facet by keywords  
                  facet_wrap(~ Q, ncol = 2) + 
                  # No legends required
                  guides(fill=FALSE) +
#                   geom_text(stat="bin", color="white", hjust=0.5, vjust=1.2, size=3, aes(y=total_ConvRate, label=total_ConvRate))+

                  theme(panel.margin = unit(1, "lines"), 
                        # Vertical x-axis
                        axis.text.x = element_text(angle = 90, hjust = 0.5),
                        # Main plot heading 
                        plot.title = element_text(size = rel(1.4), vjust=1, face="bold"),
                        # Facet elements titles
                        strip.text.x = element_text(size = 11, hjust = 0.5, vjust = 0.5, face = 'bold'))
  
    print(theGraph)
    
  }, height=810, res=90, width="auto")
    
})