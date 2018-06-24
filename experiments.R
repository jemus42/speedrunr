# experiments
library(jsonlite)
library(tibble)
library(lubridate)
library(hms)
library(ggplot2)
library(dplyr)
library(purrr)
theme_set(tadaatoolbox::theme_tadaa())

runs <- fromJSON("https://www.speedrun.com/api/v1/runs?status=verified&game=j1l9qz1g&category=q255jw2o&max=200")


runs_hundo <- tibble(
  date = ymd_hms(runs$data$submitted),
  time = hms::hms(seconds = runs$data$times$primary_t),
  runner = map_chr(runs$data$players, 2),
  zfg = if_else(runner == "e8e5v680", TRUE, FALSE)
) %>%
  filter(time < hms::hms(hours = 12)) %>%
  arrange(date)

runs_hundo$record <- FALSE

for (run in seq_len(nrow(runs_hundo))) {
  if (runs_hundo$time[run] == min(runs_hundo$time[seq_len(run)])) {
    runs_hundo$record[run] <- TRUE
  } else {
    runs_hundo$record[run] <- FALSE
  }
}

runs_hundo %>%
  arrange(date) %>%
  #filter(record) %>%
  filter(time < hms::hms(hours = 5)) %>%
  ggplot(., aes(date, time, fill = zfg, color = zfg)) +
  #geom_smooth(method = lm, se = FALSE, fullrange = TRUE, color = "red", formula = y ~ splines::ns(x, 2)) +
  geom_smooth(aes(color = zfg), method = lm, se = FALSE, fullrange = TRUE) +
  geom_point(size = 2, shape = 21) +
  scale_x_datetime(date_breaks = "2 months", date_labels = "%b '%y",
                   limits = c(ymd_hms("20161001_100000"), ymd_hms("20181001_100000"))) +
  scale_y_time(breaks = seq(2 * 60^2, 20 * 60^2, 1/6 * 60^2),
               minor_breaks = seq(2 * 60^2, 20 * 60^2, 60),
               expand = c(.2, 0)) +
  scale_color_brewer(palette = "Set1", labels = c("Other Runners", "zfg"), name = NULL) +
  scale_fill_brewer(palette = "Set1", labels = c("Other Runners", "zfg"), name = NULL) +
  labs(title = "Ocarina of Time: 100% Speedrun Record History",
       subtitle = "All data from speedrun.com",
       x = "Date Submitted", y = "Time",
       caption = "@jemus42") +
  theme(legend.position = "top")




records <- runs_hundo %>%
  arrange(date) %>%
  filter(record) %>%
  mutate(diff = as.hms(abs(time - lag(time))),
         prev = lag(time))

records %>%
  mutate(diff = if_else(is.na(diff), hms(seconds = 0), diff),
         cumsum = cumsum(as.numeric(seconds(diff)))) %>%
  ggplot(aes(x = date, y = hms(seconds = cumsum))) +
  geom_point(size = 2) +
  scale_x_datetime(date_breaks = "2 months", date_labels = "%b '%y") +
  scale_y_time(breaks = seq(0, 60^2, 5 * 60),
               minor_breaks = seq(0, 60^2, 1 * 60)) +
  labs(title = "Ocarina of Time: 100% Record Progression",
       subtitle = "Cumulative Time Save Since 2017",
       x = "Date of Run", y = "Time Save (H:M:S)",
       caption = "Data from speedrun.com\n@jemus42")

