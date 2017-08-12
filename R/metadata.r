##' Format the metadata
##'
##' Read the metadata and inject the formatted string in a md document
##' @title hdr_metadata
##' @param meta metadata content
##' @param template journal-specific template 
##' @return string
##' @import glue
##' @import yaml
##' @export
hdr_metadata <- function(meta = yaml::yaml.load_file("_metadata.yaml"), template = template_journal_A){
  glue::collapse(unlist(lapply(template, do.call, list(meta=meta))), sep = "\n")
}

##  helper functions

##' @export
helper_affiliations <- function(a){
  aff <- sprintf("\\\\affiliation{%s}", a)
  if(length(a) == 1) return(aff) else aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
  glue::collapse(aff, "\n")
}

##' @export
helper_email <- function(email, corresponding){
  if(corresponding) sprintf("\\\\email{%s}", email) else ""
}




##' @export
fun_title <- function(meta) glue_data(meta, "\\\\title{<<title>>}", .open = "<<", .close = ">>")

##' @export
fun_authors <- function(meta) lapply(meta[["authors"]], 
                                     glue_data, 
                                     '\\\\author{<<name>>}
                                     <<headr::helper_affiliations(affiliation)>>
                                     <<headr::helper_email(email, corresponding)>>', 
                                     .open = "<<", .close = ">>")

##' @export
template_journal_A <- list(title = fun_title, authors = fun_authors)
