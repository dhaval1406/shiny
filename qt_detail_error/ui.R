####################################
#  Quote detail analysis for Don   #
#########################################################
# Quote Detail Erorr Analysis Web App - for Don B.      #
#  - Nice piece of shiny-app                            #
#  - Gets all Quote Detail error log names              #
#    - Reads only files within selected data range      #  
#    - Excludes emtpy/zero size files                   #
#    - It also let you to download data withing         #
#         selected date range                           #
#########################################################             

library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(
      HTML(
    		'<div id="stats_header">
  		   <h3 align="center"> Quote Detail Error Analysis 
  			<a href="http://misumiusa.com" target="_blank">
  			<img id="misumi_logo" align="left" alt="Misumi Logo" src="http://192.168.14.36:8000/misumi.gif" />
  			</a></h3>
  			</div>'
  		),
      windowTitle = "Quote Detail Error Analysis"
  ),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
        dateRangeInput(inputId = "dateRange",  
                   label = "Date range", 
                   start = Sys.Date()-7,
                   separator = "-",
                   min = "2013-01-01",
                   format = "M-dd-yyyy",
                   weekstart = 1,
                   max = Sys.Date()
    ),
    
    htmlOutput("selectUI"), br()
     ,tags$head(
            tags$style(type='text/css', ".well { background-color: rgba(221, 221, 221, 0.62); 
                                                 border: 1px solid #a1a1a1; 
                                                 border-radius: 25px;
                                                 box-shadow: 10px 10px 5px #888888;}"),
            tags$style(type='text/css', ".btn { font-weight: bold; 
                                                margin-left: 40px;
                                                border: 1px solid #aaaaaa;
                                                border-radius: 10px;
                                                box-shadow: 1.5px 1.5px 11px 1px #888888;}"),
            tags$style(type='text/css', ".control-label{ font-weight: bold; }"),
            tags$style(type='text/css', ".table td{ padding: 1px; }"),
            tags$style(type='text/css', ".span4 { max-width: 250px; }"),
            tags$style(type='text/css', ".span8 { font-size: 10px; }"), 
            tags$style(type='text/css', ".input-daterange input{ padding: 0px; }")
         ),

    downloadButton('downloadData', 'Download Data')
  ),

  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    tabsetPanel(
      tabPanel('Data', dataTableOutput("view"))
#       ,tabPanel('Graph', plotOutput("monthGraph"))
    )
  )
))
  
#################### Test Area ######################

#### Initially make file with all file names and dates

# setwd("P:/Data_Analysis/Analysis_Results/shiny_data/")
# 
# # file.list <- list.files(path=".", pattern="total_conv_ratio*", ignore.case=T)
# file.list <- list.files(path=".", pattern="*.csv", ignore.case=T)
# 
# from_to_dates <- gsub(".*?_([0-9]{8}_[0-9]{8}).*", "\\1", file.list)
# 
# split_from_to_dates <- strsplit(from_to_dates, "_")
# 
# from.to.dates <- data.table(do.call(rbind, split_from_to_dates), "file_name" = file.list)
# 
# colnames(from.to.dates) <- c("from_date", "to_date", "file_name")
# 
# 
# from.to.dates$from_date <- as.Date(from.to.dates$from_date, "%m%d%Y")
# from.to.dates$to_date <- as.Date(from.to.dates$to_date, "%m%d%Y")
# from.to.dates$file_name <- as.character(from.to.dates$file_name)
# 
# from.to.dates <- from.to.dates[order(from.to.dates$from_date, 
#                                       from.to.dates$to_date), ]
# 
# 
# write.csv(from.to.dates, file = "from_to_dates.csv", na = '', row.names = FALSE)
# save(from.to.dates, file="from_to_dates.RData")
# 
# from.to.dates[grep("conv_ratio", file_name)]

# ###file read 
#     file.names <- from.to.dates[from.to.dates$from_date >= from.date & from.to.dates$to_date <= to.date, ]
#   
#     analytics <- data.table()
#     
#     for(i in 1:nrow(file.names)){
#         xx <- fread(file.names$file_name[i], header = TRUE, sep = ",", na.strings=c("NA", ''))
#         xx$from.date <- file.names$from_date[i]
#         xx$to.date <- file.names$to_date[i]
#         
#         analytics <- rbind(analytics, xx)
#     }
# 
# 
# # plot(shaft$to.date, shaft$total_search, type="l")
# 
# analytics <- analytics[order(-total_search)]
# 
# unique(analytics$Q)[1:20]
# 
# shaft <- analytics[Q %in% unique(analytics$Q)[16:50]]
# 
# library(ggplot2)
# 
# p <- qplot(to.date, total_search, data=shaft, color=Q, xlab="Week Ending", ylab="Total Searches") 
# # p <- qplot(from.date, total_search, data=shaft, color=Q) 
# 
# # another way
# # p <- ggplot(data=shaft, aes(x=to.date, y=total_search, color=Q))
# 
# # draw a line of size 2.5, increase legend color size
# p + geom_line(size=2.5) + guides(colour = guide_legend(override.aes = list(size=7))) 
# 
# # Line graph with facets by keyword
# p + geom_line(size=1) + guides(colour = guide_legend(override.aes = list(size=2))) + facet_wrap(~ Q)
# 
# 
# #### Bar chart with facets by keywords, no legend
# ggplot(data=shaft, aes(x=to.date, y=total_search, fill=Q)) + 
#   geom_bar(color="black", stat="identity") +
#   facet_wrap(~ Q) + 
#   guides(fill=FALSE) +
#   xlab("Week End") + ylab("Total Searches") + 
#   ggtitle("Weekly Analysis of Total Searches")
# 
# 
