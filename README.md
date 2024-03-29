![](preview.gif)

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

pandoc provides a way to populate latex templates with custom metadata
stored in a human-readable yaml format. Unfortunately, the template
itself is coded in tex – not the easiest language to work with.

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

A standardised, human-readable format
-------------------------------------

We'll store the metadata in an external file, in `yaml` format.

    title: On physics and chemistry
    date: "\\today"

    authors:
      - name: Lise Meitner
        affiliation: [Kaiser Wilhelm Institute,
                    University of Berlin,
                    Manne Siegbahn Institute]
        collaboration: Wikipedia
        email: lise.meitner@institution.edu
        corresponding: true

      - name: Pierre Curie
        affiliation: École Normale Supérieure
        collaboration: Wikipedia
        email: pierre.curie@institution.edu
        homepage: https://en.wikipedia.org/wiki/Pierre_Curie
        corresponding: true

      - name: Marie Curie
        affiliation: [University of Paris,
                     Institut du Radium,
                     École Normale Supérieure]
        collaboration: Wikipedia
        email: marie.curie@institution.edu
        corresponding: false
        homepage: https://en.wikipedia.org/wiki/Marie_Curie
        phone: +123456
        fax: 123456

    thanks: Friends and colleagues
    keywords: [physics, science, everything]
    abbreviations: [UV,IR]
    pacs: [123, 456, 789] # https://publishing.aip.org/publishing/pacs
    ociscodes: [123, 456, 789] # https://www.osapublishing.org/submit/ocis
    preprint: APS/123-ABC

    abstract: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

This file can contain more information than needed, and is common to all
versions of the manuscript, regardless of the publisher's template. From
these data, we will populate the TeX macros relevant to a given LaTeX
template as needed.

Pre-defined templates
---------------------

The package defines 4 templates, shown below.

    glue::glue_collapse(purrr::invoke_map_chr(tpl_aps(), meta=meta), sep = "\n%\n")

    \title{On physics and chemistry}
    %
    \author{Lise Meitner}
    \affiliation{Kaiser Wilhelm Institute}
    \affiliation{University of Berlin}
    \affiliation{Manne Siegbahn Institute}
    \email{lise.meitner@institution.edu}
    \author{Pierre Curie}
    \affiliation{École Normale Supérieure}
    \email{pierre.curie@institution.edu}
    \author{Marie Curie}
    \affiliation{University of Paris}
    \affiliation{Institut du Radium}
    \affiliation{École Normale Supérieure}

    %
    \date{\today}
    %
    \pacs{123,456,789}
    \keywords{physics,science,everything}

    glue::glue_collapse(purrr::invoke_map_chr(tpl_acs(), meta=meta), sep = "\n%\n")

    \title{On physics and chemistry}
    %
    \author{Lise Meitner}
    \affiliation{Kaiser Wilhelm Institute}
    \alsoaffiliation{University of Berlin}
    \alsoaffiliation{Manne Siegbahn Institute}
    \email{lise.meitner@institution.edu}
    \author{Pierre Curie}
    \affiliation{École Normale Supérieure}
    \email{pierre.curie@institution.edu}
    \author{Marie Curie}
    \affiliation{University of Paris}
    \alsoaffiliation{Institut du Radium}
    \alsoaffiliation{École Normale Supérieure}

    %
    \date{\today}
    %
    \abbreviations{UV,IR}
    \keywords{physics,science,everything}

    glue::glue_collapse(purrr::invoke_map_chr(tpl_osa(), meta=meta), sep = "\n%\n")

    \title{On physics and chemistry}
    %
    \author[1,2,3]{Lise Meitner}
    \author[4]{Pierre Curie}
    \author[5,6,4]{Marie Curie}
    \affil[1]{Kaiser Wilhelm Institute}
    \affil[2]{University of Berlin}
    \affil[3]{Manne Siegbahn Institute}
    \affil[4]{École Normale Supérieure}
    \affil[5]{University of Paris}
    \affil[6]{Institut du Radium}
    %
    \dates{\today}
    %
    \ociscodes{123,456,789}

    glue::glue_collapse(purrr::invoke_map_chr(tpl_article(), meta=meta), sep = "\n%\n")

    \usepackage{authblk}
    %
    \title{On physics and chemistry}
    %
    \author[1,2,3]{Lise Meitner\thanks{lise.meitner@institution.edu}}
    \author[4]{Pierre Curie\thanks{pierre.curie@institution.edu}}
    \author[5,6,4]{Marie Curie}
    \affil[1]{Kaiser Wilhelm Institute}
    \affil[2]{University of Berlin}
    \affil[3]{Manne Siegbahn Institute}
    \affil[4]{École Normale Supérieure}
    \affil[5]{University of Paris}
    \affil[6]{Institut du Radium}
    %
    \date{\today}

TODO list
---------

-   use better fake names, phones etc. with charlatan package
    <https://github.com/ropensci/charlatan>
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
