##' @export
helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")


tpl_acs <- function(){
  
  helper_author <- function(x) {
    
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\affiliation{<<affiliation>>}")
    if(length(x) > 1) aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
    
    # email (if corresponding author)
    email <- if(x$corresponding) helper_glue(x, "\\email{<<email>>}") else ""
    
    glue::collapse(c(name, aff, email), "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\abbreviations{<<glue::collapse(abbreviations,',')>>}\n\\keywords{<<glue::collapse(keywords,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}

##' @export
tpl_aps <- function(){
  
  helper_author <- function(x) {
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\affiliation{<<affiliation>>}")
    # email (if corresponding author)
    email <- if(x$corresponding) helper_glue(x, "\\email{<<email>>}") else ""
    glue::collapse(c(name, aff, email), "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\pacs{<<glue::collapse(pacs,',')>>}\n\\keywords{<<glue::collapse(keywords,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}


##' @export
tpl_article <- function(){
  
  fun_authors <- function(meta){
    
    aff <- lapply(meta$authors, "[[", "affiliation")
    unique_aff <- unique(unlist(aff))
    affiliations <- glue::collapse(Map(f = function(id, a) 
      glue::glue("\\affil[{id}]{{{a}}}"),
      id=seq_along(unique_aff), a=unique_aff), sep = "\n")
    
    ids <- lapply(meta$authors, function(a) glue::collapse(match(a$affiliation, unique_aff), ","))
    
    namelist <- lapply(meta$authors, "[[", "name")
    emaillist <- lapply(meta$authors, "[[", "email")
    corresponding <- vapply(meta$authors, "[[", TRUE, "corresponding")
    namelist[corresponding] <- Map(f = function(n,e) sprintf("%s\\thanks{%s}", n, e), 
                                   n=namelist[corresponding], e = emaillist[corresponding])
    
    names <- glue::collapse(Map(f = function(id, n) 
      glue::glue("\\author[{id}]{{{n}}}"),
      id=ids, n=namelist), sep = "\n")
    
    glue::collapse(c(names, affiliations), sep="\n")
    
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  fun_extra <- function(meta) {"\\usepackage{authblk}"}
  
  list(extra = fun_extra, title = fun_title,  authors = fun_authors, date = fun_date)
  
}

##' @export
tpl_osa <- function(){
  
  fun_authors <- function(meta){
    
    aff <- lapply(meta$authors, "[[", "affiliation")
    unique_aff <- unique(unlist(aff))
    affiliations <- glue::collapse(Map(f = function(id, a) 
      glue::glue("\\affil[{id}]{{{a}}}"),
      id=seq_along(unique_aff), a=unique_aff), sep = "\n")
    
    ids <- lapply(meta$authors, function(a) glue::collapse(match(a$affiliation, unique_aff), ","))
    
    names <- glue::collapse(Map(f = function(id, n) 
      glue::glue("\\author[{id}]{{{n}}}"),
      id=ids, n=lapply(meta$authors, "[[", "name")), sep = "\n")
    
    glue::collapse(c(names, affiliations), "\n")
    
  }
  
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_date <- function(meta) helper_glue(meta, "\\dates{<<date>>}")
  fun_extra <- function(meta) helper_glue(meta, "\n\\ociscodes{<<glue::collapse(ociscodes,',')>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}






