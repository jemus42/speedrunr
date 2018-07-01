#' Get A Leaderboard
#'
#' @param game The game's `id` (mandatory).
#' @param category The category `id` (mandatory).
#' @param level The level `id`, if a per-level leaderboard is requested.
#' @param top `[100]`. How many places to return. Note there might be multiple runs per place.
#' @param ... Optional arguments to the API.
#'
#' @return A [tibble::tibble] of length `top` with run data.
#' @export
#'
#' @examples
#' # Get the Ocarina of Time 100% leaderboard
#' \dontrun{
#' get_leaderboard(game = "j1l9qz1g", category = "q255jw2o")
#' }
get_leaderboard <- function(game, category, level = NULL, top = 100, ...) {

  if (is.null(level)) {
    path <- paste0(c("leaderboards", game, "category", category), collapse = "/")
  } else {
    path <- paste0(c("leaderboards", game, "level", level, category), collapse = "/")
  }

  res <- sr_get(path, top = top, ...)
  data <- res$data

  purrr::map_df(data$runs, function(x) {
    run <- extract_run(x$run)
    place <- purrr::pluck(x, "place", .default = NA)
    tibble::add_column(run, place = place, .before = 1)
  })
}