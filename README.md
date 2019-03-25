
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

kable(games)
```

| id       | name\_international                               | name\_twitch                                        | name\_abbr | weblink                              | released   | released\_year | romhack | created             |
| :------- | :------------------------------------------------ | :-------------------------------------------------- | :--------- | :----------------------------------- | :--------- | -------------: | :------ | :------------------ |
| j1l9qz1g | The Legend of Zelda: Ocarina of Time              | The Legend of Zelda: Ocarina of Time                | oot        | <https://www.speedrun.com/oot>       | 1998-11-21 |           1998 | FALSE   | 2015-02-17 01:43:13 |
| kdkjex1m | The Legend of Zelda: Ocarina of Time Master Quest | The Legend of Zelda: Ocarina of Time / Master Quest | ootmq      | <https://www.speedrun.com/ootmq>     | 2002-01-01 |           2002 | FALSE   | 2015-02-21 21:46:55 |
| 268vqkdp | The Legend of Zelda: Ocarina of Time 3D           | The Legend of Zelda: Ocarina of Time 3D             | oot3d      | <https://www.speedrun.com/oot3d>     | 2011-06-16 |           2011 | FALSE   | 2015-09-10 00:33:00 |
| nd2qgrd0 | Roblox Ocarina Of Time                            | ROBLOX                                              | root       | <https://www.speedrun.com/root>      | 2008-10-24 |           2008 | TRUE    | 2016-11-14 04:37:16 |
| 76rkv4d8 | Ocarina of Time Category Extensions               | The Legend of Zelda: Ocarina of Time                | ootextras  | <https://www.speedrun.com/ootextras> | 1998-11-21 |           1998 | TRUE    | 2017-01-22 17:56:13 |
| m1zromd0 | Ocarina of Time Beta Quest                        | Ocarina of Time Beta Quest                          | ootbq      | <https://www.speedrun.com/ootbq>     | 2015-11-13 |           2015 | TRUE    | 2017-07-24 03:24:09 |
| v1pol9m6 | SM64: Ocarina of Time                             | SM64: Ocarina of Time                               | sm64oot    | <https://www.speedrun.com/sm64oot>   | 2018-03-26 |           2018 | FALSE   | 2018-03-29 16:04:03 |

Turns out `j1l9qz1g` is the id we’re looking for.

### Get the game’s categories

``` r
categories <- get_categories(id = "j1l9qz1g")

categories %>%
  select(-rules) %>%
  kable()
```

| id       | name          | link                                         | type      | miscellaneous |
| :------- | :------------ | :------------------------------------------- | :-------- | :------------ |
| q255jw2o | 100%          | <https://www.speedrun.com/oot#100>           | per-game  | FALSE         |
| 824qn3k5 | 100%          | <https://www.speedrun.com/oot>               | per-level | FALSE         |
| zdnoz72q | All Dungeons  | <https://www.speedrun.com/oot#All_Dungeons>  | per-game  | FALSE         |
| z275w5k0 | Any%          | <https://www.speedrun.com/oot#Any>           | per-game  | FALSE         |
| 02qe4z2y | Any%          | <https://www.speedrun.com/oot>               | per-level | FALSE         |
| 9kvr802g | Ganonless     | <https://www.speedrun.com/oot#Ganonless>     | per-game  | TRUE          |
| zd35jnkn | Glitchless    | <https://www.speedrun.com/oot#Glitchless>    | per-game  | FALSE         |
| ndxlw1dq | Glitchless    | <https://www.speedrun.com/oot>               | per-level | FALSE         |
| jdrwr0k6 | MST           | <https://www.speedrun.com/oot#MST>           | per-game  | FALSE         |
| 9d85yqdn | No IM/WW      | <https://www.speedrun.com/oot#No_IMWW>       | per-game  | FALSE         |
| xd1wj828 | No Wrong Warp | <https://www.speedrun.com/oot#No_Wrong_Warp> | per-game  | TRUE          |
| rklm8qdn | Restricted    | <https://www.speedrun.com/oot>               | per-level | TRUE          |

So apparently we’re looking for `q255jw2o`, the full-game 100% category.

### Get the runs in that category

Now we can fetch the runs. By default, 100 runs are returned, ordered by
submit date in descending order, so newest runs first. This also means
you will only be able to fully assess the WR progression if you make
sure to get *all* the runs.

``` r
runs <- get_runs(game = "j1l9qz1g", category = "q255jw2o")
```

And now we can basically re-create the leaderboard, but including
obsoleted runs:

``` r
library(hms)

runs %>%
  arrange(time_primary) %>%
  head(20) %>%
  select(submitted, time_primary, player_url) %>%
  mutate(time_primary = hms(seconds = time_primary)) %>%
  kable()
```

| submitted           | time\_primary | player\_url                                    |
| :------------------ | :------------ | :--------------------------------------------- |
| 2018-11-28 02:03:45 | 03:53:33      | <https://www.speedrun.com/user/zfg>            |
| 2018-10-31 01:33:08 | 03:54:52      | <https://www.speedrun.com/user/zfg>            |
| 2018-09-23 01:03:54 | 03:56:08      | <https://www.speedrun.com/user/zfg>            |
| 2018-08-21 04:27:10 | 03:57:38      | <https://www.speedrun.com/user/zfg>            |
| 2018-10-11 04:03:38 | 03:58:28      | <https://www.speedrun.com/user/Marco>          |
| 2018-08-02 02:15:56 | 03:58:45      | <https://www.speedrun.com/user/zfg>            |
| 2018-09-29 13:12:43 | 03:59:17      | <https://www.speedrun.com/user/Marco>          |
| 2018-09-17 12:49:58 | 04:00:47      | <https://www.speedrun.com/user/Marco>          |
| 2018-07-28 05:47:32 | 04:01:05      | <https://www.speedrun.com/user/zfg>            |
| 2018-09-01 04:40:41 | 04:01:39      | <https://www.speedrun.com/user/Marco>          |
| 2018-07-22 03:15:39 | 04:03:24      | <https://www.speedrun.com/user/zfg>            |
| 2018-08-04 04:03:15 | 04:03:40      | <https://www.speedrun.com/user/Marco>          |
| 2018-09-09 23:02:52 | 04:07:04      | <https://www.speedrun.com/user/MasterMonk1991> |
| 2018-07-25 04:07:52 | 04:07:23      | <https://www.speedrun.com/user/Marco>          |
| 2018-08-23 00:22:32 | 04:07:57      | <https://www.speedrun.com/user/Bonooru>        |
| 2018-08-18 03:12:47 | 04:09:42      | <https://www.speedrun.com/user/Bonooru>        |
| 2018-10-13 20:39:56 | 04:09:43      | <https://www.speedrun.com/user/dannyb21892>    |
| 2018-08-24 10:36:10 | 04:09:50      | <https://www.speedrun.com/user/MasterMonk1991> |
| 2018-08-23 14:48:18 | 04:10:14      | <https://www.speedrun.com/user/MasterMonk1991> |
| 2018-07-20 01:17:13 | 04:10:32      | <https://www.speedrun.com/user/Marco>          |

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
|         15412 | JPN / NTSC     | Wii Virtual Console |
|         18022 | JPN / NTSC     | Wii Virtual Console |
|         15848 | JPN / NTSC     | Wii Virtual Console |
|         15269 | JPN / NTSC     | Wii Virtual Console |
|         15389 | JPN / NTSC     | Wii Virtual Console |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
