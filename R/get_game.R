#' Search for Games by Name
#'
#' @param name A search query, `character`.
#' @param ... Other named parameters passed to the API.
#'
#' @return A [tibble::tibble] with search results
#' @export
#' @examples
#' \dontrun{
#' get_game("Ocarina of Time")
#' }
get_game <- function(name = "sm64", ...) {

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
