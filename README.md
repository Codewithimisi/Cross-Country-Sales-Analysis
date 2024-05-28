# Cross-Country Sales Analysis

## Project Resources
[Dashboard](https://app.powerbi.com/links/oo15qGEuZf?ctid=b1a9df48-7114-4055-9473-b443a59687db&pbi_source=linkShare&bookmarkGuid=ea233688-cde0-4bcb-a1bf-de104b97246b)

[SQL Code Analysis](https://github.com/Codewithimisi/Cross-Country-Sales-Analysis/blob/main/SQL%20Code%20Analysis.sql)

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Cleaning Process](#cleaning-process)
- [Analysis Process](#analysis-process)
- [Key Findings](#key-findings)
- [Recommendations](#recommendations)
### Project Overview

After opening three stores in 2021 in the US, Australia, and Canada, EcoLiving-Essentials Mart seeks to analyze its business performance during the years 2022 and 2023.
The objective is not only to understand past performance but also to leverage these insights proactively to optimize product offerings, 
discover market trends, and enhance consumer interaction. 

This project aims to extract valuable insights into sales performance, customer demographics, sales trends over time, 
product preferences, and top customers across EcoLiving-Essentials Mart outlets within the specified timeframe and countries. 
By delving into this data, my objective is to empower decision-makers 
with actionable insights to optimize product offerings, refine marketing strategies, and enhance overall business operations.

### Data Sources

The analysis utilized three datasets: customer_data.csv, product_data.csv, and purchase_data.csv. These datasets provide comprehensive information on sales transactions, customer demographics, and product categories.

### Tools
- Excel - Data Cleaning
- MySQL - Data Analysis
- PowerBi - Data Visualization
  
### Cleaning Process
1. I used the CONCATENATE function to merge the first and last names of the customers, creating a full name column.
2. I separated the address column into individual columns for street, city, state, postal code, and country using the Text to Columns feature.
3. I segmented the customers' ages into age brackets using the IF function.
4. In the products data, I separated the product ID and name column using the Text to Columns feature.
   
### Analysis Process
Following the objective definition and data collection for this project, the subsequent steps were implemented:

1. Data importing: The clean data was loaded into the database.
  
2. Data Cleaning and Preprocessing: The raw data was cleaned and preprocessed to remove any inconsistencies or errors that could affect the analysis.

3. Exploratory Data Analysis (EDA): Exploratory data analysis was conducted to understand the distribution of sales, customer demographics, and product preferences. 

4. Sales Trend Analysis: I analyzed sales trends over time to identify seasonal patterns, peak sales periods, and areas for improvement in sales performance.

5. Customer Segmentation: Using demographic data,I segmented customers into different groups to better understand their preferences and purchasing behaviors.

6. Product Preference Analysis: I analyzed product sales across different demographics to identify popular products and areas for potential expansion or optimization.

7. Top Customers Analysis: I analyzed the behavior of top customers to develop targeted retention strategies and improve customer loyalty

8. Data Visualization with Power BI: Power BI was employed to create intuitive and dynamic visualizations that breathed life into the analyzed data. Through the creation of interactive dashboards and reports, key insights from the analysis were visually communicated in a clear and understandable manner.

### Key Findings
#### 1. Overall Sales Performance
During the analysis conducted within the specified timeframe, the store located in the United States emerged with the highest sales, while the store in Australia had
the lowest sales.

#### 2. Yearly Sales Performance

In 2022, the Canadian store made the highest sales, while the Australian store made the lowest. 
However, in 2023, the store in the United States had the most sales, while the one in Australia had the lowest sales.

#### 3. Customer Demographics

The predominant age group of customers falls within the 21-40 age range, with a slightly higher representation of female customers. Notably, Australia recorded the highest number of customers overall.
<details>
  <summary>Specific Customer Demographic Insights</summary>
  
In Australia, the majority of customers fall within the 41-50 age range, with a negligible higher representation of male customers compared to females.

In Canada, the majority of customers fall within the 31-40 age range, with a significant higher representation of female customers.

In the United States, the majority of customers are evenly distributed between two age brackets: those aged 21-30yrs and those aged 51yrs and above, with a higher proportion of male customers.

  </details>
  
#### 4. Sales Trends
Total sales and units purchased experienced a decline in 2023 compared to 2022, indicating a potential decrease in sales performance in the latter year.
Notably, total sales in 2022 exceeded those in 2023 in both Canada and Australia. However, in the United States, there was a better sales performance in 2023 compared 
to 2022.
<details>
  <summary>Monthly Sales Trend</summary>
  
In 2023, March recorded the highest sum of total sales, showing a significant increase of 271.12% compared to May, which had the lowest sum of total sales.

Conversely, in 2022, October emerged as the month with the highest sum of total sales, surpassing April, which had the lowest sum of total sales by 257.40%.

  </details>

#### 5. Product Preferences by Demographics

Regarding total units purchased, kitchen appliances and kitchen accessories hold the top ranks, while electronics rank the lowest. However, in terms of total sales, furniture and electronics emerge as the leading categories, whereas home accessories rank at the bottom.
<details>
  <summary>Demographic-specific Product Preferences</summary>
  
  
  **IN TERMS OF UNITS PURCHASED**
  
  **Age Group: 21-30 years**

  Australia and Canada: Kitchen appliances stand out as the most frequently purchased category, whereas home accessories are least frequently purchased.

  United States: Kitchen accessories are the most frequently purchased, with furniture being the least.
  
  **Age Group: 31-40 years**

  Australia:  kitchen appliances take the lead in frequency of purchase, while electronics is the least.
  
  Canada: Kitchen appliances is the most frequently purchased category, while home accessories record the least.

  United States: kitchen appliances, home accessories, and furniture share the top spot in frequency of purchase, with electronics ranking the lowest.

  **Age Group: 41-50 years**
  
  Australia and Canada: Kitchen accessories is the most frequently purchased category, with electronics being the least.

  United States: Kitchen appliances is the most frequently purchased category, while electronics record the least.

  **Age Group: 51+ years**
  
  Australia: Kitchen accessories top the units purchased category, while home accessories rank the lowest. Electronics record no purchases.

  Canada: Home accessories top the units purchased category, while kitchen accessories rank the lowest. Electronics record no purchases.

  United States: Furniture top the units purchased category, while electronics rank the lowest.


  **IN TERMS OF TOTAL SALES**

  **Age Group: 21-30 years**
  
 Across all 3 countries, electronics recorded the highest sales while home accessories recorded the lowest

  **Age Group: 31-40 years**
  
Australia: Electronics made the highest sales while kitchen accessories made the least.

Canada: Electronics made the highest sales while home accessories made the least.

United States: Furniture recorded the highest sales while kitchen accessories recorded the lowest.

  **Age Group: 41-50 years**
  
Australia and Canada: Electronics made the highest sales while home accessories made the lowest 

United States: Furniture made the highest sales while electronics made the lowest

  **Age Group: 51+ years**
  
Australia: Furniture made the highest sales while home accessories made the lowest.

Canada and United States: Furniture made the highest sales while kitchen accessories made the lowest.

</details>


#### 6. Top Customers

In terms of total sales, the top 10 customers across all branches, listed in descending order, are as follows: customers with IDs 9, 100, 231, 60, 24, 125, 21, 49, 191, and 20. 
When considering total units purchased, the top 11 customers across all branches, also listed in descending order, are identified by the following IDs: 21, 9, 47, 231, 67, 22, 100, 24, 191, 94, and 5
<details>
  <summary>Country Specific Insights</summary>

 **IN TERMS OF TOTAL SALES**
 
In Australia, the top 10 customers, ranked in descending order are customers with id; 60, 81, 120, 48, 111, 195, 161, 46, 220 and 99

In Canada, the top 10 customers, ranked in descending order are customers with id; 100, 231, 125, 49, 191, 67, 94, 122, 103 and 47

In United States, the top 10 customers, ranked in descending order are customers with id; 9, 24,21,20, 184, 109, 30, 121, 13 and 56

 **IN TERMS OF UNITS PURCHASED**
 
In Australia, the top 9 customers, ranked in descending order, have the following IDs: 60, 126, 48, 96, 99, 46, 81, 90, and 76.

In Canada, the top 9 customers, listed in descending order, have the following IDs: 47, 231, 67, 100, 191, 94, 32, 110, and 103.

In the United States, the top 11 customers,listed in descending order, have the following IDs: 21, 9, 22, 24, 5, 226, 104, 14, 16, 139, and 162.

</details>

### Recommendations
Based on this analysis, I give the following recommendations:

#### 1. Sales Trend Analysis
I recommend implementing dynamic pricing strategies to leverage peak sales periods effectively.
Additionally, investing in targeted marketing campaigns during these peak periods can maximize revenue opportunities.

#### 2. Customer Segmentation:
I recommend personalizing marketing efforts according to customer segments to boost engagement and conversion rates.
Additionally, Tailor product offerings to meet the specific needs and preferences of different customer segments.

#### 3. Product Preference Analysis:
I recommend allocating resources towards the development and promotion of popular products in each country to drive sales.
Additionally, it's essential to conduct market research to identify emerging trends and capitalize on new opportunities.

#### 4. Top Customers Analysis:
I recommend developing loyalty programs or incentives to retain top customers and encourage repeat purchases.
Additionally, offering personalized discounts or promotions tailored to individual customer preferences can further enhance customer loyalty.
