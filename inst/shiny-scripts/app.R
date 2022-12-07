# The code is adapted from
# RStudio Inc. (2013). Tabsets. Shiny Gallery. URL:https://shiny.rstudio.com/gallery/tabsets.html

# I have example rds files for DESeq2 and edgeR result in inst/shiny-scipts

library(shiny)

ui <- fluidPage(

  # App title ----
  titlePanel("DeregGenes"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      tags$p("Plot Venn diagram, MA plots and Volcano plots comparing results
              from DESeq2 and edgeR."),
      tags$p("Upload RDS files containing the result from DESeq2, a DESeqResults
             object, and a data frame taken from the table component of the
             returned value of edgeR topTags function (edgeR::topTags(..)$table
             )"),

      br(),

      # Input files
      tags$a(href="https://github.com/wezhubb/DeregGenes/blob/master/data/GSE29721.rda", "Example Dataset 1"),

      fileInput("input1", "Choose CSV File for gene differential expression data",
                accept = ".csv"),

      tags$a(href="https://github.com/wezhubb/DeregGenes/blob/master/data/GSE84402.rda", "Example Dataset 2"),

      fileInput("input2", "Choose CSV File for gene differential expression data",
                accept = ".csv"),

     #actionButton(inputID = "addInput",label = "Add Input"),

      #uiOutput(inputID = "inputs"),

      # Input padj cutoff
      textInput(inputId = "padj",
                label = "Enter padj cutoff (0 - 1)", "0.01"),

      # Input logFC cutoff
      textInput(inputId = "logFC",
                label = "Enter padj cutoff (above 0)", "1"),

      # action button
     actionButton(label = "start", inputId = "Start"),

    ),

    # Main panel for displaying outputs ----
    mainPanel(

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
  options(shiny.maxRequestSize=30*1024^2)


  v <- reactiveValues(dothing = FALSE)

  observeEvent(input$Start, {
    v$dothing <- input$Start
  })

  observeEvent(input$tabset, {
    v$dothing <- FALSE
  })



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

    class <- c("mutant", "control","mutant", "control","mutant", "control",
             "mutant", "control","mutant", "control","mutant", "control", "mutant",
             "control","mutant", "control","mutant", "control", "mutant", "control")
    result1 <- DeregGenes::logFCsingle(i1, class)

    class <- c("mutant", "control","mutant", "control","mutant", "control",
            "mutant", "control","mutant", "control","mutant", "control", "mutant",
             "control","mutant", "control","mutant", "control", "mutant", "control",
             "mutant", "control","mutant", "control", "mutant", "control","mutant",
             "control")

    result2 <- DeregGenes::logFCsingle(i2, class)
    listLogFC <- list(result1, result2)
    listTitle <- c("GSE29721", "GSE84402")
    DeregGenes::Aggreg(listLogFC, listTitle, padj = as.numeric(input$padj), logFC = as.numeric(input$logFC))
  })


  # Plotting heatmap plots
  output$heatmap <- renderPlot({
    if (v$dothing == FALSE) return(NULL)
    #input1 <- input$input1
    #input2 <- input$input2

    # wait until we got all files
    #if (is.null(input1) | is.null(input2)) {
    #  return(NULL)
    #}

    #input1Result <- readRDS(input1$datapath)
    #input2Result <- readRDS(input2$datapath)
    #padjCutoff <- as.numeric(input$padj)
    #logFCCutoff <- as.numeric(input$logFC)

    #if (is.null(input1Result) | is.null(input2Result)) {
    #  return(NULL)
    #}


    DeregGenes::plotHeatMap(data.frame(aggreg()[3]), 4, 6)


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
