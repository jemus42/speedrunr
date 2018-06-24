#' Search for Games by Name
#'
#' @param name A search query, `character`.
#' @param abbreviation An exact abbreviation as listed on [speedrun.com](https://speedrun.com).
#'        If this is set, `name` will be ignored.
#' @param ... Other named parameters passed to the API.
#'
#' @return A [tibble::tibble] with search results
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/games.md#get-games>
#' @examples
#' \dontrun{
#' get_games("Ocarina of Time")
#' }
get_games <- function(name = "sm64", abbreviation = NULL, ...) {

  if (!is.null(abbreviation)) {
    name <- NULL
  }

  url <- httr::modify_url(url = paste0(getOption("speedruncom_base"), "games"),
                          query = list(name = name, ...))
  res <- httr::GET(url)
  httr::warn_for_status(res)
  res <- httr::content(res)
  data <- res$data

  games <- purrr::map_df(data, function(x) {
    tibble::tibble(
      id = x$id,
      name_international = x$names$international,
      name_twitch = x$names$twitch,
      name_abbr = x$abbreviation,
      weblink = x$weblink,
      released = lubridate::ymd(x$`release-date`),
      released_year = x$released,
      romhack = x$romhack,
      created = lubridate::ymd_hms(x$created)
    )
  })

  games[order(games$created), ]
}


#' Get A Game's Categories
#'
#' @param id THe game's id as required by the API. See [get_games] to retrieve the id.
#' @param ... Optional named parameters passed to the api
#'
#' @return A [tibble::tibble] of categories
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/games.md#get-gamesidcategories>
#' @examples
#' \dontrun{
#' get_categories(id = "j1l9qz1g")
#' }
get_categories <- function(id = "j1l9qz1g", ...) {

  url <- httr::modify_url(url = paste0(getOption("speedruncom_base"), "games/", id, "/categories"),
                          query = list(...))
  res <- httr::GET(url)
  httr::warn_for_status(res)
  res <- httr::content(res)
  data <- res$data

  categories <- purrr::map_df(data, function(x) {
    tibble::tibble(
      id = x$id,
      name = x$name,
      link = x$weblink,
      type = x$type,
      miscellaneous = x$miscellaneous,
      rules = x$rules
    )
  })

  categories[order(categories$name), ]
}