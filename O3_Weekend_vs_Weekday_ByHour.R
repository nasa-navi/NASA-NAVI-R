# Libraries
library(tidyverse)
library(lubridate)
library(readr)

# Load data
df <- read_csv("./data/all_merge.csv")

# Weekend/weekday flag and hourly mean O3
p_dow <- df %>%
  mutate(
    time = ymd_hms(time_utc, tz = "UTC"),
    hour = hour(time),
    date = as_date(time),
    dow  = wday(date, week_start = 1),        # 1 = Mon ... 7 = Sun
    is_weekend = if_else(dow %in% c(6, 7), "Weekend", "Weekday")
  ) %>%
  group_by(is_weekend, hour) %>%
  summarise(o3 = mean(o3_ppb, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(hour, o3, color = is_weekend)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c("Weekend" = "red", "Weekday" = "blue")) +
  scale_x_continuous(breaks = 0:23) +
  labs(title = "Weekend vs Weekday: Hourly O₃",
       x = "Hour (UTC)", y = "O₃ (ppb)", color = "") +
  theme_minimal(base_size = 13)