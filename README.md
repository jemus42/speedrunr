
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speedrunr

[![Travis build
status](https://travis-ci.org/jemus42/speedrunr.svg?branch=master)](https://travis-ci.org/jemus42/speedrunr)
[![CRAN
status](https://www.r-pkg.org/badges/version/speedrunr)](https://cran.r-project.org/package=speedrunr)
[![GitHub
release](https://img.shields.io/github/release/jemus42/speedrunr.svg?logo=GitHub)](https://github.com/jemus42/speedrunr/releases)
[![GitHub last commit
(master)](https://img.shields.io/github/last-commit/jemus42/speedrunr/master.svg?logo=GithUb)](https://github.com/jemus42/speedrunr/commits/master)

</div>

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
library(dplyr)
library(knitr)
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
| nd2qgrd0 | Roblox Ocarina Of Time                            | root       |
| 76rkv4d8 | Ocarina of Time Category Extensions               | ootextras  |
| m1zromd0 | Ocarina of Time Beta Quest                        | ootbq      |

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
| z275w5k0 | Any%         | per-game  |
| 02qe4z2y | Any%         | per-level |
| 9kvr802g | Ganonless    | per-game  |

So apparently we’re looking for `q255jw2o`, the full-game 100% category.

### Get the runs in that category

Now we can fetch the runs. By default, 100 runs are returned, ordered by
submit date in descending order, so newest runs first. This also means
you will only be able to fully assess the WR progression if you make
sure to get *all* the runs.

``` r
runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o")

glimpse(runs)
#> Observations: 100
#> Variables: 22
#> $ id              <chr> "y43vwl3z", "y430d2dz", "yd3orkxz", "mk9rgxxz", …
#> $ weblink         <chr> "https://www.speedrun.com/oot/run/y43vwl3z", "ht…
#> $ game            <chr> "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", "j1l9qz1g", …
#> $ level           <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ category        <chr> "q255jw2o", "q255jw2o", "q255jw2o", "q255jw2o", …
#> $ videos          <chr> "https://www.twitch.tv/videos/398083535", "https…
#> $ status          <chr> "verified", "verified", "verified", "verified", …
#> $ comment         <chr> NA, "didn't expect my second valid run to be a r…
#> $ player_id       <chr> "kj9m2d7x", "68wvk24x", "kj9m2d7x", "68wvk24x", …
#> $ player_url      <chr> "https://www.speedrun.com/user/Kneeper", "https:…
#> $ player_name     <chr> "Kneeper", "gummee", "Kneeper", "gummee", "Angel…
#> $ player_role     <chr> "user", "user", "user", "user", "user", "user", …
#> $ player_signup   <dttm> 2019-03-07 08:22:06, 2019-03-07 06:43:08, 2019-…
#> $ date            <date> 2019-03-19, 2019-03-15, 2019-03-07, 2019-03-07,…
#> $ submitted       <dttm> 2019-03-20 03:05:21, 2019-03-16 03:20:52, 2019-…
#> $ time_primary    <int> 19937, 18773, 21572, 19416, 16156, 15282, 16304,…
#> $ time_realtime   <int> 19937, 18773, 21572, 19416, 16156, 15282, 16304,…
#> $ time_ingame     <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ time_hms        <time> 05:32:17, 05:12:53, 05:59:32, 05:23:36, 04:29:1…
#> $ system_platform <chr> "nzelreqp", "w89rwelk", "nzelreqp", "w89rwelk", …
#> $ system_emulated <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
#> $ system_region   <chr> "o316x197", "o316x197", "o316x197", "o316x197", …
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

| submitted           | time\_primary | player\_name   |
| :------------------ | :------------ | :------------- |
| 2018-11-28 02:03:45 | 03:53:33      | zfg            |
| 2018-10-31 01:33:08 | 03:54:52      | zfg            |
| 2018-09-23 01:03:54 | 03:56:08      | zfg            |
| 2018-08-21 04:27:10 | 03:57:38      | zfg            |
| 2018-10-11 04:03:38 | 03:58:28      | Marco          |
| 2018-08-02 02:15:56 | 03:58:45      | zfg            |
| 2018-09-29 13:12:43 | 03:59:17      | Marco          |
| 2018-09-17 12:49:58 | 04:00:47      | Marco          |
| 2018-07-28 05:47:32 | 04:01:05      | zfg            |
| 2018-09-01 04:40:41 | 04:01:39      | Marco          |
| 2018-07-22 03:15:39 | 04:03:24      | zfg            |
| 2018-08-04 04:03:15 | 04:03:40      | Marco          |
| 2018-09-09 23:02:52 | 04:07:04      | MasterMonk1991 |
| 2018-07-25 04:07:52 | 04:07:23      | Marco          |
| 2018-08-23 00:22:32 | 04:07:57      | Bonooru        |
| 2018-08-18 03:12:47 | 04:09:42      | Bonooru        |
| 2018-10-13 20:39:56 | 04:09:43      | dannyb21892    |
| 2018-08-24 10:36:10 | 04:09:50      | MasterMonk1991 |
| 2018-08-23 14:48:18 | 04:10:14      | MasterMonk1991 |
| 2018-07-20 01:17:13 | 04:10:32      | Marco          |

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
|         14258 | JPN / NTSC     | Wii Virtual Console |
|         22987 | JPN / NTSC     | Nintendo 64         |
|         15689 | JPN / NTSC     | Wii Virtual Console |
|         15060 | JPN / NTSC     | Wii Virtual Console |
|         15762 | JPN / NTSC     | Wii Virtual Console |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
