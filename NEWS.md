# speedrunr 0.2.0.9000

* Improved documentation
* Organizational:
    - Add travis
    - Auto-deploy pkgdown site via travis
* Output changes:
    - `get_runs` now *always* embeds `player` data, adding `player_name` and related columns.

# speedrunr 0.2.0

* Added datasets: `platforms` and `regions` for easier id resolving.
* Added functions:
    - `get_leaderboards`: Get... a leaderboard.
    - `get_variables_game`: Get a game's variables/values.
    - `add_platforms` and `add_regions`: Use packaged data to resolve these in run tbls.
    - `add_players`: Similiar use, but actually does API calls, but only one per unique `player_id`.
* API changes:
    - rename `get_variables` to `get_variable` as it only works on a single variable anyway.

* Fixes:
    - `get_categories` now does not fail anymore if one or more categories has no rules.
    - `get_runs` should properly handle pagination (i.e. `max` > 200) now.

# speedrunr 0.1.0

* Added a `NEWS.md` file to track changes to the package.
* Added functions:
    - `get_games`: Search for a game and retrieve its `id` which is required for the next step.
    - `get_platforms`: List all the platforms runs are being done on.
    - `get_categories`: Get a game's categories (needs `id` as per `get_games`).
    - `get_runs`: Get runs. Needs `game` and `category` to be useful, hence the previous functions.
    - `get_variables`: To resolve category/game-specific variables, e.g. `150cc` in Mario Kart.
    - `get_regions`: Get all the regions.
    - `find_records`: To append a boolean `record`-column on a `run` tbl, denoting records.
    - `is_outlier`: For quick outlier detection based on IQR.
    