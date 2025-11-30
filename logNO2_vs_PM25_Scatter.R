# Libraries
library(tidyverse)
library(readr)

# Load data
data <- read_csv("./data/all_merge.csv")

# log10(NO2) vs PM2.5
p_log_no2_pm25 <- ggplot(data, aes(x = log10(no2), y = pm25_ugm3)) +
  geom_point(color = "blue", alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relationship between log10(NO₂) and PM₂․₅",
       x = "log10(NO₂) (molecules/cm²)", y = "PM₂․₅ (µg/m³)") +
  theme_minimal()