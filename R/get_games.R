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
#' # Get all games matching Ocarina of Time
#' get_games(name = "Ocarina of Time")
#'
#' # Or directly if you know its abbreviation is oot:
#' get_games(abbreviation = "oot")
#' }
get_games <- function(name = "", abbreviation = NULL, ...) {
  if (!is.null(abbreviation)) {
    name <- ""
  } else {
    abbreviation <- ""
  }

  path <- paste0(c("games"), collapse = "/")
  res <- sr_get(path, name = name, abbreviation = abbreviation, ...)
  data <- res$data

  extract_gamedata <- function(x) {
    tibble::tibble(
      id = x$id,
      name_international = x$names$international,
      name_twitch = x$names$twitch,
      name_abbr = x$abbreviation,
      weblink = x$weblink,
      released = lubridate::ymd(x$`release-date`),
      released_year = x$released,
      romhack = x$romhack,
      created = lubridate::ymd_hms(purrr::pluck(x, "created", .default = NA))
    )
  }

  games <- purrr::map_df(data, extract_gamedata)

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
get_categories <- function(id, ...) {
  path <- paste0(c("games", id, "categories"), collapse = "/")
  res <- sr_get(path, ...)
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

#' Get a Game's Variables
#'
#' @param game The game's `id`
#' @param list_column `[FALSE]` Whether to return a list column or a flat `tbl`.
#'
#' @return A [tibble::tibble] with one row per `variable` _or_
#'   per `value` depending on `list_column`
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/games.md#get-gamesidvariables>
#' @examples
#' # Get the variables for Ocarina of Time
#' \dontrun{
#' get_variables_game(game = "j1l9qz1g")
#' }
get_variables_game <- function(game, list_column = FALSE) {
  path <- paste0(c("games", game, "variables"), collapse = "/")
  res <- sr_get(path)
  data <- res$data

  purrr::map_df(data, ~extract_variables(.x, list_column = list_column))
}
