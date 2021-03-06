% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_games.R
\name{get_games}
\alias{get_games}
\title{Search for Games by Name}
\source{
\url{https://github.com/speedruncomorg/api/blob/master/version1/games.md#get-games}
}
\usage{
get_games(name = "", abbreviation = NULL, ...)
}
\arguments{
\item{name}{A search query, \code{character}.}

\item{abbreviation}{An exact abbreviation as listed on \href{https://speedrun.com}{speedrun.com}.
If this is set, \code{name} will be ignored.}

\item{...}{Other named parameters passed to the API.}
}
\value{
A \link[tibble:tibble-package]{tibble} with search results
}
\description{
Search for Games by Name
}
\examples{
\dontrun{
# Get all games matching Ocarina of Time
get_games(name = "Ocarina of Time")

# Or directly if you know its abbreviation is oot:
get_games(abbreviation = "oot")
}
}
