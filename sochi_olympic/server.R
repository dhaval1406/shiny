################################################################
#   Analysis Code for Sochi Olympics                           #
################################################################


library(shiny)
library(data.table)
library(XML)
library(ggplot2)
library(reshape2)


# invisible(lapply(c('shiny', 'ggplot2', 'XML', 'reshape2', 'data.table') , require, character.only=TRUE))

url = "http://www.sochi2014.com/en/medal-standings/"

mydata <- XML::readHTMLTable(url, colClasses = c(rep("factor", 2), rep("numeric", 4)))    

# Converting list to data.table  
mydata <- rbindlist(mydata)

# Rank not needed
mydata$Rank <- NULL

shinyServer(function(input, output){
  
  # Data Table output for Tabular Data tab
  output$view <- renderDataTable({
                                   if(input$zero_medals == "No"){
                                      mydata <- mydata[Total>0][order(-Total)]
                                    }
                                   else{
                                     mydata[order(-Total)]
                                   }

                                 }, 
                                 options = list(aLengthMenu = c(25, 50, 75, 100), 
                                                iDisplayLength = 25, 
                                                bSortClasses = TRUE))    

  
  
  
  # Graph  
  output$myplot <- renderPlot({

    # No looser countries
    if(input$zero_medals == "No"){
      mydata <- mydata[Total>0]
    }

    # Ordering dat to get correct factors
    mydata <- mydata[order(Total, Gold, Silver, Bronze, Country)]

    # Readjusting factors
    mydata$Country <- factor(mydata$Country, levels = mydata$Country)
    
    # Making long format using melt    
    newdata <- melt(mydata, id.vars="Country", variable.name="Medal", value.name="Count")
    
    # Plot
    theGraph <- ggplot(data=newdata, aes(x=Country, y=Count, fill=Medal)) + coord_flip() +
    
                  # Bar chart
                  geom_bar(color="black", stat="identity") +
                  # Facet by Medals  
                  facet_wrap(~ Medal, ncol = 4) +
                  # No legends required
                  guides(fill=FALSE) +
                  theme_bw()+
                  scale_colour_manual(values=c("#CC6600", "#999999", "#FFCC33", "#000000")) +
                  # Label number inside the bars
                  geom_text(color="white", hjust=1.5, vjust=0.5, size=3, aes(y=Count, label=Count))
 
    print(theGraph)
    
  }, height=900, res=85, width="auto")
  
  
})