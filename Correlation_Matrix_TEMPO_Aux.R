# Libraries
library(tidyverse)
library(corrplot)
library(readr)

# Load data
data <- read_csv("./data/all_merge.csv")

# Select numeric variables used in screenshots
num_vars <- data %>%
  select(no2, pm25_ugm3, o3_ppb, temp_C, rh_percent,
         wind_speed_mps, hcho, total_ozone_column,
         effective_cloud_fraction, radiative_cloud_fraction)

# Pearson correlation matrix (complete cases)
cor_mat <- cor(num_vars, use = "complete.obs", method = "pearson")

# Corrplot with styling similar to the screenshot
corrplot(
  cor_mat,
  method = "color",                  # colored cells
  addCoef.col = "black",             # coefficient labels
  tl.col = "black",                  # axis text color
  tl.srt = 45,                       # axis text rotation
  col = colorRampPalette(c("blue", "white", "red"))(200),
  title = "Correlation Matrix (TEMPO + Auxiliary Variables)",
  mar = c(0, 0, 2, 0)
)