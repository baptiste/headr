##' @export
tpl_osa <- function(){
  
  fun_authors <- function(meta){
    
    aff <- lapply(meta$authors, "[[", "affiliation")
    unique_aff <- unique(unlist(aff))
    affiliations <- glue::collapse(Map(f = function(id, a) 
      glue::glue("\\\\affil[{id}]{{{a}}}"),
      id=seq_along(unique_aff), a=unique_aff), sep = "\n")
    
    ids <- lapply(meta$authors, function(a) glue::collapse(match(a$affiliation, unique_aff), ","))
    
    names <- glue::collapse(Map(f = function(id, n) 
      glue::glue("\\\\author[{id}]{{{n}}}"),
      id=ids, n=lapply(meta$authors, "[[", "name")), sep = "\n")
    
    glue::collapse(c(names, affiliations), "\n")
    
  }
  
  
  fun_title <- function(meta) helper_glue(meta, "\\\\title{<<title>>}")
  fun_date <- function(meta) helper_glue(meta, "\\\\dates{<<date>>}")
  fun_extra <- function(meta) helper_glue(meta, "\n\\\\pacs{<<glue::collapse(pacs,',')>>}\n\\\\keywords{<<glue::collapse(keywords,',')>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}



