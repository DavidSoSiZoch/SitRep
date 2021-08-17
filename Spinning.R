library(knitr)

getwd()

s = system.file("R/MarkdownCreation.R", package = "knitr")
spin("R/MarkdownCreation.R")  # default markdown