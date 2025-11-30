# Libraries
library(tidyverse)
library(lubridate)
library(readr)

# Load data
df <- read_csv("./data/all_merge.csv")

# Hourly mean O3 across entire period
p_hour <- df %>%
  mutate(time = ymd_hms(time_utc, tz = "UTC"),
         hour = hour(time)) %>%
  group_by(hour) %>%
  summarise(o3 = mean(o3_ppb, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(hour, o3)) +
  geom_line(color = "pink", linewidth = 1) +
  geom_point(color = "pink", size = 2) +
  scale_x_continuous(breaks = 0:23) +
  labs(title = "Hourly Mean O₃",
       x = "Hour (UTC)", y = "O₃ (ppb)") +
  theme_minimal(base_size = 13)