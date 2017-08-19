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
hdr_metadata <- function(meta = yaml::yaml.load_file("_metadata.yaml"), template = tpl_aps()){
  glue::collapse(unlist(lapply(template, do.call, list(meta=meta))), sep = "\\n")
}

