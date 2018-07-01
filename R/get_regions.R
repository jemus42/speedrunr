#' Get Regions
#'
#' @param id Optional `id` of a specific region, normally all regions are returned.
#' @param output Return a `df` (default) or named `list`.
#' @return A [tibble::tibble] of region `id` and `name`.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/regions.md>
#'
#' @examples
#' \dontrun{
#' get_regions()
#' }
get_regions <- function(id = NULL, output = "df") {
  path <- paste(c("regions", id), collapse = "/", sep = "")
  res  <- sr_get(path = path)
  data <- res$data

  extract_region <- function(x) {
    tibble::tibble(
      id = x$id,
      name = x$name
    )
  }

  if (is.null(id)) {
    df <- purrr::map_df(data, extract_region)
  } else {
    df <- extract_region(data)
  }

  if (output == "df") {
    df
  } else if (output == "list") {
    lst <- as.list(df$name)
    names(lst) <- df$id
    lst
  } else {
    warning("Unknown output option. Have a df then.")
    df
  }

}
