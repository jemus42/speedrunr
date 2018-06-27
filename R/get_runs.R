#' Get All Runs Within a Game's Category
#'
#' @param game The game's id.
#' @param category The category's id.
#' @param max The number of runs to return, default is `100`.
#' @param status Filter by run status, default is `"verified"`. Leave blank for all runs.
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
get_runs <- function(game, category, max = 100, status = "verified", ...) {

  res <- sr_get("runs", game = game, category = category, max = max,
                status = status,
                orderby = "submitted", direction = "desc", ...)

  next_url <- purrr::map_df(res$pagination$links, tibble::as_tibble)

  if (!(identical(next_url, tibble::tibble()))) {
    next_url <- next_url$uri[next_url$rel == "next"]
  } else {
    next_url <- NA
  }

  data <- res$data

  runs <- purrr::map_df(data, function(x) {
    tibble::tibble(
      id = x$id,
      weblink = x$weblink,
      game = x$game,
      level = pluck(x, "level", .default = NA),
      category = x$category,
      #videos = pluck(x, "videos", 1, "uri", .default = ""),
      status = x$status$status,
      comment = ifelse(is.null(x$comment), NA, x$comment),
      player_id = pluck(x, "players", 1, "id", .default = NA),
      player_url = pluck(x, "players", 1, "uri", .default = NA),
      date = lubridate::ymd(x$date),
      submitted = lubridate::ymd_hms(x$submitted),
      time_primary = x$times$primary_t,
      time_realtime = x$times$realtime_t,
      system_platform = pluck(x, "system", "platform", .default = NA),
      system_emulated = pluck(x, "system", "emulated", .default = NA),
      system_region = pluck(x, "system", "region", .default = NA)
    )
  })

  # Pagination is hard and this doesn't work properly yet
  # cat("\nnrow(runs) = ", nrow(runs))
  # cat("\nmax = ", max)
  if (!is.na(next_url) & nrow(runs) < max) {
    offset <- purrr::pluck(httr::parse_url(next_url), "query", "offset", .default = "")
    max <- max - as.numeric(offset)
    runs <- rbind(
      runs,
      get_runs(game = game, category = category, max = max, offset = offset)
    )
  } else {
    runs
  }

}