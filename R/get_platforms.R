#' Get All Platforms
#'
#' @param max How many results to return. Default is `100`.
#' @param ... Optional arguments passed to the API
#'
#' @return A [tibble::tibble] with platform info and ids.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/platforms.md>
#' @examples
#' \dontrun{
#' get_platforms()
#' }
get_platforms <- function(max = 100, ...) {
  url <- httr::modify_url(url = paste0(getOption("speedruncom_base"), "platforms"),
                          query = list(max = max, ...))
  res <- httr::GET(url)
  httr::warn_for_status(res)
  res <- httr::content(res)
  data <- res$data

  platforms <- purrr::map_df(data, function(x) {
    tibble::tibble(
      id = x$id,
      name = x$name,
      released = x$released,
      link_self = x$links[[1]]$uri,
      link_games = x$links[[2]]$uri,
      link_runs = x$links[[3]]$uri
    )
  })

  platforms[order(platforms$released), ]
}
