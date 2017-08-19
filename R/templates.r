##' @export
tpl_aps <- function(){
  
  ##  helper functions
  
  helper_author <- function(x) {
    
    # format name
    name <- glue::glue_data(.x = x, "\\\\author{<<name>>}", .open = "<<", .close = ">>")
    
    # format affiliation(s)
    aff <- glue::glue_data(.x = x, "\\\\affiliation{<<affiliation>>}", .open = "<<", .close = ">>")

    # email (if corresponding author)
    email <- if(x$corresponding) glue::glue_data(x, "\\\\email{<<email>>}", .open = "<<", .close = ">>") else ""
    
    glue::collapse(c(name, aff, email), "\n")
  }
  
  fun_title <- function(meta) glue_data(meta, "\\\\title{<<title>>}", .open = "<<", .close = ">>")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) glue::glue_data(meta, "\n\\\\pacs{<<glue::collapse(pacs,',')>>}\n
                                              \\\\keywords{<<glue::collapse(keywords,',')>>}", .open = "<<", .close = ">>")
  fun_date <- function(meta) glue_data(meta, "\\\\date{<<date>>}", .open = "<<", .close = ">>")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}

##' @export
tpl_acs <- function(){
  
  ##  helper functions
  
  helper_author <- function(x) {
    
    # format name
    name <- glue::glue_data(.x = x, "\\\\author{<<name>>}", .open = "<<", .close = ">>")
    
    # format affiliation(s)
    aff <- glue::glue_data(.x = x, "\\\\affiliation{<<affiliation>>}", .open = "<<", .close = ">>")
    if(length(x) > 1) aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
    
    # email (if corresponding author)
    email <- if(x$corresponding) glue::glue_data(x, "\\\\email{<<email>>}", .open = "<<", .close = ">>") else ""
    
    glue::collapse(c(name, aff, email), "\n")
  }
  
  fun_title <- function(meta) glue_data(meta, "\\\\title{<<title>>}", .open = "<<", .close = ">>")
  fun_authors <- function(meta) glue::collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) glue::glue_data(meta, "\n\\\\abbreviations{<<glue::collapse(abbreviations,',')>>}\n
                                              \\\\keywords{<<glue::collapse(keywords,',')>>}", .open = "<<", .close = ">>")
  fun_date <- function(meta) glue_data(meta, "\\\\date{<<date>>}", .open = "<<", .close = ">>")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}


##' @export
tpl_osa <- function(){
  
  ##  helper functions
  
  
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
  
  fun_title <- function(meta) glue_data(meta, "\\\\title{<<title>>}", .open = "<<", .close = ">>")
  
  fun_date <- function(meta) glue_data(meta, "\\\\dates{<<date>>}", .open = "<<", .close = ">>")
  
  # fun_extra <- function(meta) glue::glue_data(meta, "\\\\keywords{<<glue::collapse(keywords,',')>>}", .open = "<<", .close = ">>")

  list(title = fun_title,  authors = fun_authors, date = fun_date)
  
}



