##' @export
tpl_aps <- function(){
  
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
  fun_extra <- function(meta) glue::glue_data(meta, "\n\\\\pacs{<<glue::collapse(pacs,',')>>}\n\\\\keywords{<<glue::collapse(keywords,',')>>}", .open = "<<", .close = ">>")
  fun_date <- function(meta) glue_data(meta, "\\\\date{<<date>>}", .open = "<<", .close = ">>")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}
