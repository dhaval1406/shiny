library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(
      HTML(
    		'<div id="stats_header">
  		   <h3 align="center"> Keyword Click/Conversion Ratio 
  			<a href="http://misumiusa.com" target="_blank">
  			<img id="misumi_logo" align="left" alt="Misumi Logo" src="/misumi.gif" />
  			</a></h3>
  			</div>'
  		),
      windowTitle = "Keyword Click/Conversion Ratio"
  ),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
        dateRangeInput(inputId = "dateRange",  
                   label = "Date range", 
                   start = Sys.Date()-119,
                   separator = "-",
                   min = "2013-10-28",
                   format = "M-dd-yyyy",
                   weekstart = 1,
                   max = Sys.Date()
    ),
    
    selectInput("ratioType", "Ratio Type", 
                choices = c("Conversion Ratio", "Click Ratio", "Conversion by Category" )),

    selectInput("keyGroup", "Keyword Group (Graph)", 
                choices = c("Top 10", 
                            "Top 11 to 20", 
                            "Top 21 to 30", 
                            "Top 31 to 40", 
                            "Top 41 to 50",
                            "Top 51 to 60",
                            "Top 61 to 70",
                            "Top 71 to 80",
                            "Top 81 to 90",
                            "Top 91 to 100",
                            "Top 101 to 110", 
                            "Top 111 to 120", 
                            "Top 121 to 130", 
                            "Top 131 to 140", 
                            "Top 141 to 150")),
    
#     radioButtons(inputId = "outputType",
#                  label = "Analysis Type",
#                  choices = list("Weekly" = "weekly",
#                                 "Monthly" = "monthly"))

#     selectInput("yAxis", "Y-Axis Parameter for Graph", 
#                 choices = c("Total Searches", "Conversion Rate" ))

   # Instead of above static selectInput, using reactive one. 
   # With declaration of code in server.R and display its html below
    radioButtons("keywordType", "Select Keywords Type", 
                choices = c("Optimized", "Non-Optimized" )),
   
    htmlOutput("selectUI"), br()
     ,tags$head(
#           tags$style(type="text/css", ".radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none;}"),
            tags$style(type="text/css", ".radio { padding-left: 30px }"),
#           tags$style(type="text/css", "select { max-width: 200px; }"),
#           tags$style(type="text/css", "textarea { max-width: 185px; }"),
#           tags$style(type="text/css", ".jslider { max-width: 200px; }"),
            tags$style(type='text/css', ".well { background-color: rgba(221, 221, 221, 0.62); 
                                                 border: 1px solid #a1a1a1; 
                                                 border-radius: 25px;
                                                 box-shadow: 10px 10px 5px #888888;}"),
#           tags$style(type='text/css', ".span4 { max-width: 310px; }")
            tags$style(type='text/css', ".btn { font-weight: bold; 
                                                margin-left: 45px;
                                                border: 1px solid #aaaaaa;
                                                border-radius: 10px;
                                                box-shadow: 1.5px 1.5px 11px 1px #888888;}"),
            tags$style(type='text/css', ".control-label{ font-weight: bold; }"),
            tags$style(type='text/css', ".table td{ padding: 1.5px; }")
         ),

    downloadButton('downloadData', 'Download Data')

  ),

  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    tabsetPanel(
      tabPanel('Tabular Data', dataTableOutput("view")),
      tabPanel('Graph', plotOutput("monthGraph"))
    )
  )
))
  
#   
#   mainPanel(
#     h3(textOutput("textDisplay")), 
#     verbatimTextOutput("uniqueQ"),
# 
#     dataTableOutput("view")
#   )
# ))
# 



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
