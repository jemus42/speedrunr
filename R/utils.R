#' Classify Runs as WR
#'
#' @param runs A [tibble::tibble] of runs as returned by [get_runs].
#' @param by Variable that determines record status, either `date` (default) for the date of
#'   the run, or `submitted` for the time the run was submitted to speedrun.com.
#'
#' @return A modified `runs` tbl with a boolean `record` variable.
#' @export
#'
#' @examples
#' \dontrun{
#' runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o", max = 1000)
#' runs <- find_records(runs)
#' }
find_records <- function(runs, by = "date") {

  if (!(by %in% c("date", "submitted"))) {
    stop("\"by\" must be either \"date\" (date of run) or \"submitted\" (date of submission)")
  }

  runs <- runs[order(runs[[by]]), ]

  runs$record <- purrr::map_lgl(seq_len(nrow(runs)), function(x) {
    runs$time[x] == min(runs$time[seq_len(x)])
  })

  runs
}