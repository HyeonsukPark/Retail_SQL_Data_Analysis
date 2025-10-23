# Retail SQL Data Analysis

## Introduction
A comprehensive data analysis was performed using SQL on Global's Supply Chain dataset, which encompasses a broad range of essential sales, product, and operational information. The primary objective of this investigation is to extract actionable intelligence that will enable the company to proactively address business issues, respond swiftly to market dynamics and consumer trends, and implement necessary economic adjustments to secure a competitive position.

Also, using Power BI, a star schema and Dashboard analysis were generated to visualize the dataset and data analysis. 

## Dataset 
DataCoSupplyChainDataset : [Dataset link](https://data.mendeley.com/datasets/8gx2fvg2k6/5)

Constante, Fabian; Silva, Fernando; Pereira, António (2019), “DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS”, Mendeley Data, V5, doi: 10.17632/8gx2fvg2k6.5


## Tool  
SQL Server Management Studio 2022 program with MS SQL Server


## Dataset Preparation 
For the data analysis of Global's Supply Chain dataset, the following preparatory steps were executed to refine the data structure and ensure data quality:
* Column Removal: The Product_Description column was removed as it contained no data, streamlining the dataset.
* Data Exploration: A preliminary analysis was conducted to examine the unique values within the key categorical columns: Payment Type, Customer Segment, Market, Delivery Status, and Shipping Mode.
* Schema Enhancement: Column names were standardized and updated for consistency. New columns were subsequently added to clearly represent the Order_Date and Shipment_Date.
This process ensures the dataset is clean, well-structured, and ready for subsequent sales and product analysis.

## Data Analysis 
* Total Sales
* Total order Profit
* Sales and Profit by Product Category and Product Name
* Average Order Value 
* Profit Margin by Products
* Orders, Sales, and Profit by Customer Segment 
* Sales and Profit by Market
* Sales and Profit by Year and Product Category
* Monthly Order Count and Peak  Activity 
* Top 3 Highest Sales Month per Year 
* Top 5 Most Profitable Products in 2017 (or othe year)
* Top 10 Most Frequently Bought Product Combination
* Discount Impact on Profit by Product Category
* Shipping Analysis - On-time Delivery Analysis
* Percentage of Shipping Delivery by Country
* Customer Ranks with Total Purchase
* Sales based on Payment Type 


## Database with Star Schema  
The dataset was also organized as a star schema. The schema is composed of one central Fact Table and seven surrounding Dimension Tables, with Dim_Customer, Dim_Product, Dim_Category, Dim_department, Dim_Date, Dim_Order, and Dim_Shipping. This structure efficiently separates measurable sales data from descriptive attributes. The seven Dimension Tables are linked to the central Fact_Sales table using unique Surrogate Keys (Primary Keys in the Dimension tables, Foreign Keys in the Fact table). 
* Fact_Sales
* Dim_Customer
* Dim_Product
* Dim_Category
* Dim_Department
* Dim_Date
* Dim_Order
* Dim_Shipping

The image added explains the entire schema.  

**[ Star Schema generated using PowerBI tool ]** 

<img width="1162" height="749" alt="image" src="https://github.com/user-attachments/assets/5e38e7ee-90c2-4f87-a7c0-334018b2fe7c" />

## Power BI Dashboard 

<img width="1333" height="751" alt="PowerBI_Analysis_1" src="https://github.com/user-attachments/assets/4ad63f1b-359e-410b-8ab9-7d272456ee1e" />

<img width="1342" height="754" alt="PowerBI_Analysis_2" src="https://github.com/user-attachments/assets/6c245eff-9014-45e1-80ed-c55d06be9167" />




