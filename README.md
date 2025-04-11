# Weather-Aware Bike-Sharing Demand Forecasting in Seoul

This capstone project explores how weather conditions influence bike-sharing demand in urban areas, using **Seoul** as a case study. By applying **data science techniques in R**, the project builds predictive models and a dashboard to help city planners optimize bike availability based on weather forecasts.

---

## Project Objective

To analyze the impact of weather on bike-sharing demand and **develop a predictive dashboard** using machine learning and interactive visualization tools to assist urban mobility decision-making.

---

## Methodology

### 1. **Data Collection**
- **Web Scraping**: Extracted global bike-sharing systems data from Wikipedia using `rvest`.
- **API Data**: Collected weather forecasts from **OpenWeather API** using `httr`.

### 2. **Data Wrangling**
- **Regex**: Cleaned scraped data by removing unwanted characters and extracting meaningful values.
- **dplyr**: Handled missing values, created dummy variables, and normalized numerical data.

### 3. **Exploratory Data Analysis (EDA)**
- **SQL**: Queried rental patterns by date, time, season, and holidays.
- **Visualization**: Plotted trends using histograms, boxplots, scatter plots, and line graphs.

### 4. **Predictive Modeling**
- Built and refined **linear regression models** to predict demand using features like temperature, humidity, and datetime.
- Used metrics like **RMSE** and **R²** for model evaluation.
- Explored feature importance to improve performance.

### 5. **Dashboard with R Shiny**
- Developed an interactive dashboard that:
  - Displays city-specific demand predictions
  - Visualizes humidity vs. bike demand
  - Plots 5-day temperature forecasts
  - Maps bike-sharing demand with color-coded markers

---

## Key Insights

- **Summer evenings (around 6 PM)** have peak bike demand.
- **Temperature and humidity** are the most significant predictors.
- **Wind speed and visibility** have negligible influence.
- The best performing model achieved **R² = 0.88** using **Gradient Boosting**.

---

## Technologies Used

- **Languages**: R
- **Libraries**: `dplyr`, `rvest`, `httr`, `ggplot2`, `plotly`, `shiny`, `lubridate`, `stringr`
- **Tools**: RStudio, OpenWeather API, R Shiny
- **Data Sources**:
  - Seoul Bike Sharing Demand Dataset
  - OpenWeather API
  - Wikipedia: List of Bicycle-Sharing Systems

 ---

 ## Files in the Repository

1. **`Data Collection with Web Scraping.ipynb`** – Scrapes global bike-sharing system data from Wikipedia using `rvest` and exports the cleaned dataset.
2. **`Data Collection with OpenWeather API.ipynb`** – Collects 5-day weather forecast data for selected cities using the OpenWeather API.
3. **`Data Wrangling with regex.ipynb`** – Cleans scraped data using regular expressions to remove unwanted characters and standardize values.
4. **`Data wrangling with dplyr.ipynb`** – Performs feature engineering, missing value imputation, and data normalization using `dplyr`.
5. **`EDA with SQL.ipynb`** – Uses SQL queries to extract insights like seasonality, rental trends by hour, and weather impacts.
6. **`EDA with Data Visualization.ipynb`** – Visualizes data distributions and patterns using scatter plots, histograms, bar charts, and boxplots.
7. **`Linear Models Baseline.ipynb`** – Builds an initial linear regression model and evaluates its predictive performance.
8. **`Linear Models Refinements.ipynb`** – Enhances the baseline model by selecting relevant features and improving performance.
9. **`Dashboard with R Shiny`**
   - `model_prediction.R` – Predicts bike-sharing demand based on temperature and humidity.
   - `server.R` – Backend logic for the interactive Shiny dashboard.
   - `ui.R` – Frontend layout and controls for user interactions.
   - `model.csv`, `selected_cities.csv` – Supporting data files for prediction and visualization.
10. **`Final Report.pdf`** – Comprehensive report with methodology, results, insights, and screenshots of the final dashboard.

---

## Acknowledgments

This project is part of the **IBM Data Analytics with Excel and R Capstone** on Coursera and showcases end-to-end skills in data collection, wrangling, analysis, modeling, and dashboarding.  

Special thanks to:
- **Seoul Bike Sharing Service** – For providing the rental dataset.
- **OpenWeather API** – For weather forecast data used in prediction modeling.
- **Wikipedia** – For open access to global bike-sharing system information.
- **R programming community** – For libraries like `dplyr`, `ggplot2`, `shiny`, `rvest`, `plotly`, and others that made this project possible.
