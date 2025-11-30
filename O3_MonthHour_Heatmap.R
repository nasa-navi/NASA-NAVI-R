# Libraries
library(tidyverse)
library(lubridate)
library(viridis)
library(readr)

# Load data (relative path for GitHub)
df <- read_csv("./data/all_merge.csv")

# Prepare month × hour mean O3
df_hm <- df %>%
  mutate(
    time = ymd_hms(time_utc, tz = "UTC"),
    month = month(time, label = TRUE, abbr = TRUE),
    hour  = as.integer(hour(time))
  ) %>%
  filter(!is.na(o3_ppb), !is.na(month), !is.na(hour), between(hour, 0, 23)) %>%
  group_by(month, hour) %>%
  summarise(o3 = mean(o3_ppb, na.rm = TRUE), .groups = "drop")

# Heatmap: Month × Hour mean O3
p_month_hour <- ggplot(df_hm, aes(x = hour, y = month, fill = o3)) +
  geom_tile() +
  scale_x_continuous(breaks = 0:23) +
  scale_fill_viridis(option = "C", direction = -1, name = "O₃ (ppb)") +
  labs(title = "Monthly × Hourly Mean O₃",
       x = "Hour (UTC)", y = "Month") +
  theme_minimal(base_size = 13)