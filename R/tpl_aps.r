##' @export
tpl_aps <- function(){
  
  helper_author <- function(x) {
    # format name
    name <- helper_glue(.x = x, "\\author{<<name>>}")
    # format affiliation(s)
    aff <- helper_glue(.x = x, "\\affiliation{<<affiliation>>}")
    # email (if corresponding author)
    email <- if(x$corresponding) helper_glue(x, "\\email{<<email>>}") else ""
    glue::glue_collapse(c(name, aff, email), "\n")
  }
  
  fun_title <- function(meta) helper_glue(meta, "\\title{<<title>>}")
  fun_authors <- function(meta) glue::glue_collapse(unlist(lapply(meta$authors, helper_author)), "\n")
  fun_extra <- function(meta) helper_glue(meta, "\n\\pacs{<<glue::glue_collapse(pacs,',')>>}\n\\keywords{<<glue::glue_collapse(keywords,',')>>}")
  fun_date <- function(meta) helper_glue(meta, "\\date{<<date>>}")
  
  list(title = fun_title,  authors = fun_authors, date = fun_date, extra = fun_extra)
  
}
