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
#' get_variables(id = "e8m7em86")
#' }
get_variables <- function(id, list_column = FALSE, ...) {

  path <- paste("variables", id, sep = "/")
  res  <- sr_get(path = path)
  x    <- res$data

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

  values <- x$values
  # value = map_df(values$choices, tibble::as_tibble)

  values_df <- purrr::map_df(values$values, function(x) {
    tibble::tibble(
      label = purrr::pluck(x, "label", .default = NA),
      flags_misc = purrr::pluck(x, "flags", "miscellaneous", .default = NA),
      rules = purrr::pluck(x, "rules", .default = NA)
    )
  })

  values_df$value <- names(values$values)
  values_df$default <- ifelse(values_df$value == values$default, TRUE, FALSE)

  values_df <- values_df[c(which(names(values_df) != "rules"),
                           which(names(values_df) == "rules"))]

  # List column?
  if (list_column) {
    variables$values <- list(values_df)
  } else {
    variables <- merge(variables, values_df)
  }

  variables
}