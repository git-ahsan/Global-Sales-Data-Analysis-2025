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
------------------------------------------

----Determine the total number of records in the dataset.
select count(*) from public."Global Sales Data";

---Identify all unique product categories in the dataset.
SELECT DISTINCT "Product Name" from public."Global Sales Data";

select max("Quantity Purchased") from public."Global Sales Data";

---Check for any null values in the dataset and delete records with missing data.
select * from public."Global Sales Data"
where
"Transaction ID" is null or "Date" is null or "Country" is null or "Product ID" is null or "Product Name" is null or "Category" is null or "Price Per Unit" is null or "Quantity Purchased" is null or "Cost Price" is null or "Discount Applied" is null or "Payment Method" is null or "Customer Age Group" is null or "Customer Gender" is null or "Store Location" is null or "Sales Representative" is null;

---update NULL values in the "Quantity Purchased" column with the most common quantities for beauty products in Nigeria.
---First Step:
SELECT
    "Quantity Purchased", COUNT(*) AS frequency from public."Global Sales Data"
WHERE "Country" = 'Nigeria' AND "Category" = 'Beauty'
GROUP BY
    "Quantity Purchased"
ORDER BY
    frequency DESC
limit 1;
---Second Step:
update public."Global Sales Data"
set "Quantity Purchased" = 5
where "Transaction ID" = '00a30472-89a0-4688-9d33-67ea8ccf7aea';


---Update NULL values in the "Price Per Unit" column using the average "Price Per Unit" for the "Sports" product category in the US.
update public."Global Sales Data"
set "Price Per Unit" = (
    SELECT AVG("Price Per Unit") from public."Global Sales Data"
where "Country"= 'US' and "Category"='Sports' and "Price Per Unit" is not null
)
where "Transaction ID" = '001898f7-b696-4356-91dc-8f2b73d09c63';

---Checking for duplicate values: To ensure that each transaction has a unique ID, which is typically expected in clean, reliable sales data.
select "Transaction ID", count(*) from public."Global Sales Data"
group by "Transaction ID"
having count(*)>1;

---Add a Sales Revenue column and calculate its value for all records
Alter table public."Global Sales Data"
add column "Sales Revenue" Numeric(10,2);

update public."Global Sales Data"
set "Sales Revenue"=("Price Per Unit" * "Quantity Purchased") - "Discount Applied";

---Add a Cost of Goods Sold column and calculate its value for all records
Alter table public."Global Sales Data"
add column "Cost of Goods Sold" Numeric(10,2);

update public."Global Sales Data"
set "Cost of Goods Sold"= "Cost Price" * "Quantity Purchased";

---Add a Profit column and calculate its value for all records:
Alter table public."Global Sales Data"
add column "Profit" Numeric(10,2);

update public."Global Sales Data"
set "Profit"= "Sales Revenue" - "Cost of Goods Sold";

---Write a SQL query to retrieve all columns for sales made on '2025-07-16
select * from public."Global Sales Data"
WHERE "Date" = '2025-07-16';

---Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 5 in the month of July-2025
select * from public."Global Sales Data"
WHERE   
	"Category" = 'Beauty'
    AND 
    TO_CHAR("Date", 'YYYY-MM') = '2025-07'
    AND
    "Quantity Purchased" >= 5;

---Write a SQL query to calculate the Total_Sales for each category
SELECT "Category", SUM("Sales Revenue") as "Total Sales" FROM public."Global Sales Data"
GROUP BY "Category"
order by "Total Sales" desc;

---Write a SQL query to find all transactions where the Sales Revenue is less than 500
SELECT * FROM public."Global Sales Data"
WHERE "Sales Revenue" < 500;

---How many transactions occurred for each product category, broken down by customer gender
SELECT "Category", "Customer Gender", COUNT(*) as "Total_Transactions"
FROM public."Global Sales Data"
GROUP BY "Category", "Customer Gender"
ORDER BY "Category";

---What is the Total revenue, TotalC COGS, and Total profit for each country, sorted by Total profit for the month of January, 2025?
select "Country",
	sum("Sales Revenue") as "Total Revenue", 
	sum("Cost of Goods Sold") as "Total COGS",
	sum("Profit") as "Total Profit"
from public."Global Sales Data"
where "Date" between '2025-01-01' and '2025-01-31'
group by "Country"
order by "Total Profit";

---What are the top 5 best-selling products by total units sold in February 2025?
SELECT 
    "Product Name", 
    SUM("Quantity Purchased") AS "Total Units Sold"
FROM public."Global Sales Data"
WHERE "Date" BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY "Product Name"
ORDER BY "Total Units Sold" DESC
LIMIT 5;

---Which top 10 Best Sales representatives generated the highest combined score (50% revenue + 50% profit) during February 2025
select "Sales Representative",
sum("Sales Revenue") as "Total Revenue",
SUM("Profit") AS "Total Profit",
(.5*sum("Sales Revenue")+.5*sum("Profit")) as "Total Score" from public."Global Sales Data"
where "Date" between '2025-02-01' and '2025-02-28'
group by "Sales Representative"
Order by "Total Score" Desc
limit 10;

---Which 10 store locations had the highest weighted performance scores (40% revenue + 60% profit) during February 2025?
select "Store Location",
sum("Sales Revenue") as "Total Revenue",
SUM("Profit") AS "Total Profit",
(.4*sum("Sales Revenue")+.6*sum("Profit")) as "Total Score" from public."Global Sales Data"
where "Date" between '2025-02-01' and '2025-02-28'
group by "Store Location"
Order by "Total Score" Desc
limit 10;

---What are the key Sales Revenue, Cost of Goods Sold and Profit insights for the selected period?
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