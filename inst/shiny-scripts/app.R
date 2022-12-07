# The code is adapted from
# RStudio Inc. (2013). Tabsets. Shiny Gallery. URL:https://shiny.rstudio.com/gallery/tabsets.html

library(shiny)

ui <- fluidPage(

  # App title ----
  titlePanel("DeregGenes"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      width = 10,

      tags$p("Heatmap, aggregate anlysis result from inputed data."),
      br(),
      tags$p("Upload CSV files containing the data from gene differential
      expression, please refer the format of input to example data
             )"),

      br(),

      # Input files
      tags$a(href = "https://github.com/wezhubb/DeregGenes/blob/master/inst/shiny-scripts/GSE29721.csv", "Example Dataset 1"),

      fileInput("input1", "Choose CSV File for gene differential expression data",
                accept = ".csv"),

      tags$p("Enter input class for above input file(default is given for example dataset 1), please seperate each using comma, no space"),
      textAreaInput(inputId = 'class1', label = 'class 1',
                    value = "mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control"),

      tags$a(href="https://github.com/wezhubb/DeregGenes/blob/master/inst/shiny-scripts/GSE84402.csv", "Example Dataset 2"),

      fileInput("input2", "Choose CSV File for gene differential expression data",
                accept = ".csv"),

      tags$p("Enter input class for above input file(default is given for example dataset 2), please seperate each using comma, no space"),
      textAreaInput(inputId = 'class2', label = 'class 2',
                    value = "mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control,mutant,control"),

      # Input padj cutoff
      textInput(inputId = "padj",
                label = "Enter padj cutoff (0 - 1)", "0.01"),

      # Input logFC cutoff
      textInput(inputId = "logFC",
                label = "Enter padj cutoff (above 0)", "1"),

      # action button
      actionButton(label = "start", inputId = "Start"),
      tags$p('analysis process might take 30s - 60s'),

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

    class <- as.vector(strsplit(input$class1, ',')[[1]])
    result1 <- DeregGenes::logFCsingle(i1, class)

    class <- as.vector(strsplit(input$class2, ',')[[1]])
    result2 <- DeregGenes::logFCsingle(i2, class)
    listLogFC <- list(result1, result2)
    listTitle <- c("GSE29721", "GSE84402")
    DeregGenes::Aggreg(listLogFC, listTitle, padj = as.numeric(input$padj), logFC = as.numeric(input$logFC))
  })


  # Plotting heatmap plots
  output$heatmap <- renderPlot({
    if (v$dothing == FALSE) return(NULL)
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
