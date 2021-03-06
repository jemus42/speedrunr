% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{find_records}
\alias{find_records}
\title{Classify Runs as WR}
\usage{
find_records(runs, by = "date")
}
\arguments{
\item{runs}{A \link[tibble:tibble]{tibble::tibble} of runs as returned by \link{get_runs}.}

\item{by}{Variable that determines record status, either \code{date} (default) for the date of
the run, or \code{submitted} for the time the run was submitted to speedrun.com.}
}
\value{
A modified \code{runs} \link[tibble:tibble-package]{tibble} with a boolean \code{record} variable.
}
\description{
Classify Runs as WR
}
\examples{
\dontrun{
runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o", max = 1000)
runs <- find_records(runs)
}
}
