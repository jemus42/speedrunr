#' Get a Single User by ID
#'
#' @param id The user id, e.g. `"e8e5v680"` for *zfg*.
#' @param ... Optional parameters for the api.
#'
#' @return A [tibble::tibble] with one row.
#' @export
#'
#' @examples
#' \dontrun{
#' get_user(id = "e8e5v680")
#' }
get_user <- function(id, ...) {
  path <- paste("users", id, sep = "/")

  res <- sr_get(path, ...)
  data <- res$data

  tibble::tibble(
    id = data$id,
    name_int = purrr::pluck(data, "names", "international", .default = NA),
    weblink = data$weblink,
    role = data$role,
    signup = lubridate::ymd_hms(data$signup),
    location_code = purrr::pluck(data, "location", "country", "code", .default = NA),
    location_name = purrr::pluck(data, "location", "country", "names", "international", .default = NA),
    twitch = purrr::pluck(data, "twitch", "uri", .default = NA),
    hitbox = purrr::pluck(data, "hitbox", "uri", .default = NA),
    youtube = purrr::pluck(data, "youtube", "uri", .default = NA),
    twitter = purrr::pluck(data, "twitter", "uri", .default = NA),
    speedrunslive = purrr::pluck(data, "speedrunslive", "uri", .default = NA)
  )
}
