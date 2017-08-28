library(shiny)
library(glue)
# library(headr)

source("selfcontained.R")

meta <- readLines("_lotr.yaml")
default <- glue::collapse(meta, sep="\n")


shinyApp(
  #UI
  ui = fluidPage(fluidRow(
      column(8,
             textAreaInput("yaml", "Input metadata", value = default, 
                           cols=80, rows = length(meta), resize = "vertical")),
      column(4, selectInput("tpl", label = h5("TeX fragment"), 
                            choices = list("acs" = 1, 
                                           "aps" = 2, 
                                           "osa" = 3, 
                                           "article" = 4), selected = 4),
             verbatimTextOutput("tex"),
             downloadButton('downloadFragment', 'Download fragment'))
    
  )),
  #Server
  server = function(input, output) {
    
    output$tex <- renderText({ 
      meta <- yaml::yaml.load(string = input$yaml)
      
      tpl <- match.fun(paste0("tpl_", c("acs","aps","osa","article")[as.numeric(input$tpl)]))
      s <- glue::collapse(purrr::invoke_map_chr(tpl(), meta=meta), sep = "\n%\n\n")
      
      s
    })
    
    output$downloadFragment <- downloadHandler(
      filename = function() { paste0("frag_", c("acs","aps","osa","article")[as.numeric(input$tpl)],'.tex') },
      content = function(file) {
        
        meta <- yaml::yaml.load(string = input$yaml)
        
        tpl <- match.fun(paste0("tpl_", c("acs","aps","osa","article")[as.numeric(input$tpl)]))
        s <- glue::collapse(purrr::invoke_map_chr(tpl(), meta=meta), sep = "\n%\n\n")
        writeLines(s, file)
      }
    )
    
  }
)