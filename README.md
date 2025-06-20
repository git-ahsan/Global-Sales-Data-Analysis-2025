# 🛍️ Global Sales Analytics & Profitability Prediction (2025)

This project demonstrates a complete data science workflow—starting from SQL-based data extraction and Power BI dashboarding, to predictive modeling using Python. It analyzes global sales transactions across 6 countries: **Canada, China, India, Nigeria, UK, and US** to uncover key insights in revenue, profit, and product performance—and uses machine learning to predict profitability from product-level data.

---

## 📌 Project Objectives
✅ Integrate and clean multi-country sales data using SQL

📊 Enrich data with KPIs like Revenue, COGS, and Profit

🔍 Analyze performance by country, category, product, store, and sales rep

📈 Visualize key insights through an interactive Power BI dashboard

🤖 Predict product-level profitability using machine learning (Linear Regression)

📦 Build a reproducible pipeline from raw data to business insight and prediction

---

## 🧰 Tools & Technologies
- **Database**: PostgreSQL  
- **Data Visualization**: Microsoft Power BI  
- **Languages**: SQL, DAX, Python
- **Machine Learning**: Scikit-learn (Linear Regression), Pandas, Numpy, Matplotlib
- **Version Control**: Git, GitHub

---
## 🧮 SQL Process Overview

📁 File: [Global Sales Trends SQL Analysis](https://github.com/git-ahsan/Global-Sales-Data-Analysis-2025/blob/main/Global%20Sales%20Trends.sql)
### 1. Database Setup
- **Database Creation**: The project starts by creating a database named `Data Professionals`.
- **Table Creation**: Unified sales data from 6 country-specific CSV files into a single PostgreSQL table for holistic analysis. This is achieved through a two-step process:

**i) Individual Table Creation & Import**: 
Created individual tables for each country (Canada, China, India, Nigeria, UK, US) with identical 15-column schemas before merging.

**ii) Global Data Consolidation**: Combined all records into `Global Sales Data` using `UNION ALL` to preserve transactional integrity. The SQL query used for this consolidation is as follows:
```sql
CREATE TABLE public."Global Sales Data" as
select * from public."Sales Canada"
UNION ALL
SELECT * FROM public."Sales China"
Union all
SELECT * FROM public."Sales India"
Union all
SELECT * FROM public."Sales Nigeria"
Union all
SELECT * FROM public."Sales UK"
Union all
SELECT * FROM public."Sales US"
```

### 2. Data Exploration & Cleaning

1. **Record Count**: Determine the total number of records in the dataset:
```sql
select count(*) from public." Global Sales Data";
```
2. **Category Count**: Identify all unique product categories in the dataset:
```sql
SELECT DISTINCT "Category" from public." Global Sales Data";
```
3. **Null Value Check**: Check for any null values in the dataset and delete records with missing data:
```sql
select * from public." Global Sales Data"
where 
"Transaction ID" is null or "Date" is null or "Country" is null or "Product ID" is null or "Product Name" is null or "Category" is null or "Price Per Unit" is null or "Quantity Purchased" is null or "Cost Price" is null or "Discount Applied" is null or "Payment Method" is null or "Customer Age Group" is null or "Customer Gender" is null or "Store Location" is null or "Sales Representative" is null;
```
4. **Handle Null values**: i) Update NULL values in the "Quantity Purchased" column with the most common quantities for for the "Beauty" product category in Nigeria.
```sql
SELECT
    "Quantity Purchased", COUNT(*) AS frequency from public."Global Sales Data"
WHERE "Country" = 'Nigeria' AND "Category" = 'Beauty'
GROUP BY
    "Quantity Purchased"
ORDER BY
    frequency DESC
limit 1;

update public."Global Sales Data"
set "Quantity Purchased" = 5
where "Transaction ID" = '00a30472-89a0-4688-9d33-67ea8ccf7aea';
```
ii) Update NULL values in the "Price Per Unit" column using the average "Price Per Unit" for the "Sports" product category in the US.
```sql
update public."Global Sales Data"
set "Price Per Unit" = (
    SELECT AVG("Price Per Unit") from public."Global Sales Data"
where "Country"= 'US' and "Category"='Sports' and "Price Per Unit" is not null
)
where "Transaction ID" = '001898f7-b696-4356-91dc-8f2b73d09c63';
```
5. **Checking for duplicate values**: To ensure that each transaction has a unique ID, which is typically expected in clean, reliable sales data
```sql
select "Transaction ID", count(*) from public."Global Sales Data"
group by "Transaction ID"
having count(*)>1;
```
6. **Adding and Calculating Sales Revenue**: Add a Sales Revenue column and calculate its value for all records:
```sql
Alter table public."Global Sales Data"
add column "Sales Revenue" Numeric(10,2);

update public."Global Sales Data"
set "Sales Revenue"=("Price Per Unit" * "Quantity Purchased") - "Discount Applied";
```
7. **Adding and Calculating Cost of Goods Sold(COGS)**: Add a Cost of Goods Sold column and calculate its value for all records:
```sql
Alter table public."Global Sales Data"
add column "Cost of Goods Sold" Numeric(10,2);

update public."Global Sales Data"
set "Cost of Goods Sold"= "Price Per Unit" * "Quantity Purchased";
```
8. **Adding and Calculating Profit**: Add a Profit column and calculate its value for all records:
```sql
Alter table public."Global Sales Data"
add column "Profit" Numeric(10,2);

update public."Global Sales Data"
set "Profit"= "Sales Revenue" - "Cost of Goods Sold";
```
### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2025-07-16**:
```sql
select * from public."Global Sales Data"
WHERE "Date" = '2025-07-16';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 5 in the month of July-2025**:
```sql
select * from public."Global Sales Data"
WHERE   
	"Category" = 'Beauty'
    AND 
    TO_CHAR("Date", 'YYYY-MM') = '2025-07'
    AND
    "Quantity Purchased" >= 5;
```
3. **Write a SQL query to calculate the Total_Sales for each category.**:
```sql
SELECT "Category", SUM("Sales Revenue") as "Total Sales" FROM public."Global Sales Data"
GROUP BY "Category"
order by "Total Sales" desc;
```
4. **Write a SQL query to find all transactions where the Sales Revenue is less than 500.**:
```sql
SELECT * FROM public."Global Sales Data"
WHERE "Sales Revenue" < 500;
```
5. **How many transactions occurred for each product category, broken down by customer gender?**:
```sql
SELECT "Category", "Customer Gender", COUNT(*) as "Total_Transactions"
FROM public."Global Sales Data"
GROUP BY "Category", "Customer Gender"
ORDER BY "Category";
```
6. **What is the Total revenue, Total COGS, and Total profit for each country, sorted by Total profit for the month of January, 2025?**:
```sql
select "Country",
	sum("Sales Revenue") as "Total Revenue", 
	sum("Cost of Goods Sold") as "Total COGS",
	sum("Profit") as "Total Profit"
from public."Global Sales Data"
where "Date" between '2025-01-01' and '2025-01-31'
group by "Country"
order by "Total Profit";
```
7. **What are the top 5 best-selling products by total units sold in February 2025?**:
```sql
SELECT 
    "Product Name", 
    SUM("Quantity Purchased") AS "Total Units Sold"
FROM public."Global Sales Data"
WHERE "Date" BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY "Product Name"
ORDER BY "Total Units Sold" DESC
LIMIT 5;
```
8. **Which top 10 Best Sales representatives generated the highest combined score (50% revenue + 50% profit) during February 2025?**:
```sql
select "Sales Representative",
sum("Sales Revenue") as "Total Revenue",
SUM("Profit") AS "Total Profit",
(.5*sum("Sales Revenue")+.5*sum("Profit")) as "Total Score" from public."Global Sales Data"
where "Date" between '2025-02-01' and '2025-02-28'
group by "Sales Representative"
Order by "Total Score" Desc
limit 10;
```
9. **Which 10 Store locations had the highest weighted performance scores (40% revenue + 60% profit) during February 2025?**:
```sql
select "Store Location",
sum("Sales Revenue") as "Total Revenue",
SUM("Profit") AS "Total Profit",
(.4*sum("Sales Revenue")+.6*sum("Profit")) as "Total Score" from public."Global Sales Data"
where "Date" between '2025-02-01' and '2025-02-28'
group by "Store Location"
Order by "Total Score" Desc
limit 10;
```
10. **What are the key Sales Revenue, Cost of Goods Sold and Profit insights?**:
```sql
select
	MIN("Sales Revenue") AS "Min Sales Value",
    MAX("Sales Revenue") AS "Max Sales Value",
    AVG("Sales Revenue") AS "Avg Sales Value",
    SUM("Sales Revenue") AS "Total Sales Value",
    MIN("Cost of Goods Sold") AS "Min COGS",
    MAX("Cost of Goods Sold") AS "Max COGS",
    AVG("Cost of Goods Sold") AS "Avg COGS",
    SUM("Cost of Goods Sold") AS "Total COGS",
	MIN("Profit") AS "Min Profit",
    MAX("Profit") AS "Max Profit",
    AVG("Profit") AS "Avg Profit",
    SUM("Profit") AS "Total Profit"
FROM public."Global Sales Data";
```
## 📊 Power BI Dashboard Overview
📁 File: [Global Sales Trends Power BI Analysis](https://github.com/git-ahsan/Global-Sales-Data-Analysis-2025/blob/main/Sales%20Data%20Dashboard.pbix)
### 📊 Power BI Measures
- `Total Sales`, `Total Profit`, `Total Cost`, `Total Discount`
- `Total Orders` and `Average Order Value`
- Custom visuals: Map, Line chart, Bar chart, Pie chart

---

The dashboard contains multiple interactive views:
- 🔹 **KPIs**: Total Sales, Profit, Orders, Discounts, AOV
- 📈 **Sales Trends**: Monthly and daily breakdowns
- 🌍 **Geo Analysis**: Revenue & profit by country and store
- 🛍️ **Category/Product Insights**: Best-selling and underperforming products
- 👤 **Customer Segments**: Age group, gender distribution
- 💳 **Payment Methods**: Popular payment types

> All measures (e.g., `Total Sales`, `Total Profit`, `Average Order Value`) were calculated using **DAX** inside Power BI.

---

## 🔑 Key Insights

✅ Total Sales: 4.14M+  
✅ Highest Profit Country: UK  
✅ Most Orders by Age Group: 25–34  
✅ Top Store Location: Birmingham  
✅ Most Used Payment Method: Credit Card  
✅ Peak Sales Month: December

---

## 📷 Dashboard Preview

![Sales Dashboard Preview](https://github.com/git-ahsan/Global-Sales-Data-Analysis-2025/blob/main/Dashboard%20Preview.jpg)
---

## ⚙️ Machine Learning Workflow Steps
This section outlines the full machine learning pipeline used for predicting profitability from cleaned sales data, including preprocessing, feature engineering, model training, and evaluation.

### 1. 📥 Data Import & Initial Cleanup
The dataset was loaded from a .csv file exported from the **PostgreSQL.** Redundant columns such as **Product ID** and **Product Name** were removed to retain only relevant numeric and categorical features.
```python
import pandas as pd
import numpy as np

df = pd.read_csv("C:/Users/hp/Downloads/Sales forc cus seg raw file.csv", encoding = 'unicode_escape')
df

df = df.drop(columns=["Transaction ID", "Date", "Product ID", "Product Name", "Sales Representative"])
df
```

### 2. 🧹 Data Validation
Before modeling, the dataset was inspected for missing values.

```python
df.isnull().sum()
```

### 3. 📐 Feature Engineering
No new code in this step. The dataset included precomputed business metrics, including:

- **Sales Revenue:** (Quantity × Price) - Discount

- **Cost of Goods Sold:** (Cost Price × Quantity)

- **Profit (target variable):** Sales Revenue - COGS

To prevent target leakage, features such as **Sales Revenue** and **COGS** were removed prior to modeling.

### 4. 🔠 Label Encoding for Categorical Columns
All categorical (object-type) columns were automatically identified and label encoded.

```python
from sklearn.preprocessing import LabelEncoder
Encoder = LabelEncoder()
Objncode = df.select_dtypes(include='object').columns
for col in Objncode:
    df[col] = Encoder.fit_transform(df[col])
```

### 📏 Feature Scaling
The feature matrix (X) was scaled using StandardScaler, excluding the target variable (Profit).

```python
from sklearn.preprocessing import StandardScaler as stsc

X = df.drop("Profit", axis=1)
y = df["Profit"]

scaler = stsc()
X_scaled = scaler.fit_transform(X)
X_scaled
```

### 6. 🧠 Model Training – Linear Regression
Applied a Linear Regression model to predict Profit using an 75/25 train-test split.

```python
from sklearn.model_selection import train_test_split as tts
from sklearn.linear_model import LinearRegression

#Split the dataset
X_train, X_test, y_train, y_test = tts(X_scaled, y, test_size=0.25, random_state=42)

#Train Linear Regression model
lr = LinearRegression()
lr.fit(X_train, y_train)
```

### 7. 📊 Model Evaluation
Assessed the model's predictive performance using R² Score, Root Mean Squared Error (RMSE), and the model’s built-in .score() method. The evaluation started with generating predictions:

```python
y_pred = lr.predict(X_test)
```

Then performance was measured using the following metrics:
```python
# Direct evaluation using model's internal score method (R²)
print("Model Score (R²):", lr.score(X_test, y_test))

# Manual evaluation
print("R2 Score:", r2_score(y_test, y_pred))
print("RMSE:", np.sqrt(mean_squared_error(y_test, y_pred)))


```

### 8. 📈 Visualization & Correlation Analysis
Visualized model prediction accuracy and explored feature relationships using a combination of **Matplotlib** and **Seaborn**, with custom styling for enhanced readability and presentation.
```python
import matplotlib.pyplot as plt
import seaborn as sns

#### 🔹Actual vs Predicted Profit Visualization

plt.figure(figsize=(8, 5), facecolor="#AAF4CA")
sns.scatterplot(x=y_test, y=y_pred, color="#8B008B", marker='s', s=80, alpha=0.7, edgecolor='yellow')
plt.xlabel("Actual Profit", fontsize=12)
plt.ylabel("Predicted Profit", fontsize=12)
plt.title("Actual vs Predicted Profit", fontsize=14, fontweight='bold')
plt.xticks(range(0, 2001, 200))
plt.yticks(range(0, 2001, 200))
plt.grid(True, linestyle=':', linewidth=0.7)
plt.tight_layout()
plt.show()

#### 🔹Feature Correlation Heatmap

plt.figure(figsize=(12, 10), facecolor="#AADAF4")

corr = df.corr().round(2)

sns.heatmap(
    corr,
    mask=mask,
    annot=True,
    fmt='.2f',
    cmap='coolwarm',
    center=0,
    linewidths=0.5,
    linecolor='gray',
    square=True,
)
plt.title("Feature Correlation Heatmap", fontsize=16, fontweight='bold')
plt.xticks(rotation=45, ha='right', fontsize=10)
plt.yticks(fontsize=10)
plt.tight_layout()
plt.show()
```


## 🧠 Final Conclusion

This project delivers a complete, end-to-end data analytics and machine learning pipeline:

🧾 Clean and structured data extraction via PostgreSQL

📊 Insightful business intelligence dashboards built in Power BI

🤖 Machine learning model using Linear Regression to predict Profitability

📈 Enables both exploratory analytics and predictive decision-making for real-world applications in retail, e-commerce, and supply chain

This hybrid approach demonstrates the power of combining traditional BI tools with modern machine learning techniques.

---
## 🚀 How to Run

- 🔹 **Power BI Dashboard**:  
  Run SQL queries from `Global Sales Trends.sql` in PostgreSQL → Open `Sales Data Dashboard.pbix` in Power BI → Refresh to load updated data.

- 🔹 **Export for ML**:  
  Export the processed data as `Global_Sales_Export.csv` from PostgreSQL.

- 🔹 **Run ML Model**:  
  Open `Profitability Prediction.ipynb` in Jupyter Notebook or VS Code → Ensure `Global_Sales_Export.csv` is present → Execute all cells to train and evaluate the model.

---

## 📬 Contact

**Md. Ahsan Ul Islam**  
🎓 Junior Data Analyst | Aspiring BI Developer  
🔗 [LinkedIn](https://www.linkedin.com/in/md-ahsan-ul-islam)  
🔗 [GitHub](https://github.com/git-ahsan)

---

## 🏷️ Tags

`#PowerBI` `#SQL` `#PostgreSQL` `#DataAnalysis` `#Dashboard` `#BusinessIntelligence` `#MachineLearning` `#ProfitPrediction` `#Python` `#ScikitLearn` `#GitHubPortfolio`
