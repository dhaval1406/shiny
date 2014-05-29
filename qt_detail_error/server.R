require(shiny)
require(data.table)
# require(grid)
# require(ggplot2)


#  setwd("Q:/marketingshared/LogFiles/")
 setwd("/mnt/hgfs/LogFiles/")

file.list <- list.files(path=".", pattern="us_dt_qtdetail_error", ignore.case=T)
file_dates <- as.Date(gsub("^([0-9]{8}).*", "\\1", file.list), "%m%d%Y")

# Create data table, order it by date
from.to.dates <- data.table("file_name" = file.list, "date" = file_dates)
from.to.dates <- from.to.dates[order(date, decreasing=T)]

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # Get correct file names based on Ratio Type
  # Read all files and make a single frame/table
  passData <- reactive({
    
    # Select files names for appropriate date range
    file.names <- from.to.dates[date >= input$dateRange[1] & date <= input$dateRange[2]]

    # Select only files that are non-empty or size great than 0
    file.names <- file.names[file.info(file.names$file_name)$size > 0]
    
    # Read all files and make a big Data Table
    analytics <- rbindlist(lapply(file.names$file_name, function(x) {
      xx <- fread(x, header = TRUE, sep = "\t", na.strings=c("NA","N/A",""))
    }))
    
    # Keep only required columns
    analytics <-  analytics[, c("QUOTATION_NUMBER", "QUOTATION_SEQ", "CUSTOMER_CODE",
                                "REQUEST_DATE","USER_CODE","STATUS_CODE","ACOLL_STATUS_CODE",
                                "PART_NUMBER","QUANTITY","STORK","CLASSIFY_CODE","INNER_CODE",
                                "MODIFY_DATE","MODIFY_USER_CODE","MOSS_MODIFIED_DATE","QT_ERROR_MESSAGE"), with=F]
    
    # Clean up as per Don
    analytics$QUOTATION_NUMBER <- gsub("^N(.*)", "\\1", analytics$QUOTATION_NUMBER)
    analytics$REQUEST_DATE <- gsub("(.*?) .*", "\\1", analytics$REQUEST_DATE)
    analytics$MODIFY_DATE <- gsub("(.*?) .*", "\\1", analytics$MODIFY_DATE)
    analytics$MOSS_MODIFIED_DATE <- gsub("(.*?) .*", "\\1", analytics$MOSS_MODIFIED_DATE)
    
    # More meaningful column names
    setnames(analytics, c("Quote_Num", "Quote_Seq", "Cust_CD", "Request_DT",
                          "User_CD", "Stat_CD", "Acoll_CD", "PART_NUMBER", "Qnty",
                          "Stork", "Class_CD", "Inner_CD", "Modify_DT",
                          "Mod_User_CD", "Moss_Mod_DT", "QUOTE_ERROR_MESSAGE(EXTENDING_COLUMN_WIDTH_TO_FIT_LONGER_ERROR_MESSAGE_POSSIBLE)"))
    analytics[order(Quote_Num, decreasing=T)]
  })

  # Data Table output for Tabular Data tab
  output$view <- renderDataTable({
                                   passData()
                                 }, 
                                 options = list(aLengthMenu = c(15, 30, 45, 60), 
                                                iDisplayLength = 15, 
                                                bSortClasses = TRUE))    

  # Download Data functionality
  output$downloadData <- downloadHandler(
    filename = function() { 
      
      paste("QT_Detail_Error", '_', 
            input$dateRange[1], '_',
            input$dateRange[2], '.csv', 
            sep='') 
                            },
    content = function(file) {
      dataset <- passData()
#       dataset <- dataset[order(Modify_DT, decreasing=T)]
      write.csv(dataset, file, na = "0", row.names = FALSE)
    }
  )
    
})