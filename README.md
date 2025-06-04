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

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Data Professionals`.
- **Table Creation**: This repository outlines the process of consolidating sales data from multiple regional CSV files into a unified Global Sales Data table within a PostgreSQL database. This setup enables comprehensive analysis and reporting across all sales territories.
The primary goal of this project is to centralize sales information, originally distributed across individual country-specific CSV files, into a single, easily queryable database table. This is achieved through a two-step process:

**i) Individual Table Creation & Import**: Each country's sales data is first imported into its own dedicated table in PostgreSQL. The project utilizes sales data from the following CSV files: -`sales_Canada.csv` -`sales_China.csv` -`sales_India.csv` -`sales_Nigeria.csv` -`sales_UK.csv` -`sales_US.csv`

For each of the aforementioned CSV datasets, a corresponding table was created in PostgreSQL's public schema. Each table shares the following standardized column structure to ensure data consistency: -`Transaction ID` -`Date` -`Country` -`Product ID` -`Product Name` -`Category` -`Price Per Unit` -`Quantity Purchased` -`Cost Price` -`Discount Applied` -`Payment Method` -`Customer Age Group` -`Customer Gender` -`Store Location` -`Sales Representative`
After table creation, the respective CSV data was imported into each table (e.g., Sales_Canada table populated from Sales_Canada.csv).

**ii) Global Data Consolidation**: All individual country tables are then merged into a new master `Global Sales Data` table. This was accomplished using the UNION ALL SQL operator, which appends all rows from each country table into the new global table, preserving duplicates (as is typical for transactional data).
The SQL query used for this consolidation is as follows:

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

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```


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
