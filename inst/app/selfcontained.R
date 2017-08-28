##' @export
helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")


tpl_acs <- function(){
  
  helper_author <- function(x) {
    
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\affiliation{<<affiliation>>}")
    if(length(x) > 1) aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
    
    info <- c(name, aff)
    # email (if corresponding author)
    if(x$corresponding) info <- c(info, helper_glue(x, "\\email{<<email>>}"))
    if(!is.null(x$phone)) info <- c(info, helper_glue(x, "\\phone{<<phone>>}"))
    if(!is.null(x$fax)) info <- c(info, helper_glue(x, "\\fax{<<fax>>}"))
    if(!is.null(x$note)) info <- c(info, helper_glue(x, "\\altaffiliation{<<note>>}"))
    
    glue::collapse(info, "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\abbreviations{<<glue::collapse(abbreviations,',')>>}\n\\keywords{<<glue::collapse(keywords,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}

tpl_acs_jpcl <- tpl_acs_nanoletters <- tpl_acs_photonics <- 
  tpl_acs_nano <- tpl_acs_omega <- tpl_acs 

##' @export
tpl_aps <- function(){
  
  helper_author <- function(x) {
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\affiliation{<<affiliation>>}")
    
    info <- c(name, aff)
    # email (if corresponding author)
    if(x$corresponding) info <- c(info, helper_glue(x, "\\email{<<email>>}"))
    if(!is.null(x$homepage)) info <- c(info, helper_glue(x, "\\homepage{<<homepage>>}"))
    if(!is.null(x$collaboration)) info <- c(info, helper_glue(x, "\\collaboration{<<collaboration>>}"))
    if(!is.null(x$note)) info <- c(info, helper_glue(x, "\\altaffiliation{<<note>>}"))
    
    glue::collapse(info, "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\pacs{<<glue::collapse(pacs,',')>>}\n\\keywords{<<glue::collapse(keywords,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}

tpl_aps_pra <- tpl_aps_prb <- tpl_aps_pre <- tpl_aps_prl <- tpl_aps_prx <- tpl_aps
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

tpl_osa_optica <- tpl_osa_josab <- tpl_osa_ol <- tpl_osa



tpl_iop <- function(){
  
  helper_author <- function(x) {
    
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\address{<<affiliation>>}")
    
    info <- c(name, aff)
    # email (if corresponding author)
    if(x$corresponding) info <- c(info, helper_glue(x, "\\ead{<<email>>}"))
    
    glue::collapse(info, "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\pacs{<<glue::collapse(pacs,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}


