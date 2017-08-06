library(yaml)

meta <- yaml.load_file("_metadata.yaml")

unique(unlist(lapply(meta$authors, "[[", "affiliation")))

library(glue)
tpl_author <- '{name}\\n{paste(affiliation, collapse=", ")}'

lapply(meta[["authors"]], glue_data, tpl_author)

fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\author{{ {name} }}
                                     \\address{{ {collapse(affiliation, sep=", ")} }}')
fun_authors(meta)

preamble_journal1 <- list(title = fun_title, authors = fun_authors)


affiliations <- function(a=letters[1:3]){
  if(length(a) == 1) return(sprintf("\\affiliation{%s}", a)) else
    glue_data(a, 'paste(sprintf("\\\\affiliation{%s}", affiliation), collapse="\\n")')
}



fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\author{{ {name} }}
                                     { paste(sprintf("\\\\affiliation{%s}", affiliation), collapse="\\n") }')
preamble_journal2 <- list(title = fun_title, authors = fun_authors)

glue::collapse(unlist(lapply(preamble_journal2, do.call, list(meta=meta))), sep = "\n")



