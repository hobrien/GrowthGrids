library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
  prepareData <- function(df, temp) {
      df2 <- gather(df, "time", "OD", 4:ncol(df)) 
      df2$Temperature <- as.factor(temp)
      df2$time <- as.numeric(df2$time)
      df2
  }
  createPlot <- function(df) {
  
    ggplot(df, aes(x=time, y=OD, group=paste(Sample, Temperature), colour=Temperature)) +
      geom_line() +
      facet_grid(Row ~ Column) +
      theme(axis.text=element_blank()) +
      theme(axis.ticks=element_blank()) +
      theme(legend.position="bottom") +
      theme(legend.direction= "horizontal")
  }
  
  
  
  output$growthPlot <- renderUI({
    plotOutput("plot", height=300,
               hover = hoverOpts(
                 id = "plot_hover",
                 delay = input$hover_delay,
                 delayType = input$hover_policy,
                 nullOutside = input$hover_null_outside
               )
    )
  })
  data <- reactive({
    inFile <- input$file1
    
    data <- read.csv(inFile$datapath, header = input$header,
                     sep = input$sep, quote = input$quote, check.names=FALSE)
    data <- prepareData(data, input$temp1)
    
    data <- rbind(data, data2())
    data <- rbind(data, data3())
  })
  data2 <- reactive({
    if (is.null(input$file2))
      return(NULL)
      inFile2 <- input$file2
      data2 <- read.csv(inFile2$datapath, header = input$header,
                        sep = input$sep, quote = input$quote, check.names=FALSE)
      data2 <- prepareData(data2, input$temp2)
  })
  data3 <- reactive({
    if (is.null(input$file3))
      return(NULL)
    inFile3 <- input$file3
    data3 <- read.csv(inFile3$datapath, header = input$header,
                      sep = input$sep, quote = input$quote, check.names=FALSE)
    data3 <- prepareData(data3, input$temp3)
  })
  plot <- reactive({
    createPlot(data())
  })
  output$plot <- renderPlot({
    if (is.null(input$file1))
      return(NULL)
    plot()    
  })
  output$plot_hoverinfo <- renderPrint({
    cat("input$plot_hover:\n")
    str(input$plot_hover)
  })
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$file1, input$out_format, sep='.') },
    content = function(file) {
      if(input$out_format == 'png'){
        device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      }
      else {
        device <- function(..., width, height) grDevices::pdf(..., width = width, height = height)
        
      }
      ggsave(file, plot = plot(), device = device)
    })  
})

