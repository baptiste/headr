##' Format the abstract
##'
##' Read the metadata and inject the formatted abstract in a md document
##' @title hdr_abstract
##' @param meta metadata content
##' @return string
##' @import glue
##' @import yaml
##' @export
hdr_abstract <- function(meta = yaml::yaml.load_file("_metadata.yaml")){
  glue::glue_data(.x = meta, "\\\\abstract{<<abstract>>}", .open = "<<", .close = ">>")
}
