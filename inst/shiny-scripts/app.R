# Purpose: shinny function
# Author: Wenzhu Ye
# Date: 12.07.2022
# Version: 1.0.0
# Bugs and Issues: N/A

library(shiny)


ui <- fluidPage(
  tags$head(tags$style(HTML('* {font-family: "Arial"};'))),

  # App title ----
  titlePanel(h1("DeregGenes", align = "center", )),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      width = '100%',
      align = "center",

      tags$p("Display heatmap, aggregate anlysis result from inputed data."),

      br(),

      tags$p("Upload CSV files containing the data from gene differential
      expression. The first cloumn of the CSV file should be the gene symbols,
      and for the rest of the columns, each column should represent the gene
      expression level for corresponding genes for singel sample. Please refer
      to the 2 example datasets below from example."),

      br(),

      # Input files
      tags$a(href = paste("https://github.com/wezhubb/DeregGenes/blob/master",
                          "/inst/extdata/GSE29721.csv", sep = ''),
             "Example Dataset 1"),

      fileInput("input1",
                "Choose CSV File for gene differential expression data",
                accept = ".csv"),

      tags$p("Enter input class for above input file(default is given for
             example dataset 1), please seperate each sample using comma,
             no space"),
      textAreaInput(inputId = 'class1',
                    label = 'class 1',
                    value = paste("mutant,control,mutant,control,mutant,",
                     "control,mutant,control,mutant,control,mutant,control,",
                     "mutant,control,mutant,control,mutant,control,mutant,",
                     "control", sep = '')
                     ),

      tags$a(href = paste("https://github.com/wezhubb/DeregGenes",
                          "/blob/master/inst/extdata/GSE84402.csv", sep = ''),
             "Example Dataset 2"),

      fileInput("input2",
                "Choose CSV File for gene differential expression data",
                accept = ".csv"),

      tags$p("Enter input class for above input file(default is given for
             example dataset 2), please seperate each sample using comma,
             no space"),
      textAreaInput(inputId = 'class2', label = 'class 2',
                    value = paste("mutant,control,mutant,control,mutant,",
                                  "control,mutant,control,mutant,control,",
                                  "mutant,control,mutant,control,mutant,",
                                  "control,mutant,control,mutant,control,",
                                  "mutant,control,mutant,control,mutant,",
                                  "control,mutant,control", sep = '')),

      # Input padj cutoff
      textInput(inputId = "padj",
                label = "Enter padj cutoff (0 - 1, default 0.01)", "0.01"),

      # Input logFC cutoff
      textInput(inputId = "logFC",
                label = "Enter logFC cutoff (above 0, default 1)", "1"),

      # action button
      actionButton(label = "start", inputId = "Start"),
      tags$p('analysis process might take 30s - 60s'),

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      width = '100%',

      align = "center",

      # Output:
      tabsetPanel(type = "tabs",
                 tabPanel("Heatmap", plotOutput("heatmap")),
                  tabPanel("UpSig", dataTableOutput("upSig")),
                  tabPanel("DownSig", dataTableOutput("downSig"))

      )
    )
  )
)

# Define server
server <- function(input, output) {
  # change max size to 30MB
  options(shiny.maxRequestSize=30*1024^2)

  # check button status
  v <- reactiveValues(dothing = FALSE)

  observeEvent(input$Start, {
    v$dothing <- input$Start
  })

  observeEvent(input$tabset, {
    v$dothing <- FALSE
  })

  # event after button pressed
  aggreg <- eventReactive(eventExpr = input$Start, {
    i1 <- as.matrix(as.data.frame(read.csv(input$input1$datapath,
                           sep = ",",
                           header = TRUE)))

    rownames(i1) <- i1[,1]
    i1 <- i1[,-1]

    i2 <- as.matrix(as.data.frame(read.csv(input$input2$datapath,
                                 sep = ",",
                                 header = TRUE)))
    rownames(i2) <- i2[,1]
    i2 <- i2[,-1]

    class <- as.vector(strsplit(input$class1, ',')[[1]])
    result1 <- DeregGenes::logFCsingle(i1, class)

    class <- as.vector(strsplit(input$class2, ',')[[1]])
    result2 <- DeregGenes::logFCsingle(i2, class)
    listLogFC <- list(result1, result2)
    listTitle <- c("GSE29721", "GSE84402")
    DeregGenes::Aggreg(listLogFC, listTitle, padj = as.numeric(input$padj),
                       logFC = as.numeric(input$logFC))
  })


  # Plotting heatmap plots
  output$heatmap <- renderPlot({
    if (v$dothing == FALSE) return(NULL)
    DeregGenes::plotHeatMap(data.frame(aggreg()[3]))
  })

  output$upSig <- renderDataTable({
    if (v$dothing == FALSE) {
      return(NULL)}

    data.frame(aggreg()[1])

  })

  output$downSig <- renderDataTable({
    if (v$dothing == FALSE) return(NULL)

    data.frame(aggreg()[2])
  })
}

# Create Shiny app ----
shiny::shinyApp(ui = ui, server = server)

# [END]
