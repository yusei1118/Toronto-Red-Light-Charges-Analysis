# Toronto Red Light Camera Charges Analysis


<img width="2438" height="1528" alt="Dashboard 1 (1)" src="https://github.com/user-attachments/assets/1ed2db92-b240-45a1-850d-019cad0a054e" />






# Dashboard


## 🚦 [Toronto Red Light Camera Charges Analysis Dashboard](https://public.tableau.com/app/profile/yusei.hosoya/viz/TorontoRedLightsChargesAnalysis/Dashboard1)

# Overview

This project analyzes Toronto's Red Light Camera (RLC) system by combining multiple public datasets and transforming them into an interactive Tableau dashboard focused on traffic violations, camera distribution, and geographical enforcement trends across the city.

The dashboard allows users to explore how red light camera charges have changed over time, where violations are concentrated, and how camera installation patterns may influence driver behavior.

A major focus of this project was not only visualization, but also solving a difficult real-world data integration problem.

---

# Project Goals

The main goals of this project were:

* Analyze year-over-year changes in red light camera violations
* Visualize where violations occur most frequently in Toronto
* Compare the growth of camera installations with violation trends
* Explore whether certain areas are under-monitored
* Create a fully interactive spatial dashboard using Tableau
* Practice advanced SQL data cleaning and geospatial preparation

---

# Tools Used

* BigQuery SQL
* Tableau Public
* GIS / Spatial Data
* CSV Data Cleaning
* Manual Data Reconciliation

---

# Datasets Used

This project combines multiple datasets related to:

* Red Light Camera Charges
* Camera Locations
* Toronto Ward Boundaries
* Geospatial Intersection Data

One of the biggest challenges of this project was that the datasets did not share a reliable common intersection ID.

Because of this, I had to build a custom matching system based on intersection names.

---

# Data Cleaning & Data Engineering Process

This project required extensive preprocessing before visualization could begin.

## Major Challenges

### 1. No Shared Intersection ID

The datasets used different naming systems and lacked a universal identifier.

For example:

* Some datasets used `&`
* Others used `AND`
* Directional suffixes such as `E`, `W`, `N`, and `S` were inconsistent
* Street order frequently changed
* Some intersections had punctuation differences or abbreviations

This made direct joins impossible.

---

## Custom SQL Matching Logic

To solve this, I created a multi-step cleaning and matching process in SQL.

The workflow included:

* Standardizing street names
* Converting symbols (`&` → `AND`)
* Removing punctuation
* Removing directional suffixes
* Splitting intersections into Street 1 and Street 2
* Matching both normal and reversed street orders
* Building additional lookup logic for unmatched locations

Example logic:

```sql
street_1 = street_1 AND street_2 = street_2
OR
street_1 = street_2 AND street_2 = street_1
```

Even after automated cleaning, some intersections still produced null values.

To resolve this, I manually investigated naming patterns and corrected unmatched records one by one.

This part of the project took a significant amount of time, but it was also one of the most valuable learning experiences because it reflected the reality of working with messy public datasets.

---

# Dashboard Features

## Interactive Year Slider

Below the title section, users can interact with the year slider.

Changing the selected year automatically updates:

* KPIs
* Maps
* Top 10 locations
* Charges
* Area comparisons
* Trend visualizations

This was built using Tableau Parameters and Actions.

---

## KPI Cards

The KPI section allows users to quickly compare:

* Total charges
* Total camera installations
* Year-over-year changes

This helps users immediately understand how traffic enforcement changes over time.

---

## Cameras and Charges Over Time

The graph in the upper-right corner visualizes:

* Growth in camera installations
* Changes in traffic violations over time

The relationship between these two variables becomes one of the most important insights in the project.

Periods where camera installations increased sharply often coincided with large increases in recorded violations.

---

## Top 10 Locations by Charges

The bar chart on the left highlights the intersections with the highest number of red light camera charges.

Many of these locations are:

* Major arterial intersections
* Highway access points
* High-traffic commuter corridors

This immediately reveals which areas may require stronger enforcement or improved road design.

---

## Spatial Map Visualization

The central map visualizes where violations are concentrated across Toronto.

The visualization uses:

* Color intensity
* Bubble size
* Spatial clustering

This makes high-risk areas easy to identify visually.

The map also includes Tableau Actions, meaning that selecting a location dynamically updates related visualizations.

This interaction creates a much stronger exploratory experience for the user.

---

## Area-Based Visualization

The lower-right map summarizes camera distribution by area.

This helps reveal whether camera installations are evenly distributed across the city.

It also highlights geographic imbalances in enforcement coverage.

---

# Key Findings & Insights

## 1. Toronto Had 254 Cameras Installed by 2025

As of 2025, Toronto had approximately 254 red light cameras installed across the city.

The number of cameras increased significantly during several key periods:

* 2008–2010
* 2016–2018
* 2021–2023

These periods also showed some of the largest increases in recorded violations.

---

## 2. 2023 Recorded the Highest Number of Violations

In 2023, Toronto recorded approximately 170,000 red light camera charges — the highest number observed in the dataset.

This suggests that dangerous driving behavior remains a major issue despite increased enforcement.

---

## 3. Camera Installations and Violations Are Strongly Related

One of the clearest trends in the dashboard is that increases in camera installations are often followed by increases in recorded charges.

This likely does not mean drivers suddenly became worse.

Instead, it suggests:

* Many violations were previously undetected
* Enforcement expansion reveals existing driver behavior
* Traffic violations may be more common than expected

Interestingly, during years where the number of cameras remained stable, violation counts also tended to stabilize.

---

## 4. 2024 Was an Unusual Year

2024 was the only year where violations decreased significantly despite an increase in camera installations.

Approximately 20,000 fewer violations were recorded compared to the previous year.

Possible explanations may include:

* Drivers becoming more aware of enforcement
* Behavioral adaptation
* Road design improvements
* Changes in traffic volume

This would be an interesting direction for future research.

---

## 5. Scarborough and Highway Access Areas Showed High Violations

The dashboard revealed particularly high concentrations of violations in:

* Scarborough
* Highway entrance corridors
* Major intersections near Highway 401

Many of the highest-charge intersections appear connected to:

* High-speed traffic flow
* Highway merging behavior
* Large commuter routes

This suggests that road design and traffic patterns may strongly influence red light violations.

---

## 6. Downtown Toronto Surprisingly Had Limited Camera Coverage

One surprising finding was that several dense downtown areas appeared to have relatively low camera coverage.

Meanwhile, some outer regions showed much higher installation density.

This raises important questions:

* Are some high-risk areas under-monitored?
* Are cameras being distributed evenly?
* Should more cameras be installed near downtown intersections?

Even lakeside areas with relatively high camera density still showed high violation counts.

This suggests additional enforcement and further statistical monitoring may still be necessary.

---

# Final Conclusion

This project demonstrates how spatial analytics and public safety data can be combined to better understand traffic enforcement patterns in Toronto.

The findings suggest that red light violations remain a widespread issue across the city, particularly near highway access corridors and major commuter intersections.

The analysis also shows that increasing enforcement infrastructure consistently reveals large numbers of violations, suggesting that unsafe driving behavior may be more common than expected.

At the same time, the uneven geographic distribution of cameras raises important questions about enforcement coverage and urban planning strategy.

This project reinforced several important lessons for me:

* Real-world datasets are messy and rarely connect cleanly
* Data cleaning can be more difficult than visualization itself
* Spatial analysis adds powerful context to traffic data
* Interactive dashboards help users discover patterns much faster than static reports

Overall, this project was both a technical data engineering challenge and a practical urban analytics study.

---

# Skills Demonstrated

* Advanced SQL cleaning and transformation
* Complex JOIN and matching logic
* Geospatial data preparation
* Tableau dashboard development
* Interactive dashboard actions
* Parameter-driven analysis
* Data storytelling
* Spatial trend analysis
* Real-world public data integration

---

# Author

Yusei Hosoya

* Tableau Public: [https://public.tableau.com/app/profile/yusei.hosoya](https://public.tableau.com/app/profile/yusei.hosoya)
* GitHub: [https://github.com/yusei1118](https://github.com/yusei1118)
