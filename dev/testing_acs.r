setwd("~/Documents/github/headr/dev")

library(glue)
library(yaml)

meta <- yaml.load_file("_metadata.yaml")

helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")

hdr_abstract <- function(meta){
  helper_glue(.x = meta, "<<abstract>>")
}

helper_author <- function(x) {
  
  # format name
  name <- helper_glue(.x = x, "\\\\author{<<name>>}")
  
  # format affiliation(s)
  aff <- helper_glue(.x = x, "\\\\affiliation{<<affiliation>>}")
  if(length(x) > 1) aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
  
  # email (if corresponding author)
  email <- if(x$corresponding) helper_glue(x, "\\\\email{<<email>>}") else ""
  
  glue::collapse(c(name, aff, email), "\n")
}

fun_title <- function(meta) helper_glue(meta, "\\\\title{<<title>>}")
fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
fun_extra <- function(meta) helper_glue(meta, "\n\\\\abbreviations{<<glue::collapse(abbreviations,',')>>}\n\\\\keywords{<<glue::collapse(keywords,',')>>}")
fun_date <- function(meta) helper_glue(meta, "\\\\date{<<date>>}")


fun_title(meta)
fun_authors(meta)
fun_extra(meta)
fun_date(meta)
hdr_abstract(meta)
