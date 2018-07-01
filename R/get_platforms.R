#' Get Platforms
#'
#' @param id Optional `id` of a specific platform, normally all platforms are returned.
#' @inheritParams get_regions
#' @return A [tibble::tibble] with platform info and ids.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/platforms.md>
#' @note Currently the `released` variables is dropped on `list` output because I am bad at lists.
#' @examples
#' \dontrun{
#' get_platforms()
#' }
get_platforms <- function(id = NULL, output = "df") {

  path <- paste(c("platforms", id), collapse = "/", sep = "")
  res  <- sr_get(path = path, max = 200)
  data <- res$data

  extract_platforms <- function(x) {
    tibble::tibble(
      id = x$id,
      name = x$name,
      released = x$released
    )
  }

  if (is.null(id)) {
    platforms <- purrr::map_df(data, extract_platforms)
  } else {
    platforms <- extract_platforms(data)
  }

  if (output == "df") {
    platforms[order(platforms$released), ]
  } else if (output == "list") {
    lst <- as.list(platforms$name)
    names(lst) <- platforms$id
    lst
  }
}
