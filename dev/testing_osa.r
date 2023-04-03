setwd("~/Documents/github/headr/dev")

library(glue)
library(yaml)

meta <- yaml.load_file("_metadata.yaml")

helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")

hdr_abstract <- function(meta){
  helper_glue(.x = meta, "<<abstract>>")
}

fun_authors <- function(meta){
  
  aff <- lapply(meta$authors, "[[", "affiliation")
  unique_aff <- unique(unlist(aff))
  affiliations <- glue::glue_collapse(Map(f = function(id, a) 
    glue::glue("\\\\affil[{id}]{{{a}}}"),
    id=seq_along(unique_aff), a=unique_aff), sep = "\n")
  
  ids <- lapply(meta$authors, function(a) glue::glue_collapse(match(a$affiliation, unique_aff), ","))
  
  names <- glue::glue_collapse(Map(f = function(id, n) 
    glue::glue("\\\\author[{id}]{{{n}}}"),
    id=ids, n=lapply(meta$authors, "[[", "name")), sep = "\n")
  
  glue::glue_collapse(c(names, affiliations), "\n")
  
}

fun_title <- function(meta) helper_glue(meta, "\\\\title{<<title>>}")
fun_date <- function(meta) helper_glue(meta, "\\\\dates{<<date>>}")
fun_extra <- function(meta) helper_glue(meta, "\n\\\\pacs{<<glue::glue_collapse(pacs,',')>>}\n\\\\keywords{<<glue::glue_collapse(keywords,',')>>}")


fun_title(meta)
fun_authors(meta)
fun_extra(meta)
fun_date(meta)
hdr_abstract(meta)
