
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speedrunr

<!-- badges: start -->

[![R-CMD-check](https://github.com/jemus42/speedrunr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jemus42/speedrunr/actions/workflows/R-CMD-check.yaml)
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
pak::pak("jemus42/speedrunr")
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

| id       | name_international                                | name_abbr |
|:---------|:--------------------------------------------------|:----------|
| j1l9qz1g | The Legend of Zelda: Ocarina of Time              | oot       |
| kdkjex1m | The Legend of Zelda: Ocarina of Time Master Quest | ootmq     |
| 268vqkdp | The Legend of Zelda: Ocarina of Time 3D           | oot3d     |
| 76rkv4d8 | Ocarina of Time Category Extensions               | ootextras |
| m1zromd0 | Ocarina of Time Beta Quest                        | ootbq     |
| v1pol9m6 | SM64: Ocarina of Time                             | sm64oot   |

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
|:---------|:-------------|:----------|
| q255jw2o | 100%         | per-game  |
| 824qn3k5 | 100%         | per-level |
| zdnoz72q | All Dungeons | per-game  |
| q25g198d | Any%         | per-game  |
| 02qe4z2y | Any%         | per-level |
| z275w5k0 | Defeat Ganon | per-game  |

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
#> $ id              <chr> "me0werqz", "zxwwll5m", "yoodd21y", "zg8dd4jy", "z0xor…
#> $ weblink         <chr> "https://www.speedrun.com/oot/run/me0werqz", "https://…
#> $ game            <chr> "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", "j1l9q…
#> $ level           <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ category        <chr> "q255jw2o", "q255jw2o", "q255jw2o", "q255jw2o", "q255j…
#> $ videos          <chr> "https://www.twitch.tv/videos/2012632378", "https://ww…
#> $ status          <chr> "verified", "verified", "verified", "verified", "verif…
#> $ comment         <chr> "Late game sucks =)", "[Retimed to 4:22:32 -LG]", NA, …
#> $ player_id       <chr> "dx354dqj", "jmpvmyej", "dx354dqj", "8rplr3wj", "dx354…
#> $ player_url      <chr> "https://www.speedrun.com/user/Smaugy", "https://www.s…
#> $ player_name     <chr> "Smaugy", "darkerandroid", "Smaugy", "Bancakes", "Smau…
#> $ player_role     <chr> "user", "user", "user", "user", "user", "user", "user"…
#> $ player_signup   <dttm> 2015-07-23 13:20:40, 2021-03-19 20:51:49, 2015-07-23 …
#> $ date            <date> 2023-12-23, 2023-12-17, 2023-11-24, 2023-10-25, 2023-…
#> $ submitted       <dttm> 2023-12-24 11:32:19, 2023-12-17 06:58:22, 2023-11-25 …
#> $ time_primary    <int> 15019, 15752, 15290, 17889, 15735, 13914, 18444, 16296…
#> $ time_realtime   <int> 15019, 15752, 15290, 17889, 15735, 13914, 18444, 16296…
#> $ time_ingame     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ time_hms        <time> 04:10:19, 04:22:32, 04:14:50, 04:58:09, 04:22:15, 03:…
#> $ system_platform <chr> "nzelreqp", "nzelreqp", "nzelreqp", "nzelreqp", "nzelr…
#> $ system_emulated <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE…
#> $ system_region   <chr> "o316x197", "o316x197", "o316x197", "o316x197", "o316x…
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

| submitted           | time_primary | player_name      |
|:--------------------|:-------------|:-----------------|
| 2023-05-04 10:21:10 | 03:16:42     | ZerKirL          |
| 2023-03-26 20:23:57 | 03:28:27     | ZerKirL          |
| 2023-06-10 11:21:43 | 03:36:24     | GregoTheGreatest |
| 2022-08-23 07:29:36 | 03:41:40     | amsixx           |
| 2023-07-31 01:16:47 | 03:45:46     | glitchymon       |
| 2022-07-07 03:36:01 | 03:45:51     | glitchymon       |
| 2022-06-22 02:18:20 | 03:47:36     | AxelLarsen       |
| 2022-05-28 04:59:41 | 03:51:15     | AxelLarsen       |
| 2023-10-25 04:55:44 | 03:51:54     | EricDaCleric     |
| 2022-05-27 06:55:44 | 03:52:25     | AxelLarsen       |
| 2023-02-08 18:05:38 | 03:52:59     | EricDaCleric     |
| 2022-04-22 05:15:31 | 03:53:04     | AxelLarsen       |
| 2023-01-29 12:48:31 | 03:53:38     | Lozoots          |
| 2022-05-19 13:55:37 | 03:55:11     | EricDaCleric     |
| 2022-07-18 11:26:07 | 03:55:29     | Lozoots          |
| 2022-09-11 00:35:44 | 03:55:39     | GregoTheGreatest |
| 2023-04-03 10:02:53 | 03:56:00     | Amateseru        |
| 2022-07-28 09:49:40 | 03:56:36     | GreenRiver       |
| 2023-03-17 13:21:05 | 03:57:00     | Amateseru        |
| 2023-01-17 11:08:50 | 03:57:20     | Amateseru        |

### More data

Wanna resolve those platforms? Just join with this table:

``` r
get_platforms() %>%
  head() %>%
  kable()
```

| id       | name                                          | released |
|:---------|:----------------------------------------------|---------:|
| gz9qv3e0 | Airplane Seats                                |     1925 |
| jm95rr6o | Electronic Delay Storage Automatic Calculator |     1949 |
| mr6km09z | MS-DOS                                        |     1970 |
| 8gej2n93 | PC                                            |     1970 |
| 3167od9q | Plug and Play                                 |     1970 |
| vm9vkn63 | Tabletop                                      |     1970 |

Same can be done with regions:

``` r
get_regions() %>%
  kable()
```

| id       | name       |
|:---------|:-----------|
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

| time_primary | system_region | system_platform     |
|-------------:|:--------------|:--------------------|
|        15260 | JPN / NTSC    | Wii Virtual Console |
|        14959 | JPN / NTSC    | Wii Virtual Console |
|        15512 | JPN / NTSC    | Wii Virtual Console |
|        17086 | JPN / NTSC    | Wii Virtual Console |
|        14377 | JPN / NTSC    | Wii Virtual Console |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
