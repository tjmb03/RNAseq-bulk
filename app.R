library(shiny)
library(DESeq2)
library(DT)
library(data.table)
library(dplyr)

# UI
ui <- fluidPage(
  titlePanel("DESeq2 Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("countdata", "Upload gene count data (CSV format)", accept = ".csv"),
      fileInput("sampletable", "Upload sample table (CSV format)", accept = ".csv"),
      selectInput("treatmentfactor", "Select treatment factor", choices = NULL),
      selectInput("contrast", "Select contrast", choices = NULL, multiple = TRUE),
      actionButton("runanalysis", "Run DESeq2 Analysis"),
      downloadButton("downloadTable", "Download Results")
    ),
    
    mainPanel(
      dataTableOutput("resultTable")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Reactive expression for uploaded count data
  uploadedCountData <- reactive({
    if (is.null(input$countdata)) return(NULL)
    
    infile <- input$countdata
    read.csv(infile$datapath, header = TRUE, row.names = 1)
  })
  
  # Reactive expression for uploaded sample table
  uploadedSampleTable <- reactive({
    if (is.null(input$sampletable)) return(NULL)
    
    infile <- input$sampletable
    read.csv(infile$datapath, header = TRUE)
  })
  
  # Update treatment factor choices based on sample table
  observeEvent(uploadedSampleTable(), {
    sampleTable <- uploadedSampleTable()
    if (!is.null(sampleTable)) {
      updateSelectInput(session, "treatmentfactor", choices = colnames(sampleTable))
    }
  })
  
  # Update contrast choices based on treatment factor
  observeEvent(input$treatmentfactor, {
    sampleTable <- uploadedSampleTable()
    if (!is.null(sampleTable)) {
      treatmentFactor <- input$treatmentfactor
      factorLevels <- unique(sampleTable[[treatmentFactor]])
      updateSelectInput(session, "contrast", choices = factorLevels)
    }
  })
  
  
  # Perform DESeq2 analysis
  runAnalysis <- eventReactive(input$runanalysis, {
    countData <- uploadedCountData()
    sampleTable <- uploadedSampleTable()
    
    if (is.null(countData) || is.null(sampleTable)) return(NULL)
    
    treatmentFactor <- input$treatmentfactor
    contrastLevels <- input$contrast
    View(contrastLevels)
    
    # Check if treatment factor and contrast levels exist in sample table
    if (!(treatmentFactor %in% colnames(sampleTable)) || any(!(contrastLevels %in% unique(sampleTable[[treatmentFactor]])))) {
      return(NULL)  # Return NULL if treatment factor or contrast levels are not found
    }
    
    # Create DESeq2 object
    dd <- DESeqDataSetFromMatrix(countData = countData, colData = sampleTable, design = as.formula(paste("~", treatmentFactor)))
    
    # Run DESeq2 analysis
    dds <- DESeq(dd)
    
    # Get differential expression results with specified contrast
    results <- lapply(contrastLevels, function(contrast) {
      contrastVector <- c(treatmentFactor, contrast, 'low')  
      res <- results(dds, contrast = contrastVector)
      res$pvalue <- p.adjust(res$pvalue, method = "BH")
      as.data.frame(res)
    })
    
    # Combine all result data.frames into a single table
    # View(results) 
    resultTable <- do.call(rbind, results)
    
    # Return the result table
    resultTable
  })
  
  output$resultTable <- renderDataTable({
    runAnalysis()
  })
  
  # Generate a downloadable CSV file of the result table
  output$downloadTable <- downloadHandler(
    filename = function() {
      "deseq2_results.csv"
    },
    content = function(file) {
      resultTable <- runAnalysis()
      if (!is.null(resultTable)) {
        write.csv(resultTable, file, row.names = FALSE)
      }
    }
  )
  
}

# Run the application
shinyApp(ui = ui, server = server)
