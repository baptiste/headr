setwd("~/Documents/github/headr/dev")

library(headr)

meta <- yaml::yaml.load_file("_metadata.yaml")

glue::glue_collapse(purrr::invoke_map_chr(tpl_article(), meta=meta), sep = "\n%\n")
glue::glue_collapse(purrr::invoke_map_chr(tpl_aps(), meta=meta), sep = "\n%\n")
glue::glue_collapse(purrr::invoke_map_chr(tpl_acs(), meta=meta), sep = "\n%\n")
glue::glue_collapse(purrr::invoke_map_chr(tpl_osa(), meta=meta), sep = "\n%\n")
