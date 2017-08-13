
# \title{Manuscript title}
# 
# \author{Author One}
# \affiliation{First address}
# \alsoaffiliation{Second address}
# \email{email@my-email.com}
# 
# \author{Author Two} 
# \phone{+123456789}
# \fax{+123456789}
# \email{email@my-email.com}
# \affiliation{First address}
# \alsoaffiliation{Second address}
# \alsoaffiliation{Third address}
# 
# \abbreviations{IR,NMR,UV}
# \keywords{American Chemical Society}
##' @export
template_journal_A <- function(){
  
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
  
  list(title = fun_title,  authors = fun_authors, extra = fun_extra)
  
}


# \title{Manuscript Title}
# 
# \author[1,2,3]{Author One}
# \author[2,*]{Author Two}
# 
# \affil[1]{First address}
# \affil[2]{Second address}
# \affil[3]{Third address}
# 
# \affil[*]{Corresponding author: email@my-email.com}
# \dates{Compiled \today}
# \ociscodes{(140.3490) Lasers, distributed feedback; (060.2420) Fibers.}
##' @export
template_journal_B <- function(){
  
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

  fun_extra <- function(meta) glue::glue_data(meta, "\n\\\\abbreviations{<<glue::collapse(abbreviations,',')>>}\n
                                              \\\\keywords{<<glue::collapse(keywords,',')>>}", .open = "<<", .close = ">>")
  
  list(title = fun_title,  authors = fun_authors, extra = fun_extra)
  
}



