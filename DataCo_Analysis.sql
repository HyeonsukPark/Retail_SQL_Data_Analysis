-- NOTE: The SQL analysis was performed on the original dataset and not the proposed star schema. 

-- Dataset Check

-- Select all columns 
SELECT * FROM dbo.DataCo_SCM

-- product_description column with no description  
-- the column deleted 
alter table dbo.Dataco_SCM
drop column Product_Description

-- Check columns 
SELECT * FROM dbo.DataCo_SCM

-- unique values based on type of transaction made 
SELECT DISTINCT Type FROM dbo.DataCo_SCM

-- unique values based on type of customer segment 
SELECT DISTINCT Customer_Segment FROM dbo.DataCo_SCM

-- unique values based on type of market 
SELECT DISTINCT Market FROM dbo.DataCo_SCM

-- Unique values based on Delivery Status
SELECT DISTINCT Delivery_Status FROM dbo.DataCo_SCM

-- Unique values based on Shipping Mode
SELECT DISTINCT Shipping_Mode FROM dbo.DataCo_SCM

-- Alter column name 

-- Type 
EXEC sp_rename 'dbo.DataCo_SCM.Type', 'Payment_Type', 'COLUMN'

-- Order_Date 
EXEC sp_rename 'dbo.DataCo_SCM.order_date_DateOrders', 'Order_Date', 'COLUMN'

-- Shipping Date
EXEC sp_rename 'dbo.DataCo_SCM.shipping_date_DateOrders', 'Shipping_Date', 'COLUMN'

-- year values based on Order date
SELECT DISTINCT year(Order_Date) AS Unique_Year
FROM dbo.DataCo_SCM

-- Add 'year' and 'month' columns to the table 
-- OrderDate
ALTER TABLE dbo.DataCo_SCM 
ADD Order_Year INT;

ALTER TABLE dbo.DataCo_SCM
ADD Order_Month INT; 

UPDATE dbo.DataCo_SCM 
SET
   Order_Year = YEAR(Order_Date), 
   Order_Month = MONTH(Order_Date); 

-- ShippingDate
ALTER TABLE dbo.DataCo_SCM 
ADD Shipping_Year INT;

ALTER TABLE dbo.DataCo_SCM
ADD Shipping_Month INT; 

UPDATE dbo.DataCo_SCM 
SET
   Shipping_Year = YEAR(Shipping_Date), 
   Shipping_Month = MONTH(Shipping_Date); 


-- Sales and Profit Analysis 


-- 1. total sales 
SELECT SUM(sales) as Total_sale
from dbo.DataCo_SCM

-- 2. total order profit 
SELECT SUM(Order_Profit_Per_Order) as Total_Order_Profit 
from dbo.DataCo_SCM 

-- 3. Sales and Profit by Product Category and Product Name
SELECT Category_Name, Product_Name, 
       SUM(sales) as Total_sale, 
       SUM(Order_Profit_Per_Order) AS Total_Order_Profit
FROM dbo.DataCo_SCM 
GROUP BY Category_Name, Product_Name 
ORDER BY 1,3 DESC

-- 4. Average Order Value 
SELECT Order_Id, AVG(sales) as Average_Order_Value 
from dbo.DataCo_SCM   
Group by Order_Id

-- 5. Profit Margin by products 
SELECT Product_Name, AVG(Order_Item_Profit_Ratio) as Profit_Margin_Product
from dbo.DataCo_SCM 
Group by Product_Name

-- 6. Orders, Sales and Profit by Customer Segment
SELECT Customer_Segment, 
       COUNT(DISTINCT Order_Id) AS No_Of_Orders, 
       SUM(Sales) AS Total_Sales,
       SUM(Order_Profit_Per_Order) AS Total_Profit 
FROM dbo.DataCo_SCM 
Group BY Customer_Segment

-- 7. Sales and Profit by Market
SELECT Market, 
       SUM(Sales) AS Total_Sales,
       SUM(Order_Profit_Per_Order) AS Total_Profit 
FROM dbo.DataCo_SCM
GROUP BY Market
ORDER BY 2 DESC　　


-- 8. Sales and Profit by Year and Category 
SELECT Category_Name, 
       Order_Year, 
       SUM(Sales) AS Total_Sales,
       SUM(Order_Profit_Per_Order) AS Total_Profit 
FROM dbo.DataCo_SCM
GROUP BY Order_Year, Category_Name
ORDER BY 1 ,2 DESC

-- 9. Monthly Order Count and Peak Activity 
WITH ordercounts
  AS (SELECT Order_Year, Order_Month, Count(DISTINCT Order_Id) AS Order_Count
  FROM dbo.DataCo_SCM
  GROUP BY Order_Year, Order_Month)
SELECT DATENAME(month, DATEFROMPARTS(2015, Order_Month, 1)) AS Month,
  [2017] AS AvgOrderCount_2017,
  [2016] AS AvgOrderCount_2016,
  [2015] AS AvgOrderCount_2015 
FROM (SELECT Order_Year, Order_Month, Avg(Order_Count) AS AveOrderCount 
FROM ordercounts
Group BY Order_Year, Order_Month) AS SourceTable 
  PIVOT (AVG(AveOrderCount)
  FOR Order_Year IN ([2017], [2016], [2015])) AS pivottable 
Order By Order_Month;

-- 10. Top 3 Highest Sales Month Per Year 
WITH Ranked_Monthly_Sales AS (
  SELECT Order_Year, Order_Month, 
  SUM(Sales) AS Total_Sales, 
  SUM(Order_Profit_Per_Order) AS Total_Profit, 
  RANK() OVER (PARTITION BY Order_Year ORDER BY SUM(Sales) DESC) AS rnk 
  FROM dbo.DataCo_SCM
  GROUP BY Order_Year, Order_Month)

  SELECT Order_Year, Order_Month, Total_Sales, Total_Profit
  FROM Ranked_Monthly_Sales
  WHERE rnk <= 3
  ORDER BY Order_Year DESC, rnk ASC;

-- 11. Top 5 Most Profitable Products of 2017 
WITH cte AS(
SELECT Order_Year, Product_Name, Category_Name, 
       SUM(Sales) AS Total_Sales, SUM(Order_Profit_Per_Order) AS Total_Profit, 
       RANK() OVER (PARTITION BY Order_Year ORDER BY SUM(Order_Profit_Per_Order) DESC) AS rnk  
FROM dbo.DataCo_SCM
WHERE Order_Year = 2017
GROUP BY Order_Year, Product_Name, Category_Name) 
SELECT Category_Name, Product_Name, Total_Sales, Total_Profit 
FROM cte
WHERE rnk <= 5
ORDER BY Order_Year DESC, Total_Profit DESC; 

-- 12. Top 20 Most Frequently Bought Product Combination
WITH Order_Item 
  AS (SELECT Order_Id, Product_Card_Id, Product_Name 
  FROM dbo.DataCo_SCM)
SELECT TOP 20 a.Product_Name, b.Product_Name, Count(*) frequency 
FROM Order_Item a 
  INNER JOIN order_item b 
          ON a.Order_Id = b.Order_Id
  AND a.Product_Card_Id < b.Product_Card_Id 
GROUP BY a.Product_Name, b.Product_Name 
ORDER BY Count(*) DESC; 

-- 13. Discount Impact On Profit By Category
SELECT
  Category_Name,
  ROUND(AVG(Order_Item_Discount), 1) AS Avg_Discount_Percentage,
  ROUND(SUM(Sales), 2) AS Total_Sales,
  ROUND(SUM(Order_Profit_Per_Order), 2) AS Total_Profit_Loss,
  CASE
    WHEN SUM(Order_Profit_Per_Order) < 0 THEN 'Loss' 
    WHEN SUM(Order_Profit_Per_Order) > 0 THEN 'Profit'
  END AS Profit_Loss_Status
FROM dbo.DataCo_SCM
GROUP BY Category_Name 
ORDER BY Avg_Discount_Percentage DESC;

-- 14. shipping analysis : On-time delivery analysis

-- summary of delivery status by region and shipping mode
SELECT 
  Order_Region, Shipping_Mode, Delivery_Status, COUNT(*) AS Total_Orders 
FROM dbo.DataCo_SCM
GROUP BY Order_Region, Shipping_Mode, Delivery_Status
ORDER BY Order_Region, Total_Orders DESC;

-- Percentage of Delivery by Country
SELECT
    Order_Region,
    Shipping_Mode,

    COUNT(*) AS Total_Shipments,

    -- Calculate the status based on the real vs. scheduled days
   
    SUM(CASE WHEN Delivery_Status = 'Shipping on time' THEN 1 ELSE 0 END) AS On_Time,
    
    SUM(CASE WHEN Delivery_Status = 'Late delivery' THEN 1 ELSE 0 END) AS Late_Delivery,
  
    SUM(CASE WHEN Delivery_Status = 'Advance shipping' THEN 1 ELSE 0 END) AS Advance_Shipping,

    SUM(CASE WHEN Delivery_Status = 'Shipping canceled' THEN 1 ELSE 0 END) AS Shipping_Canceled,

     CAST(
        (SUM(CASE WHEN Delivery_Status = 'Shipping on time' THEN 1.0 ELSE 0.0 END) * 100.0) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5, 2)
    ) AS Percent_On_Time

FROM
    dbo.DataCo_SCM
GROUP BY
    Order_Region,
    Shipping_Mode
ORDER BY
    Order_Region,
    Shipping_Mode

-- 15. Customers ranks with total purchase 
WITH Customer_Sales AS (
   SELECT Customer_Fname, Customer_Lname, 
          SUM(Sales_per_customer) AS Total_Purchase 
   FROM dbo.DataCo_SCM
   GROUP BY
        Customer_Fname,
        Customer_Lname
)

SELECT
    Customer_Fname,
    Customer_Lname,
    Total_Purchase,
    RANK() OVER (ORDER BY Total_Purchase DESC) AS Sales_Rank
FROM
    Customer_Sales
ORDER BY
    Sales_Rank;


-- 16. Sales based on payment type 
SELECT Payment_Type, SUM(Sales) AS Total_Sales
FROM dbo.DataCo_SCM
Group BY Payment_Type DESC




