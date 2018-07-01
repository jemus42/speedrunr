#' Call the speedrun.com API
#'
#' @param path API path.
#' @param ... Optional parameters
#'
#' @return A [httr] response object
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all users
#' sr_get(path = "users")
#' }
sr_get <- function(path = "", ...) {
  if (grepl(getOption("speedruncom_base"), path)) {
    url <- path
  } else {
    url <- paste0(getOption("speedruncom_base"), path)
  }

  url <- httr::modify_url(
    url = url,
    query = list(...)
  )


  res <- httr::GET(url)
  httr::warn_for_status(res)
  res <- httr::content(res)

  res
}
