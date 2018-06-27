# speedrunr 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
* Added functions:
    - `get_games`: Search for a game and retrieve its `id` which is required for the next step.
    - `get_platforms`: List all the platforms runs are being done on.
    - `get_categories`: Get a game's categories (needs `id` as per `get_games`).
    - `get_runs`: Get runs. Needs `game` and `category` to be useful, hence the previous functions.
    - `get_variables`: To resolve category/game-specific variables, e.g. `150cc` in Mario Kart.
    - `find_records`: To append a boolean `record`-column on a `run` tbl, denoting records.