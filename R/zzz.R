# Set API base URL on startup
.onLoad <- function(...) {
  options(speedruncom_base = "https://www.speedrun.com/api/v1/")
}

# Clean up option on unload
.onDetach <- function(...) {
  options(speedruncom_base = NULL)
}
