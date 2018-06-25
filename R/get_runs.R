#' Get All Runs Within a Game's Category
#'
#' @param game The game's id.
#' @param category The category's id.
#' @param max The number of runs to return, default is `100`.
#' @param ... Optional arguments passed to API.
#'
#' @return A [tibble::tibble] of runs.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/runs.md#get-runs>
#' @examples
#' \dontrun{
#' # Get all Ocarina of Time 100% runs:
#' runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o")
#' }
get_runs <- function(game, category, max = 100, ...) {

  url <- httr::modify_url(url = paste0(getOption("speedruncom_base"), "runs"),
                          query = list(game = game, category = category, max = max,
                                       orderby = "submitted", direction = "desc", ...))
  res <- httr::GET(url)
  httr::warn_for_status(res)
  res <- httr::content(res)
  data <- res$data

  runs <- purrr::map_df(data, function(x) {
    tibble::tibble(
      id = x$id,
      weblink = x$weblink,
      game = x$game,
      level = ifelse(is.null(x$level), NA, x$level),
      category = x$category,
      videos = unname(unlist(purrr::flatten(x$videos))),
      status = x$status$status,
      comment = ifelse(is.null(x$comment), NA, x$comment),
      player_id = purrr::map_chr(x$players, "id"),
      player_url = purrr::map_chr(x$players, "uri"),
      date = lubridate::ymd(x$date),
      submitted = lubridate::ymd_hms(x$submitted),
      time_primary = x$times$primary_t,
      time_realtime = x$times$realtime_t,
      system_platform = x$system$platform,
      system_emulated = x$system$emulated,
      system_region = ifelse(is.null(x$system$region), NA, x$system$region)
    )
  })

  runs

}