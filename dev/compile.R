setwd("~/Documents/github/headr/dev")
library(headr)
# list of templates
tl <- c("acs","aps","osa","article")

# list of metadata
tm <- c("lotr","curie","raman")

library(tidyr)
combs <- crossing(t = tl, m = tm)


process <- function(t, m){
  fun <- match.fun(paste0("tpl_", t))
  meta <- yaml::yaml.load_file(paste0("../inst/meta/_",m,".yaml")) 
  s <- glue::glue_collapse(purrr::invoke_map_chr(fun(), meta=meta), sep = "\n%\n")
  frag <- paste0("_",t,"_",m,"_frag.tex")
  cat(s, file = frag)
  
  tf <- glue::glue_collapse(readLines(paste0("../inst/meta/_",t,".tex")), sep="\n")
  newtext <- gsub("\\$metadata\\$", paste0("\\\\input{",frag,"}"), tf)
  newtext <- gsub("\\$body\\$", "\\\\lipsum[2-6]", newtext)
  newtext <- gsub("\\$abstract\\$", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua.", newtext)
  out <- paste0("_",t,"_",m,".tex")
  writeLines(text = newtext, out)
  # try(system(paste0("xelatex -halt-on-error -interaction=nonstopmode ", out)))
  pdf <- gsub("tex","pdf[0]", out)
  png <- gsub("tex","png", out)
  # try(system(paste("convert -colorspace rgb -density 400 ", pdf, png)))
  
}


library(purrr)
pwalk(.l = combs, .f = process)


# 
# library(png)
# library(grid)
# library(gridExtra)
# 
# lf <- list.files(pattern = "png")
# lr <- lapply(lf, readPNG, native=TRUE)
# lg <- lapply(lr, rasterGrob)
# 
# # ggplot2::ggsave("preview.png", arrangeGrob(grobs = lg, ncol=3), width=6, height=6)
