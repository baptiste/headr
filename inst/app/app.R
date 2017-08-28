library(shiny)
library(glue)
# library(headr)

source("selfcontained.R")

escapeBS <- function (string) 
{
  gsub("\\\\", "\\\\\\\\\\", string)
}

meta <- readLines("_lotr.yaml")
default <- glue::collapse(meta, sep="\n")
# tpl_acs_jpcl <- tpl_acs_nanoletters <- tpl_acs_photonics <- 
#   tpl_acs_nano <- tpl_acs_omega

choices <- c("acs_jpcl", 
     "acs_nano",  
     "acs_nanoletters",
     "acs_omega", 
     "acs_photonics", 
     "aip", 
     "aps_pra", 
     "aps_prb", 
     "aps_pre",  
     "aps_prl",
     "aps_prx",
     "osa_optica", 
     "osa_josab", 
     "osa_ol", 
     "iop", 
     "article")

shinyApp(
  #UI
  ui = fluidPage(fluidRow(
      column(6,
             textAreaInput("yaml", "Input metadata (yaml format)", value = default, 
                           width=600, rows = length(meta), resize = "vertical")),
      column(6, selectInput("tpl", label = NULL, 
                            choices = setNames(seq_along(choices), choices), selected = 8),
             verbatimTextOutput("tex"),
             downloadButton('downloadFragment', 'Download fragment'),
             downloadButton('downloadTemplate', 'Download template'))
    
  )),
  #Server
  server = function(input, output) {
    
    output$tex <- renderText({ 
      meta <- yaml::yaml.load(string = input$yaml)
      
      tpl <- match.fun(paste0("tpl_", choices[as.numeric(input$tpl)]))
      s <- glue::collapse(purrr::invoke_map_chr(tpl(), meta=meta), sep = "\n%\n")
      
      s
    })
    
    output$downloadFragment <- downloadHandler(
      filename = function() { paste0("frag_", choices[as.numeric(input$tpl)],'.tex') },
      content = function(file) {
        
        meta <- yaml::yaml.load(string = input$yaml)
        
        tpl <- match.fun(paste0("tpl_", choices[as.numeric(input$tpl)]))
        s <- glue::collapse(purrr::invoke_map_chr(tpl(), meta=meta), sep = "\n%\n")
        writeLines(s, file)
      }
    )
    
    
    output$downloadTemplate <- downloadHandler(
      filename = function() { paste0("manuscript_", choices[as.numeric(input$tpl)],'.tex') },
      content = function(file) {
        
        meta <- yaml::yaml.load(string = input$yaml)
        
        tpl <- match.fun(paste0("tpl_", choices[as.numeric(input$tpl)]))
        s <- glue::collapse(purrr::invoke_map_chr(tpl(), meta=meta), sep = "\n%\n")
        template <- readLines(paste0("templates/", choices[as.numeric(input$tpl)],".tex"))
        writeLines(gsub("\\$metadata\\$", escapeBS(s), collapse(template, sep = "\n")), file)
        # writeLines(s, file)
      }
    )
  }
)