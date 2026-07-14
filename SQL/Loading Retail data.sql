DROP EXTERNAL DATA SOURCE ds_Silver_Retail;
CREATE EXTERNAL DATA SOURCE ds_Silver_Retail
WITH (
    LOCATION = 'https://adlsgraduproject2.dfs.core.windows.net/retaildata/curated/'
);

 CREATE EXTERNAL FILE FORMAT fmt_parquet
WITH (FORMAT_TYPE = PARQUET);

CREATE EXTERNAL TABLE ext_retail_data (
    [Transaction_ID]   NVARCHAR(100), -- 1
    [Customer_ID]      NVARCHAR(100), -- 2
    [Name]             NVARCHAR(200), -- 3
    [Email]            NVARCHAR(200), -- 4
    [Phone]            NVARCHAR(50),  -- 5
    [Address]          NVARCHAR(500), -- 6
    [City]             NVARCHAR(100), -- 7
    [state_]            NVARCHAR(100), -- 8
    [Zipcode]          NVARCHAR(50),  -- 9
    [Country]          NVARCHAR(100), -- 10
    [Age]              INT,           -- 11
    [Gender]           NVARCHAR(20),  -- 12
    [Income]           NVARCHAR(100), -- 13
    [Customer_Segment] NVARCHAR(100), -- 14
    [full_date]             DATE,     -- 15
    [Year_name]             INT,      -- 16
    [month_name]       NVARCHAR(20),  -- 17
    [transaction_time] DATETIME2,     -- 18
    [Total_Purchases]  INT,           -- 19
    [Amount]           DECIMAL(10,2),         -- 20
    [Total_Amount]     DECIMAL(10,2),         -- 21
    [Product_Category] NVARCHAR(100), -- 22
    [Product_Brand]    NVARCHAR(100), -- 23
    [Product_Type]     NVARCHAR(100), -- 24
    [Feedback]         NVARCHAR(1000), -- 25
    [Shipping_Method]  NVARCHAR(100), -- 26
    [Payment_Method]   NVARCHAR(100), -- 27
    [Order_Status]     NVARCHAR(100), -- 28
    [Ratings]          INT,           -- 29
    [products]         NVARCHAR(150), -- 30
    [day_of_week]      NVARCHAR(20)    --31
)
WITH (
    LOCATION = '*.parquet', 
    DATA_SOURCE = ds_Silver_Retail, 
    FILE_FORMAT = fmt_parquet
);

SELECT TOP 3 * FROM ext_retail_data

-- Load dim_customer
TRUNCATE TABLE dim_customer;

INSERT INTO dim_customer (customer_id, name, email, phone, age, gender, income, Customer_Segment, address, city, state_, Zipcode, country)
SELECT DISTINCT
    Customer_ID, 
    Name, 
    Email, 
    Phone, 
    Age, 
    Gender, 
    Income, 
    Customer_Segment, 
    Address, 
    City, 
    State_, 
    Zipcode, 
    Country
FROM ext_retail_data;

SELECT TOP 5 *
FROM dim_customer
ORDER BY customer_id;

--  Load dim_date 
TRUNCATE TABLE dim_date;

INSERT INTO dim_date (full_date, Year_name, Month_name, transaction_time, day_of_week)
SELECT DISTINCT 
    full_date,
    Year_name,
    Month_name,
    transaction_time,
    day_of_week
FROM ext_retail_data;
 
SELECT TOP 5 *
FROM dim_date
ORDER BY date_id;
 
-- Load dim_order
TRUNCATE TABLE dim_order;

INSERT INTO dim_order (transaction_id, Shipping_Method, Payment_Method, Order_Status)
SELECT DISTINCT 
    Transaction_ID,
    Shipping_Method,
    Payment_Method,
    Order_Status
FROM ext_retail_data;

SELECT TOP 5 *
FROM dim_order
ORDER BY transaction_id;

-- Load dim_product
TRUNCATE TABLE dim_product;

INSERT INTO dim_product (Product_Category, Product_Brand, Product_Type, products)
SELECT DISTINCT 
    Product_Category,
    Product_Brand,
    Product_Type,    
    products
FROM ext_retail_data;

SELECT TOP 5 *
FROM dim_product
ORDER BY product_key;


-- Load fact_sales
TRUNCATE TABLE fact_sales;

INSERT INTO fact_sales (
    transaction_id, 
    customer_id, 
    product_key, 
    date_id, 
    Total_Purchases, 
    Amount, 
    Total_Amount, 
    Feedback, 
    Ratings
)
SELECT 
    e.Transaction_ID,
    e.Customer_ID,
    p.product_key, 
    d.date_id,    
    e.Total_Purchases,
    e.Amount,
    e.Total_Amount,
    e.Feedback,
    e.Ratings
FROM ext_retail_data e
LEFT JOIN dim_product p ON 
    e.Product_Category = p.Product_Category AND 
    e.Product_Brand = p.Product_Brand AND 
    e.Product_Type= p.Product_Type AND
    e.products = p.products
LEFT JOIN dim_date d ON 
    e.[full_date] = d.full_date AND 
    CAST(e.[transaction_time] AS TIME) = d.[transaction_time];

SELECT TOP 5 * FROM fact_sales;


CREATE PROCEDURE usp_LoadWarehouse
AS
BEGIN

    TRUNCATE TABLE dim_customer;
    INSERT INTO dim_customer (customer_id, name, email, phone, age, gender, income, Customer_Segment, address, city, state_, Zipcode, country)
SELECT DISTINCT
    Customer_ID, 
    Name, 
    Email, 
    Phone, 
    Age, 
    Gender, 
    Income, 
    Customer_Segment, 
    Address, 
    City, 
    State_, 
    Zipcode, 
    Country
FROM ext_retail_data;

    TRUNCATE TABLE dim_date;
    INSERT INTO dim_date (full_date, Year_name, Month_name, transaction_time, day_of_week)
SELECT DISTINCT 
    full_date,
    Year_name,
    Month_name,
    transaction_time,
    day_of_week
FROM ext_retail_data;

    TRUNCATE TABLE dim_product;
    INSERT INTO dim_product (Product_Category, Product_Brand, Product_Type, products)
SELECT DISTINCT 
    Product_Category,
    Product_Brand,
    Product_Type,    
    products
FROM ext_retail_data;

    TRUNCATE TABLE dim_order;
    INSERT INTO dim_order (transaction_id, Shipping_Method, Payment_Method, Order_Status)
SELECT DISTINCT 
    Transaction_ID,
    Shipping_Method,
    Payment_Method,
    Order_Status
FROM ext_retail_data;

    TRUNCATE TABLE fact_sales;
    INSERT INTO fact_sales (
    transaction_id, 
    customer_id, 
    product_key, 
    date_id, 
    Total_Purchases, 
    Amount, 
    Total_Amount, 
    Feedback, 
    Ratings
)
SELECT 
    e.Transaction_ID,
    e.Customer_ID,
    p.product_key, 
    d.date_id,    
    e.Total_Purchases,
    e.Amount,
    e.Total_Amount,
    e.Feedback,
    e.Ratings
FROM ext_retail_data e
LEFT JOIN dim_product p ON 
    e.Product_Category = p.Product_Category AND 
    e.Product_Brand = p.Product_Brand AND 
    e.Product_Type= p.Product_Type AND
    e.products = p.products
LEFT JOIN dim_date d ON 
    e.[full_date] = d.full_date AND 
    CAST(e.[transaction_time] AS TIME) = d.[transaction_time];

END
