# Libraries
library(tidyverse)
library(readr)
library(ggplot2)

# Load data
data <- read_csv("./data/all_merge.csv")

# NO2 vs PM2.5 scatter with linear smoother
p_no2_pm25 <- ggplot(data, aes(x = no2, y = pm25_ugm3)) +
  geom_point(color = "blue", alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relationship between NO₂ and PM₂․₅",
       x = "NO₂ (molecules/cm²)", y = "PM₂․₅ (µg/m³)") +
  theme_minimal()

p_no2_pm25

# Temperature vs O3 scatter with linear smoother
p_temp_o3 <- ggplot(data, aes(x = temp_C, y = o3_ppb)) +
  geom_point(color = "green", alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relationship between Temperature and O₃",
       x = "Temperature (°C)", y = "O₃ (ppb)") +
  theme_minimal()