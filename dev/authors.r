library(yaml)

meta <- yaml.load_file("_metadata.yaml")

library(glue)

helper_author <- function(x) {
  name <- glue::glue_data(.x = x, "\\\\author{<<name>>}", .open = "<<", .close = ">>")
  aff <- glue::glue_data(.x = x, "\\\\affiliation{<<affiliation>>}", .open = "<<", .close = ">>")
  if(length(x) == 1) return(aff) else aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
  glue::glue_collapse(c(name, aff), "\n")
}

glue::glue_collapse(unlist(lapply(meta$authors, helper_author)), "\n")

lapply(meta[["authors"]], glue_data, tpl_author)

fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\author{{ {name} }}
                                     \\address{{ {glue_collapse(affiliation, sep=", ")} }}')
fun_authors(meta)

preamble_journal1 <- list(title = fun_title, authors = fun_authors)



helper_affiliations <- function(a){
  aff <- sprintf("\\affiliation{%s}", a)
  
  if(length(a) == 1) return(aff) else aff[-1] <- gsub("affiliation", "altaffiliation", aff[-1])
    glue::glue_collapse(aff, "\n")
}


fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\author{{ {name} }}
                                     {helper_affiliations(affiliation)}')
preamble_journal2 <- list(title = fun_title, authors = fun_authors)

glue::glue_collapse(unlist(lapply(preamble_journal2, do.call, list(meta=meta))), sep = "\n")



