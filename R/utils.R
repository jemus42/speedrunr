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

#' Detect Outliers
#'
#' @param x A `numeric` vector.
#' @param method Currently only `quantile` is supported.
#' @param direction `upper`, (default) `lower` or `both`.
#'
#' @return A `logical` vector of the same length as `x`
#' @export
#'
#' @examples
#' is_outlier(runif(20))
is_outlier <- function(x, method = "quantile", direction = "upper") {
  iqr <- IQR(x, na.rm = TRUE)
  upper <- median(x, na.rm = TRUE) + 1.5 * iqr
  lower <- median(x, na.rm = TRUE) - 1.5 * iqr

  if (direction == "upper") {
    x >= upper
  } else if (direction == "lower") {
    x <= lower
  } else if (direction == "both") {
    x <= lower & x >= upper
  }

}