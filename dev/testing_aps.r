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
  name <- glue::glue_data(.x = x, "\\\\author{<<name>>}", .open = "<<", .close = ">>")
  # format affiliation(s)
  aff <- glue::glue_data(.x = x, "\\\\affiliation{<<affiliation>>}", .open = "<<", .close = ">>")
  # email (if corresponding author)
  email <- if(x$corresponding) glue::glue_data(x, "\\\\email{<<email>>}", .open = "<<", .close = ">>") else ""
  glue::glue_collapse(c(name, aff, email), "\n")
}

fun_title <- function(meta) glue_data(meta, "\\\\title{<<title>>}", .open = "<<", .close = ">>")
fun_authors <- function(meta) glue::glue_collapse(unlist(lapply(meta$authors, helper_author)), "\n")
fun_extra <- function(meta) glue::glue_data(meta, "\n\\\\pacs{<<glue::glue_collapse(pacs,',')>>}\n\\\\keywords{<<glue::glue_collapse(keywords,',')>>}", .open = "<<", .close = ">>")
fun_date <- function(meta) glue_data(meta, "\\\\date{<<date>>}", .open = "<<", .close = ">>")


fun_title(meta)
fun_authors(meta)
fun_extra(meta)
fun_date(meta)
hdr_abstract(meta)
