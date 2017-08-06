The problem with LaTeX templates
--------------------------------

Practically every journal supplying a TeX template defines its own
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
