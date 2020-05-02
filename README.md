
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speedrunr

<!-- badges: start -->

[![R build
status](https://github.com/jemus42/speedrunr/workflows/R-CMD-check/badge.svg)](https://github.com/jemus42/speedrunr/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/speedrunr)](https://cran.r-project.org/package=speedrunr)
[![GitHub
release](https://img.shields.io/github/release/jemus42/speedrunr.svg?logo=GitHub)](https://github.com/jemus42/speedrunr/releases)
[![GitHub last commit
(master)](https://img.shields.io/github/last-commit/jemus42/speedrunr/master.svg?logo=GithUb)](https://github.com/jemus42/speedrunr/commits/master)
<!-- badges: end -->

The goal of speedrunr is to easily access data from
[speedrun.com](https://speedrun.com).

## Installation

You can install the released version of speedrunr from GitHub with:

``` r
remotes::install_github("jemus42/speedrunr")
```

## Example

Let’s say you want to plot the times of all *Ocarina of TIme 100%*
runs.  
Let’s get started:

``` r
library(speedrunr)
library(dplyr) # Data manip
library(knitr) # Tables
```

### Identifiyng the game you’re looking for

You can either search for “Ocarina of Time”, or supply `'oot'`, the
game’s abbreviation on speedrun.com.

``` r
games <- get_games(name = "Ocarina of Time")

games %>% 
  select(id, name_international, name_abbr) %>%
  head() %>%
  kable()
```

| id       | name\_international                               | name\_abbr |
| :------- | :------------------------------------------------ | :--------- |
| j1l9qz1g | The Legend of Zelda: Ocarina of Time              | oot        |
| kdkjex1m | The Legend of Zelda: Ocarina of Time Master Quest | ootmq      |
| 268vqkdp | The Legend of Zelda: Ocarina of Time 3D           | oot3d      |
| 76rkv4d8 | Ocarina of Time Category Extensions               | ootextras  |
| m1zromd0 | Ocarina of Time Beta Quest                        | ootbq      |
| v1pol9m6 | SM64: Ocarina of Time                             | sm64oot    |

Turns out `j1l9qz1g` is the id we’re looking for.

### Get the game’s categories

``` r
categories <- get_categories(id = "j1l9qz1g")

categories %>%
  select(id, name, type) %>%
  head() %>%
  kable()
```

| id       | name         | type      |
| :------- | :----------- | :-------- |
| q255jw2o | 100%         | per-game  |
| 824qn3k5 | 100%         | per-level |
| zdnoz72q | All Dungeons | per-game  |
| q25g198d | Any%         | per-game  |
| 02qe4z2y | Any%         | per-level |
| zd35jnkn | Glitchless   | per-game  |

So apparently we’re looking for `q255jw2o`, the full-game 100% category.

### Get the runs in that category

Now we can fetch the runs. By default, 100 runs are returned, ordered by
submit date in descending order, so newest runs first. This also means
you will only be able to fully assess the WR progression if you make
sure to get *all* the runs.

``` r
runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o")

glimpse(runs)
#> Rows: 100
#> Columns: 22
#> $ id              [3m[90m<chr>[39m[23m "y9015e2y", "yd55novm", "z5j7l4nm", "zpr4kk8m", "mrke…
#> $ weblink         [3m[90m<chr>[39m[23m "https://www.speedrun.com/oot/run/y9015e2y", "https:/…
#> $ game            [3m[90m<chr>[39m[23m "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", "j1l9…
#> $ level           [3m[90m<lgl>[39m[23m NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ category        [3m[90m<chr>[39m[23m "q255jw2o", "q255jw2o", "q255jw2o", "q255jw2o", "q255…
#> $ videos          [3m[90m<chr>[39m[23m "https://www.twitch.tv/videos/608790240", "https://ww…
#> $ status          [3m[90m<chr>[39m[23m "verified", "verified", "verified", "verified", "veri…
#> $ comment         [3m[90m<chr>[39m[23m NA, "3rd try Dampe", "This run sucks.", NA, "Finally …
#> $ player_id       [3m[90m<chr>[39m[23m "zx73zzvj", "v813d3xp", "pj00zwjw", "v8l62g78", "v8lr…
#> $ player_url      [3m[90m<chr>[39m[23m "https://www.speedrun.com/user/JoeCool", "https://www…
#> $ player_name     [3m[90m<chr>[39m[23m "JoeCool", "glitchymon", "EnNopp112", "EricDaCleric",…
#> $ player_role     [3m[90m<chr>[39m[23m "user", "user", "user", "user", "user", "user", "user…
#> $ player_signup   [3m[90m<dttm>[39m[23m 2019-09-10 02:55:31, 2015-03-05 22:12:19, 2015-06-25…
#> $ date            [3m[90m<date>[39m[23m 2020-05-01, 2020-04-06, 2020-04-12, 2020-04-21, 2020…
#> $ submitted       [3m[90m<dttm>[39m[23m 2020-05-02 04:21:10, 2020-04-28 11:01:30, 2020-04-21…
#> $ time_primary    [3m[90m<int>[39m[23m 18240, 13465, 13805, 13847, 35313, 14660, 20783, 1362…
#> $ time_realtime   [3m[90m<int>[39m[23m 18240, 13465, 13805, 13847, 35313, 14660, 20783, 1362…
#> $ time_ingame     [3m[90m<int>[39m[23m 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ time_hms        [3m[90m<time>[39m[23m 05:04:00, 03:44:25, 03:50:05, 03:50:47, 09:48:33, 04…
#> $ system_platform [3m[90m<chr>[39m[23m "nzelreqp", "nzelreqp", "nzelreqp", "nzelreqp", "w89r…
#> $ system_emulated [3m[90m<lgl>[39m[23m FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALS…
#> $ system_region   [3m[90m<chr>[39m[23m "o316x197", "o316x197", "o316x197", "o316x197", "o316…
```

And now we can basically re-create the leaderboard, but including
obsoleted runs:

``` r
library(hms)

runs %>%
  arrange(time_primary) %>%
  head(20) %>%
  select(submitted, time_primary, player_name) %>%
  mutate(time_primary = hms(seconds = time_primary)) %>%
  kable()
```

| submitted           | time\_primary | player\_name |
| :------------------ | :------------ | :----------- |
| 2020-04-28 11:01:30 | 03:44:25      | glitchymon   |
| 2020-04-03 08:26:30 | 03:45:59      | glitchymon   |
| 2020-04-12 11:36:02 | 03:47:00      | AxelLarsen   |
| 2020-04-11 02:34:15 | 03:48:01      | AxelLarsen   |
| 2020-03-19 00:14:45 | 03:49:23      | glitchymon   |
| 2020-02-18 18:45:03 | 03:49:58      | glitchymon   |
| 2020-04-21 12:30:19 | 03:50:05      | EnNopp112    |
| 2020-03-28 11:59:22 | 03:50:31      | AxelLarsen   |
| 2020-04-21 10:02:01 | 03:50:47      | EricDaCleric |
| 2020-02-29 09:55:40 | 03:50:47      | Marco        |
| 2019-12-20 00:23:32 | 03:51:34      | glitchymon   |
| 2020-03-22 10:06:41 | 03:52:14      | AxelLarsen   |
| 2019-11-26 11:43:07 | 03:52:21      | glitchymon   |
| 2019-12-19 17:59:29 | 03:53:27      | Marco        |
| 2019-10-29 02:06:15 | 03:54:15      | glitchymon   |
| 2020-03-20 12:07:33 | 03:54:49      | AxelLarsen   |
| 2020-03-06 08:34:33 | 03:55:24      | AxelLarsen   |
| 2019-11-16 07:33:14 | 03:55:32      | Marco        |
| 2019-11-01 18:23:51 | 03:55:52      | Marco        |
| 2020-03-30 17:31:17 | 03:57:18      | EricDaCleric |

### More data

Wanna resolve those platforms? Just join with this table:

``` r
get_platforms() %>%
  head() %>%
  kable()
```

| id       | name        | released |
| :------- | :---------- | -------: |
| mr6km09z | MS-DOS      |     1970 |
| 8gej2n93 | PC          |     1970 |
| 3167od9q | Plug & Play |     1970 |
| vm9vkn63 | Tabletop    |     1970 |
| w89ryw6l | Apple II    |     1977 |
| o0644863 | Atari 2600  |     1977 |

Same can be done with regions:

``` r
get_regions() %>%
  kable()
```

| id       | name       |
| :------- | :--------- |
| ypl25l47 | BRA / PAL  |
| mol4z19n | CHN / PAL  |
| e6lxy1dz | EUR / PAL  |
| o316x197 | JPN / NTSC |
| p2g50lnk | KOR / NTSC |
| pr184lqn | USA / NTSC |

There are also convenience functions to pipe your `runs` object into:

  - `add_platforms()`
  - `add_regions()`
  - `add_players()`, which only makes on API call per unique player.

All of them work in the following way:

``` r
runs %>% 
  add_regions() %>%
  add_platforms() %>%
  select(time_primary, system_region, system_platform) %>%
  sample_n(5) %>%
  knitr::kable()
```

| time\_primary | system\_region | system\_platform    |
| ------------: | :------------- | :------------------ |
|         16178 | JPN / NTSC     | Wii Virtual Console |
|         27921 | JPN / NTSC     | Wii Virtual Console |
|         13894 | JPN / NTSC     | Wii Virtual Console |
|         17804 | JPN / NTSC     | Wii Virtual Console |
|         13831 | JPN / NTSC     | Wii Virtual Console |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
