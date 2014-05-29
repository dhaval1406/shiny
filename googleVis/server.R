library(reshape2)
library(googleVis)
library(ggplot2)

options(shiny.maxRequestSize=-1)

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


shinyServer(function(input, output, session) {

  #-----------------------------------------------------------
  # Dataview Tab Inputs
  #-----------------------------------------------------------  

  data <- reactive({

    if (is.null(input$file))
      return(NULL)
    else if (identical(input$format, 'CSV'))
      return(read.csv(input$file$datapath))
    else
      return(read.delim(input$file$datapath))
  })

  observe({
    df <- data()
    str(names(df))
    if (!is.null(df)) {
      updateSelectInput(session, 'x', choices = names(df))
      updateSelectInput(session, 'y', choices = names(df))
      updateSelectInput(session, 'color', choices = c('None', names(df)))
      updateSelectInput(session, 'facet_row', choices = c(None='.', names(df)))
      updateSelectInput(session, 'facet_col', choices = c(None='.', names(df)))

    }
  })


  myOptions <- reactive({
    list(

      page=ifelse(input$pageable==TRUE,'enable','disable'),
      pageSize=input$pagesize,
      width=1000

      )
  })

  output$gvisTable <- renderGvis( {
    if (is.null(data()))
      return(NULL)

    gvisTable(data(), options=myOptions())


  })

  #-----------------------------------------------------------
  # Graphs
  #-----------------------------------------------------------  


  output$plotMulti <- renderPlot({
    if (is.null(data()))
      return(NULL)

    temp <- input$x
    p <- ggplot(data(), aes_string(x=temp, y=input$y), environment = environment()) 
    p <- p + geom_bar()

    if (input$smooth)
      p <- p + geom_smooth()

    if (input$color != 'None')
      p <- p + aes_string(color=input$color)

    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)

    if (input$jitter)
      p <- p + geom_jitter()


    multiplot(p, p)


  })


})