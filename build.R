#! /usr/bin/env Rscript

if (!("usethis" %in% installed.packages())) install.packages("usethis")
if (!("devtools" %in% installed.packages())) install.packages("devtools")
if (!("pkgdown" %in% installed.packages())) install.packages("pkgdown")
if (!("git2r" %in% installed.packages())) install.packages("git2r")

usethis::use_tidy_style()
usethis::use_tidy_description()
source("data-raw/update_data.R")
devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build()
devtools::reload()
devtools::test()
pkgdown::build_site()

repo <- git2r::repository(".")
git2r::add(repo, "*")
git2r::commit(repo, message = "Rebuild everything", all = TRUE)
