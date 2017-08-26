##' @export
tpl_article <- function(){
  
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
    namelist[corresponding] <- Map(f = function(n,e) sprintf("%s\\\\thanks{%s}", n, e), 
                                   n=namelist[corresponding], e = emaillist[corresponding])
    
    names <- glue::collapse(Map(f = function(id, n) 
      glue::glue("\\\\author[{id}]{{{n}}}"),
      id=ids, n=namelist), sep = "\n")
    
    glue::collapse(c(names, affiliations), sep="\n")
    
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\\\title{<<title>>}")
  fun_date <- function(meta) helper_glue(meta, "\\\\date{<<date>>}")
  fun_extra <- function(meta) {"\\usepackage{authblk}"}
  
  list(extra = fun_extra, title = fun_title,  authors = fun_authors, date = fun_date)
  
}



