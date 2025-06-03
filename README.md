# 🛍️ Global Sales Dashboard Project (2025)

## 📌 Project Objective
To consolidate and analyze global sales data from six different countries using SQL for data processing and Power BI for interactive dashboard creation. The aim is to uncover actionable insights into sales performance, profit, customer behavior, and geographic trends.

---

## ❓ Key Business Questions (KPIs)
- 📦 What is the total sales, cost, and profit?
- 🌍 Which countries and store locations perform best?
- 🧾 What is the average order value and total number of orders?
- 💰 Which products and sales representative are top performers?
- 💳 What are the preferred payment methods?
- 📉 How do discounts affect profitability?

---

## 🔧 Process Overview

### 🔄 Data Preparation
- Combined 6 separate CSV files (Canada, China, India, Nigeria, UK, US).
- Standardized column names across datasets.
- Merged datasets using `UNION ALL`.

### 🧼 Data Cleaning in SQL
- Checked and imputed missing values.
- Updated incorrect or placeholder entries.
- Detected and prevented duplicates.

### 🧮 Data Enrichment
- Created new columns:
  - `Revenue = (Price Per Unit × Quantity Purchased) - Discount Applied`
  - `Cost = Cost Price + Quantity Purchased`
  - `Profit = Revenue - Cost`

### 📊 Power BI Measures
- `Total Sales`, `Total Profit`, `Total Cost`, `Total Discount`
- `Total Orders` and `Average Order Value`
- Custom visuals: Map, Line chart, Bar chart, Pie chart

---

## 📈 Project Insights (from Dashboard)

- **Total Sales**: 4.14M | **Total Profit**: 958.74K  
- **Top Country by Sales**: UK  
- **Top Sales Day**: Monday  
- **Top Payment Method**: Credit Card (34.24%)  
- **Highest Sales Month**: December (0.52M)  
- **Most Profitable Cities**: Birmingham, New York  
- **Top-Selling Products & Sales Representative**: Identified via focused SQL queries

---

## 🧠 Final Conclusion

This project demonstrates a full end-to-end analytics pipeline:
- 📌 Clean, structured data via SQL
- 📊 Dynamic, insightful visualization using Power BI
- 🧩 Data-driven decision-making enabled through KPI tracking and geo-analysis

This approach is highly adaptable to real-world enterprise analytics in sectors like retail, e-commerce, or supply chain.

---

## 🛠️ Tools Used
- PostgreSQL (for SQL queries and data transformation)
- Power BI (for visualization and reporting)
- Git & GitHub (for version control and collaboration)

---

## 📷 Dashboard Preview

![Sales Dashboard Preview](https://github.com/git-ahsan/Global-Sales-Data-Analysis-2025/blob/main/Dashboard%20Preview.jpg)

---

## 📎 How to Run the Project
1. Clone this repository
2. Set up PostgreSQL and import the SQL scripts
3. Open Power BI Desktop and connect to your database
4. Load the data model and refresh visuals

---

## 📬 Contact
Feel free to reach out if you have any questions or collaboration ideas!
