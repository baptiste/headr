

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
  
  list(title = fun_title,  authors = fun_authors)
  
}


