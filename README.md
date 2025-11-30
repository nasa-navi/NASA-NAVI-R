## **AIRBENDER: NASA TEMPO-based Personalized Air Quality Forecasting System**

**Members:**  
- [JIHO RYU](https://github.com/ryujihos0105)  
- [JEONG AH YOON](https://github.com/jjyoon012-git)  
- [Jihoon Jung ](https://github.com/jeehun3020)


**DEMO:** [AIRBENDER Demo Video (YouTube)](https://www.youtube.com/watch?v=VvfAQruD_C0)

---

## **1. Project Overview**

The **AIRBENDER** project utilizes NASA’s **TEMPO satellite atmospheric data** to predict air pollution levels and ozone concentration, providing personalized behavioral recommendations through an **AI-driven data mining system**.

The system integrates TEMPO Level-3 Version 2 & 3 datasets (NO₂, O₃, HCHO, Cloud Fraction) and trains a forecasting model using **Google Cloud Vertex AI Forecasting**. It also analyzes correlations among atmospheric and meteorological factors.

Additionally, it generates LLM-based personalized notifications considering user context such as location, occupation, and health status.

---

## **2. Dataset and Preprocessing**

### **2.1 Data Sources**

- **NASA EarthData TEMPO**
  - TEMPO (Tropospheric Emissions: Monitoring of Pollution) is a geostationary satellite developed by NASA and the Smithsonian Astrophysical Observatory that observes hourly air quality metrics across North America.
  - Datasets used:
    - NO₂ L3 V03 (C2930763263-LARC_CLOUD)
    - HCHO L3 V03 (C2930761273-LARC_CLOUD)
    - O₃ L3 V03 (C2930784064-LARC_CLOUD)
    - Cloud Fraction (effective, radiative) / CLDO4 L2 V03
- **Supplementary Datasets**
  - **OpenAQ API:** Ground-based air quality observations (PM₂.₅, O₃) for validation.
  - **Open-Meteo API:** Weather variables (temperature, humidity, wind speed) synchronized to TEMPO’s hourly grid.

All datasets were merged based on UTC timestamps and resampled hourly. Missing values were linearly interpolated and units standardized.

---

### **2.2 Data Processing Steps**

1. **Data Acquisition**
   - Retrieved via `earthaccess` API from NASA Earthdata Cloud (June–August 2025, NYC region: BBOX = -74.3, 40.4, -73.6, 41.0).
   - Converted NetCDF files to CSV format using `xarray` and `pandas`.
2. **Preprocessing**
   - **Spatial & Temporal Alignment:** TEMPO grids matched with OpenAQ and Open-Meteo data.
   - **Missing & Outlier Handling:** Linear interpolation; replaced unavailable hours (00–09, 22–24) with adjacent data.
   - **Normalization:** Applied Min–Max scaling (0–1) per variable group.

---

## **3. Exploratory Analysis & Visualization**

### **3.1 Structure Validation**
- Hourly **PM₂.₅** line plots and **NO₂** boxplots verified consistent time-series integrity.

### **3.2 Correlation Analysis**
- Pearson correlation (via `corrplot`) identified major relationships:
  - **NO₂–PM₂.₅:** Positive correlation → secondary aerosol formation.
  - **Temperature–O₃:** Strong positive correlation → photochemical activity.
  - **Humidity–PM₂.₅:** Positive correlation → hygroscopic particle growth.
  - **Wind speed–pollutants:** Negative correlation → dispersion effect.

### **3.3 Temporal Pattern Analysis**
- **O₃ Hourly Pattern:** Peaks at 14–16 UTC; troughs around 10–11 UTC.
- **Weekend vs Weekday:** Higher early-morning ozone on weekends (Weekend Effect).
- **Monthly × Hourly Heatmap:** Clear diurnal pattern showing rising ozone during daylight hours.

---

## **4. Modeling and Forecasting**

| Setting | Value |
| --- | --- |
| **Model** | Vertex AI Forecasting (AutoML Regression) |
| **Target** | O₃_ppb |
| **Features** | rh_percent, temp_C, wind_speed_mps, time_utc |
| **Training Period** | 2023–2025 |
| **Forecast Horizon** | 72 hours |

---

## **5. Performance Evaluation**

| Metric | Value |
| --- | --- |
| MAE | 5.639 |
| MAPE | 21.83 |
| RMSE | 7.05 |
| RMSLE | 0.246 |
| R² | 0.569 |

The model explains **56.9% of ozone variability** and demonstrates stable predictive accuracy suitable for short-term forecasting.

---

## **6. Feature Importance**

| Rank | Feature | Contribution |
| --- | --- | --- |
| 1 | rh_percent | ~30% |
| 2 | temp_C | ~20% |
| 3 | time_utc | ~15% |
| 4 | o3_ppb (lag) | ~13% |
| 5 | wind_speed_mps | ~9% |
| 6 | hcho_log10 | ~5% |

Humidity and temperature are dominant contributors, aligning with physical atmospheric chemistry.

---

## **7. System Architecture**

| Step | Component | Description |
| --- | --- | --- |
| 1 | TEMPO CSV → GCS Input Bucket | Upload latest satellite data |
| 2 | Vertex AI Forecasting | Run O₃/PM₂.₅ predictions |
| 3 | GCS Output Bucket | Store predictions (`predictions.csv`) |
| 4 | Cloud Function / Run | Serve forecasts via API |
| 5 | Cloud Scheduler | Automate periodic execution |

---

## **8. Conclusion**

This project demonstrates a **fusion of satellite-based air quality data and AI forecasting** to build a **human-centric environmental intelligence platform**.

- Established **satellite + meteorological AI model** for ozone prediction.  
- Achieved stable short-term forecasting performance.  
- Enabled **LLM-based personalized alerting** for actionable health recommendations.  

> From EarthData to Action 🌍