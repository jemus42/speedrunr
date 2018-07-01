library(speedrunr)
library(usethis)

platforms <- get_platforms()
regions   <- get_regions()

use_data(platforms, regions, overwrite = TRUE)
