library(shiny)

meta <- readLines("../inst/meta/_lotr.yaml")
default <- glue::collapse(meta, sep="\n")

shinyApp(
  #UI
  ui = fluidPage(
    fluidRow(
      column(6,
             textAreaInput("yaml", "Input metadata", value = default, 
                           width = '150%', rows = length(meta), resize = "both")),
        column(6, h5("TeX fragment"), verbatimTextOutput("tex"))
    ), 
    fluidRow(
      column(12, 
             textOutput("tex2")
      )
    )
  ),
  #Server
  server = function(input, output) {
    
    output$tex <- renderText({ 
      meta <- yaml::yaml.load(string = input$yaml)
      s <- glue::collapse(purrr::invoke_map_chr(tpl_acs(), meta=meta), sep = "\n%\n\n")
      
      s
    })
    
  }
)