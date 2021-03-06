#' Get All Runs Within a Game's Category
#'
#' @param game The game's id.
#' @param category The category's id.
#' @param max The number of runs to return, default is `100`.
#' @param status Filter by run status, default is `"verified"`. Leave blank for all runs.
#' @param offset Offset used for pagination, supply `200` to get the *next* 200 runs.
#' @param verbose If `TRUE`, will display debugging output for pagination handling.
#'   This option will probably not stick around for long.
#' @param ... Optional arguments passed to API.
#'
#' @return A [tibble][tibble::tibble-package] of runs.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/runs.md#get-runs>
#' @examples
#' \dontrun{
#' # Get all Ocarina of Time 100% runs:
#' runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o")
#' }
get_runs <- function(game, category, max = 100, status = "verified",
                     offset = NULL, verbose = FALSE, ...) {
  res <- sr_get("runs",
    game = game, category = category, max = max,
    status = status, offset = offset, embed = list(embed = "players"),
    orderby = "submitted", direction = "desc", ...
  )

  next_url <- purrr::map_df(res$pagination$links, tibble::as_tibble)

  if (!("next" %in% next_url$rel)) {
    next_url <- NA
  } else if (!(identical(next_url, tibble::tibble()))) {
    next_url <- next_url$uri[next_url$rel == "next"]
  } else {
    next_url <- NA
  }
  if (is.null(next_url)) next_url <- NA

  data <- res$data

  runs <- purrr::map_df(data, extract_run)

  # Pagination is hard and this doesn't work properly yet
  if (verbose) {
    cat("\nnrow(runs) = ", nrow(runs))
    cat("\nmax = ", max)
  }

  if (!is.na(next_url) & nrow(runs) < max & nrow(runs) != 0) {
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

#' @keywords internal
extract_run <- function(x) {
  # For R CMD check's global variable thing
  time_primary <- NULL

  tibble::tibble(
    id = x$id,
    weblink = x$weblink,
    game = x$game,
    level = purrr::pluck(x, "level", .default = NA),
    category = x$category,
    videos = purrr::pluck(x, "videos", "links", 1, "uri", .default = NA),
    status = purrr::pluck(x, "status", "status", .default = NA),
    comment = purrr::pluck(x, "comment", .default = NA),
    player_id = purrr::pluck(x, "players", "data", 1, "id", .default = NA),
    player_url = purrr::pluck(x, "players", "data", 1, "weblink", .default = NA),
    player_name = purrr::pluck(x, "players", "data", 1, "names", "international", .default = NA),
    player_role = purrr::pluck(x, "players", "data", 1, "role", .default = NA),
    player_signup = lubridate::ymd_hms(purrr::pluck(x, "players", "data", 1, "signup", .default = NA)),
    date = lubridate::ymd(purrr::pluck(x, "date", .default = NA)),
    submitted = lubridate::ymd_hms(purrr::pluck(x, "submitted", .default = NA)),
    time_primary = purrr::pluck(x, "times", "primary_t", .default = NA),
    time_realtime = purrr::pluck(x, "times", "realtime_t", .default = NA),
    time_ingame = purrr::pluck(x, "times", "ingame_t", .default = NA),
    time_hms = hms::hms(seconds = time_primary),
    system_platform = purrr::pluck(x, "system", "platform", .default = NA),
    system_emulated = purrr::pluck(x, "system", "emulated", .default = NA),
    system_region = purrr::pluck(x, "system", "region", .default = NA)
  )
}
