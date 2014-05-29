require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    names(iris) = gsub("\\.", "", names(iris))
#     p1 <- rPlot(input$x, input$y, data = iris, color = "Species", 
#       facet = "Species", type = 'point')

     p1 <- rPlot(input$y, input$x, data = iris, color = "Species", type = 'bar')
#     p1$facet(var = 'Species', type = 'wrap', rows = 2)

    p1$addParams(dom = 'myChart')
    return(p1)
  })
})