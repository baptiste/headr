The problem with LaTeX templates
--------------------------------

Practically every journal supplying a LaTeX template defines its own
custom macros for author affiliations and other metadata, with very
little consistency from one publisher to another. This renders the
process of re-submitting a manuscript to a new journal really
cumbersome. Consider the following two examples:

**OSA**

    \title{Manuscript Title}

    \author[1,2,3]{Author One}
    \author[2,*]{Author Two}

    \affil[1]{First address}
    \affil[2]{Second address}
    \affil[3]{Third address}

    \affil[*]{Corresponding author: email@my-email.com}
    \dates{Compiled \today}
    \ociscodes{(140.3490) Lasers, distributed feedback; (060.2420) Fibers.}

**ACS**

    \title{Manuscript title}

    \author{Author One}
    \affiliation{First address}
    \alsoaffiliation{Second address}
    \email{email@my-email.com}

    \author{Author Two} 
    \phone{+123456789}
    \fax{+123456789}
    \email{email@my-email.com}
    \affiliation{First address}
    \alsoaffiliation{Second address}
    \alsoaffiliation{Third address}

    \abbreviations{IR,NMR,UV}
    \keywords{American Chemical Society}

The pandoc way
--------------

pandoc provides a way to populate latex templates with custom metadata stored in a human-readable yaml format. Unfortunately, the template itself is coded in tex – not the easiest language to work with.

```
$if(abstract)$
\abstract{%
$abstract$
}
$endif$

$body$

$for(author)$
\address{%
$author.name$\\
$author.affiliation$\\
$for(author.address)$$author.address$$sep$\\ $endfor$\\
}
$if(author.email)$$author.email$$endif$

$endfor$
```

A standardised, human-readable format
-------------------------------------

We'll store the metadata in an external file, in `yaml` format.

    title: On physics and chemistry

    authors:
      - name: Lise Meitner
        affiliation: [Kaiser Wilhelm Institute,
                    University of Berlin,
                    Manne Siegbahn Institute]
        email: lise.meitner@institution.edu

      - name: Pierre Curie
        affiliation: École Normale Supérieure
        email: pierre.curie@institution.edu
        homepage: https://en.wikipedia.org/wiki/Pierre_Curie
        
      - name: Marie Curie
        affiliation: [University of Paris,
                     Institut du Radium,
                     École Normale Supérieure]
        email: marie.curie@institution.edu
        homepage: https://en.wikipedia.org/wiki/Marie_Curie
        phone: +123456
        fax: 123456

    collaboration: Wikipedia
    thanks: Friends and colleagues
    keywords: [physics, science, everything]
    abbreviations: [UV,IR]
    pacs: [123, 456, 789] # https://publishing.aip.org/publishing/pacs
    ociscodes: [123, 456, 789] # https://www.osapublishing.org/submit/ocis
    preprint: APS/123-ABC

This file can contain more information than needed, and is common to all
versions of the manuscript, regardless of the publisher's template. From
these data, we will populate the TeX macros relevant to a given LaTeX
template as needed.

Below's a partial example to illustrate the process.

    library(yaml)
    library(glue)

    meta <- yaml.load_file("_metadata.yaml")

    helper_affiliations <- function(a){
      
      aff <- sprintf("\\affiliation{%s}", a)
      
      if(length(a) == 1) return(aff) else aff[-1] <- gsub("affiliation", "alsoaffiliation", aff[-1])
        glue::collapse(aff, "\n")
    }


    fun_title <- function(meta) glue_data(meta, "\\title{{ {title} }}") 
    fun_authors <- function(meta) lapply(meta[["authors"]], 
                                         glue_data, 
                                         '\\author{{ {name} }}
                                         {helper_affiliations(affiliation)}')

    preamble_journal <- list(title = fun_title, authors = fun_authors)

    glue::collapse(unlist(lapply(preamble_journal, do.call, list(meta=meta))), sep = "\n")

    \title{ On physics and chemistry }
    \author{ Lise Meitner }
    \affiliation{Kaiser Wilhelm Institute}
    \alsoaffiliation{University of Berlin}
    \alsoaffiliation{Manne Siegbahn Institute}
    \author{ Pierre Curie }
    \affiliation{École Normale Supérieure}
    \author{ Marie Curie }
    \affiliation{University of Paris}
    \alsoaffiliation{Institut du Radium}
    \alsoaffiliation{École Normale Supérieure}

TODO list
---------

-   compile a list of LaTeX templates
-   turn them into glue templates
-   fine-tune the glueing process (line breaks, missing values, strange
    characters, etc.)
-   wrap into a package (cf Rticles)
-   make a Rstudio add-in
-   figure out where this fits in the rmarkdown + pandoc templates side
    of things (need to inject a R-processed `$meta-header$` into the
    template, but before knitting -- somewhat incompatible with a single
    pass?)
-   consider alternative languages (Haskell, javascript, TeX seem
    obvious candidates)
