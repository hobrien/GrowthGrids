shinyUI(fluidPage(
  titlePanel("Growth Grid"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      numericInput('temp1', 'Temperature', 25, min = NA, max = NA, step = NA, width = NULL),
      tags$hr(),
      fileInput('file2', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      numericInput('temp2', 'Temperature', 25, min = NA, max = NA, step = NA, width = NULL),
      tags$hr(),
      fileInput('file3', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv'
                )
      ),
      numericInput('temp3', 'Temperature', 25, min = NA, max = NA, step = NA, width = NULL),
      tags$hr(),
      checkboxInput('header', 'Header', TRUE),
      radioButtons('sep', 'Separator',
                   c(Tab='\t',
                     Comma=',',
                     Semicolon=';'
                     ),
                   '\t'),
      radioButtons('quote', 'Quote',
                   c(None='',
                     'Double Quote'='"',
                     'Single Quote'="'"),
                   ''),
      
      tags$hr(),
      radioButtons('out_format', 'Select the file type', choices=list('png', 'pdf')),
      downloadButton('downloadPlot', label="Download the plot")
      
    ),
    mainPanel(
      uiOutput("growthPlot")
      #verbatimTextOutput("plot_hoverinfo")
      
    )
  )
))