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
    runs$time_primary[x] == min(runs$time_primary[seq_len(x)])
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
#' @examples
#' is_outlier(runif(20))
is_outlier <- function(x, method = "quantile", direction = "upper") {
  iqr <- stats::IQR(x, na.rm = TRUE)
  upper <- stats::median(x, na.rm = TRUE) + 1.5 * iqr
  lower <- stats::median(x, na.rm = TRUE) - 1.5 * iqr

  if (direction == "upper") {
    x >= upper
  } else if (direction == "lower") {
    x <= lower
  } else if (direction == "both") {
    x <= lower & x >= upper
  }
}

#' Join Platform/Region info to Runs
#'
#' @rdname add_miscdata
#'
#' @param runs A `tbl` of runs as returned by `get_runs` or `get_leaderboards`
#' @param platforms,regions The platform/region data to use. Uses packaged datasets by default.
#' @return The input `runs` tbl with resolved `system_`* variables and/or `player_name` column.
#' @export
#' @import dplyr
#' @examples
#' \dontrun{
#' runs <- get_leaderboards(game = "j1l9qz1g")
#'
#' add_platforms(runs)
#' add_regions(runs)
#' }
add_platforms <- function(runs, platforms = speedrunr::platforms) {
  # For R CMD check's global variable thing
  released <- name <- platform <- NULL
  left_join(
    runs,
    platforms %>% select(-released) %>% rename(platform = name),
    by = c("system_platform" = "id")
  ) %>%
    mutate(system_platform = platform) %>%
    select(-platform)
}

#' @rdname add_miscdata
#' @import dplyr
#' @export
add_regions <- function(runs, regions = speedrunr::regions) {
  # For R CMD check's global variable thing
  name <- region <- NULL
  left_join(
    runs,
    regions %>% rename(region = name),
    by = c("system_region" = "id")
  ) %>%
    mutate(system_region = region) %>%
    select(-region)
}

#' @rdname add_miscdata
#' @import dplyr
#' @export
add_players <- function(runs) {
  # For R CMD check's global variable thing
  player_id <- NULL

  if ("player_name" %in% names(runs)) {
    warning("There's already a 'player_name' column, doing nothing.")
    return(runs)
  }

  runs %>%
    select(player_id) %>%
    distinct() %>%
    mutate(player_name = purrr::map_chr(
      player_id,
      ~purrr::pluck(get_user(id = .x),
        "name_int",
        .default = NA
      )
    )) %>%
    full_join(runs,
      by = c("player_id" = "player_id")
    )
}
