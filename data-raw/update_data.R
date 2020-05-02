library(speedrunr)

platforms <- get_platforms()
regions <- get_regions()

usethis::use_data(platforms, regions, overwrite = TRUE)
