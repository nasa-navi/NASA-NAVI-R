# Libraries
library(tidyverse)
library(lubridate)
library(readr)
library(ggplot2)

# Load data
data <- read_csv("./data/all_merge.csv")

# Ensure POSIX time column exists
data <- data %>%
  mutate(
    time = as.POSIXct(time_utc, format = "%Y-%m-%d %H:%M:%S", tz = "UTC"),
    hour = hour(time)
  )

# (A) PM2.5 hourly line (structure check)
p_pm25_hour <- ggplot(data, aes(x = hour, y = pm25_ugm3)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(
    title = "PM₂․₅: Hourly Pattern",
    x = "Hour of Day", y = "PM₂․₅ (µg/m³)"
  ) +
  theme_minimal()

p_pm25_hour

# (B) NO2 distribution by hour (boxplot)
p_no2_box <- ggplot(data, aes(x = as.factor(hour), y = no2)) +
  geom_boxplot(fill = "pink", color = "black", outlier.color = "green") +
  labs(
    title = "NO₂ Distribution by Hour",
    x = "Hour of Day", y = "NO₂ (molecules/cm²)"
  ) +
  theme_minimal()