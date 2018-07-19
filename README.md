
<!-- README.md is generated from README.Rmd. Please edit that file -->

# speedrunr

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

| submitted           | time\_primary | player\_url                                      |
| :------------------ | :------------ | :----------------------------------------------- |
| 2018-06-21 02:28:51 | 04:05:28      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-06-19 05:20:57 | 04:07:59      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-06-14 04:01:53 | 04:08:11      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-06-05 03:41:59 | 04:08:57      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-06-02 03:35:41 | 04:10:17      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2017-12-28 02:05:48 | 04:10:43      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-07-03 02:09:52 | 04:11:00      | <https://www.speedrun.com/api/v1/users/v819rrxp> |
| 2017-12-14 04:12:51 | 04:11:08      | <https://www.speedrun.com/api/v1/users/e8e5v680> |
| 2018-06-23 02:17:28 | 04:12:17      | <https://www.speedrun.com/api/v1/users/v819rrxp> |
| 2018-06-16 04:07:34 | 04:15:50      | <https://www.speedrun.com/api/v1/users/v819rrxp> |
| 2017-10-30 04:09:49 | 04:17:44      | <https://www.speedrun.com/api/v1/users/v819rrxp> |
| 2017-12-14 22:50:33 | 04:18:08      | <https://www.speedrun.com/api/v1/users/v814mkp8> |
| 2018-07-12 20:26:37 | 04:19:26      | <https://www.speedrun.com/api/v1/users/qj2okpxk> |
| 2018-06-28 17:21:46 | 04:19:35      | <https://www.speedrun.com/api/v1/users/qj2okpxk> |
| 2017-10-29 03:57:41 | 04:19:56      | <https://www.speedrun.com/api/v1/users/v819rrxp> |
| 2018-05-15 15:32:49 | 04:20:17      | <https://www.speedrun.com/api/v1/users/qj2w3p6j> |
| 2018-06-27 05:15:22 | 04:20:31      | <https://www.speedrun.com/api/v1/users/qjn35kwx> |
| 2018-05-27 10:47:40 | 04:21:22      | <https://www.speedrun.com/api/v1/users/1xym2kmx> |
| 2017-11-28 22:51:51 | 04:21:49      | <https://www.speedrun.com/api/v1/users/v814mkp8> |
| 2017-11-20 04:05:45 | 04:21:54      | <https://www.speedrun.com/api/v1/users/18vv3y8l> |

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
| mol4z19n | CHN / iQue |
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
|         19603 | JPN / NTSC     | Nintendo 64         |
|         16135 | JPN / NTSC     | Nintendo 64         |
|         17671 | JPN / NTSC     | Nintendo 64         |
|         15682 | JPN / NTSC     | Wii Virtual Console |
|         15017 | JPN / NTSC     | Wii Virtual Console |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
