
# install ShinyDash from Git
devtools::install_github("ShinyDash", "trestletech")

library(shiny)
library(ggplot2)
library(ShinyDash)
# library(leaflet)

runApp("P:/R/shiny/shinyapp")

runApp("P:/R/shiny/datatables_app/")

runApp("P:/R/leaflet-shiny/inst/example/")

runApp("P:/R/ShinyDash-Sample/")

runApp("P:/R/ShinyDash/")

runExample()
runExample("06_tabsets")
system.file("examples", package="shiny")

### Analysis 1 result example
runApp("P:/R/shiny/analysis1/")

### conversion ratio and click ratio analysis
runApp("P:/R/shiny/conversion/")

### To run on ubuntu server.
runApp("/srv/shiny-server/conversion/")

### Sochi olympic
runApp("P:/R/shiny/sochi_olympic/")
runApp("/srv/shiny-server/sochi_olympic/")

runApp("P:/R/shiny/qt_detail_error//")

# googleVis example with shiny
runApp("P:/R/shiny/googleVis/")


### rCharts - running gist from ramnavav
require(devtools)
install_github('rCharts', 'ramnathv', ref = 'dev')
runGist("https://gist.github.com/ramnathv/8232949d68c3402e398d")
runGist("https://gist.github.com/jcheng5/3239667")

# Example of book - Web Application Development with R
# Sample chapter 2 download karelu chhe

runApp("P:/R/GoogleAnalytics/")

### Run gist for point to point mapping
runGist(9690079)


###### === Build R code here before deploy in shiny code ===== #####
require(data.table)
require(stringr)


setwd("P:/Data_Analysis/Analysis_Results/weekly_results/")

file.list <- list.files(path=".", pattern="1_keyword*", ignore.case=T)

from_to_dates <- gsub(".*?_([0-9]{8}_[0-9]{8}).*", "\\1", file.list)

seq.Date(as.Date("07152013", "%m%d%Y"), as.Date("01202014", "%m%d%Y"), by="weeks")

split_from_to_dates <- strsplit(from_to_dates, "_")

x <- data.frame(do.call(rbind, split_ from_to_dates), "file_name" = file.list)

as.Date(x$X1, "%m%d%Y")
x$file_name <- as.character(x$file_name)

x <- x[order(x$X1, x$X2), ]
x[x$X1 >= from.date & x$X2 <= to.date, "file_name"]

shaft <-  shaft[, list(total_search = sum(total_search), 
                         sum_linkCtg = sum(sum_linkCtg), 
                         total_codefix = sum(total_codefix)), 
                  by=list(Q, from.date,to.date)]
      

plot(shaft$to.date, shaft$total_search, type="l")

