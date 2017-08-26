setwd("~/Documents/github/headr/dev")

library(glue)
library(yaml)

meta <- yaml.load_file("_metadata.yaml")

# \usepackage{authblk}
# 
# \title{More than one Author with different Affiliations}
# \author[1,2]{Author A\thanks{A.A@university.edu}}
# \author[1]{Author B\thanks{B.B@university.edu}}
# \author[1]{Author C\thanks{C.C@university.edu}}
# \author[2]{Author D\thanks{D.D@university.edu}}
# \author[2]{Author E\thanks{E.E@university.edu}}
# \affil[1]{Department of Computer Science, \LaTeX\ University}
# \affil[2]{Department of Mechanical Engineering, \LaTeX\ University}


helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")

hdr_abstract <- function(meta){
  helper_glue(.x = meta, "<<abstract>>")
}

fun_authors <- function(meta){
  
  aff <- lapply(meta$authors, "[[", "affiliation")
  unique_aff <- unique(unlist(aff))
  affiliations <- glue::collapse(Map(f = function(id, a) 
    glue::glue("\\\\affil[{id}]{{{a}}}"),
    id=seq_along(unique_aff), a=unique_aff), sep = "\n")
  
  ids <- lapply(meta$authors, function(a) glue::collapse(match(a$affiliation, unique_aff), ","))
  
  namelist <- lapply(meta$authors, "[[", "name")
  emaillist <- lapply(meta$authors, "[[", "email")
  corresponding <- vapply(meta$authors, "[[", TRUE, "corresponding")
  namelist[corresponding] <- Map(f = function(n,e) sprintf("%s\\thanks{%s}", n, e), 
                                 n=namelist[corresponding], e = emaillist[corresponding])
  
  names <- glue::collapse(Map(f = function(id, n) 
    glue::glue("\\\\author[{id}]{{{n}}}"),
    id=ids, n=namelist), sep = "\n")
  
  glue::collapse(c(names, affiliations), "\n")
  
}

fun_title <- function(meta) helper_glue(meta, "\\\\title{<<title>>}")
fun_date <- function(meta) helper_glue(meta, "\\\\date{<<date>>}")
fun_extra <- function(meta) {"\\usepackage{authblk}"}


fun_title(meta)
fun_authors(meta)
fun_extra(meta)
fun_date(meta)
hdr_abstract(meta)
