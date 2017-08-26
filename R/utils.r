##' @export
helper_glue <- function(...) glue::glue_data(..., .open = "<<", .close = ">>")
