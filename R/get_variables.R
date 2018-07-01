#' Get a Variable's Information
#'
#' @param id The variable id.
#' @param list_column If `TRUE` (default) a list-column `values` is created.
#'   If `FALSE`, esiting rows will be duplicated and merged with the `values` object,
#'   yielding a flat tbl without nesting.
#' @param ... Optional arguments passed to the API.
#'
#' @return A [tibble::tibble] with the same number of rows as the variable has values if
#'   `list_column` is `FALSE`, otherwise a single-row tbl with a list-column.
#' @export
#' @source <https://github.com/speedruncomorg/api/blob/master/version1/variables.md>
#' @examples
#' \dontrun{
#' # Get Super Mario 64 variable for platform
#' get_variable(id = "e8m7em86")
#' }
get_variable <- function(id, list_column = FALSE, ...) {
  path <- paste0(c("variables", id), collapse = "/")
  res <- sr_get(path = path)
  x <- res$data

  extract_variables(x)
}

extract_values <- function(x) {
  tibble::tibble(
    label = purrr::pluck(x, "label", .default = NA),
    flags_misc = purrr::pluck(x, "flags", "miscellaneous", .default = NA),
    rules = purrr::pluck(x, "rules", .default = NA)
  )
}

extract_variables <- function(x, list_column = FALSE) {
  variables <- tibble::tibble(
    id = x$id,
    name = x$name,
    category = purrr::pluck(x, "category", .default = NA),
    scope = purrr::pluck(x, "scope", "type", .default = NA),
    mandatory = x$mandatory,
    user_defined = x$`user-defined`,
    obsoletes = x$obsoletes,
    is_subcategory = x$`is-subcategory`
  )

  values_df <- purrr::map_df(x$values$values, extract_values)

  values_df$value <- names(x$values$values)
  values_df$default <- ifelse(values_df$value == x$values$default, TRUE, FALSE)

  # rules column last
  values_df <- values_df[c(
    which(names(values_df) != "rules"),
    which(names(values_df) == "rules")
  )]

  # List column?
  if (list_column) {
    variables$values <- list(values_df)
  } else {
    variables <- tibble::as_tibble(merge(variables, values_df))
  }

  variables
}
