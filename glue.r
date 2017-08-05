# install.packages('whisker')
# devtools::install_github("tidyverse/glue")

library(whisker)

template= 'Hello {{name}}
You have just won ${{value}}!
'

data <- list( name = "Chris", value= 124)

whisker.render(template, data)

library(glue)

wrap <- function(name, value) {
  glue('Hello {name} You have just won ${value}!')
}

library(purrr)
data <- list( name = "Chris", value= 124)
purrr::pmap(data, wrap)
do.call(wrap, data)
do.call(wrap, data[-1])

library(glue)
glue_data(template, .x=data)
glue_data(template, .x=data[-1])
template <- 'Hello {name} You have just won ${value}!'
data <- list( name = "Chris", value= 124)
do.call(glue, list(template, .envir=as.environment(data)))
# Hello Chris You have just won $124!
do.call(glue, list(template, .envir=as.environment(data[-1])))
# Error in eval(expr, envir, enclos) : object 'name' not found

