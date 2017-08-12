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



helper_affiliations <- function(a){
  aff <- sprintf("\\affiliation{%s}", a)
  
  if(length(a) == 1) return(aff) else aff[-1] <- gsub("affiliation", "altaffiliation", aff[-1])
    glue::collapse(aff, "\n")
}


fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\author{{ {name} }}
                                     {helper_affiliations(affiliation)}')
preamble_journal2 <- list(title = fun_title, authors = fun_authors)

glue::collapse(unlist(lapply(preamble_journal2, do.call, list(meta=meta))), sep = "\n")



