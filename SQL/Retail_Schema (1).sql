DROP TABLE dim_customer;
--dim customer
CREATE TABLE dim_customer (
    customer_id VARCHAR(1000) NOT NULL,
    name VARCHAR(100) NULL,
    email VARCHAR(100) NULL,
    phone VARCHAR(50) NULL,
    address VARCHAR(255) NULL,
    city VARCHAR(50) NULL,
    state_ VARCHAR(50) NULL,
    Zipcode VARCHAR(20) NULL,
    country VARCHAR(50) NULL,
    age INT NULL,
    gender VARCHAR(10) NULL,
    income VARCHAR(50) NULL,
    Customer_Segment VARCHAR(50) NULL,
    CONSTRAINT PK_dim_customer 
        PRIMARY KEY NONCLUSTERED (customer_id) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE
);

DROP TABLE dim_date;
--dim date
CREATE TABLE dim_date (
    date_id INT IDENTITY(1,1) NOT NULL,
    full_date DATE ,
    Year_name INT,
    Month_name VARCHAR(20),
    transaction_time TIME,
    day_of_week VARCHAR(20),
    CONSTRAINT PK_dim_date 
        PRIMARY KEY NONCLUSTERED (date_id) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE
);

DROP TABLE dim_order
--dim order
CREATE TABLE dim_order (
    transaction_id VARCHAR(1000) NOT NULL,
    Shipping_Method VARCHAR(50),
    Payment_Method VARCHAR(50),
    Order_Status VARCHAR(50),
    CONSTRAINT PK_dim_order 
        PRIMARY KEY NONCLUSTERED (transaction_id) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE
);

DROP TABLE dim_product
--dim product
CREATE TABLE dim_product (
    product_key INT IDENTITY(1,1) NOT NULL,
    Product_Category VARCHAR(100) NULL ,
    Product_Brand VARCHAR(100) NULL,
    Product_Type VARCHAR(100) NULL,
    products VARCHAR(150) NULL,
    CONSTRAINT PK_dim_product 
        PRIMARY KEY NONCLUSTERED (product_key) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE
);


DROP TABLE fact_sales
CREATE TABLE fact_sales (
    transaction_id VARCHAR(1000) NOT NULL,
    customer_id VARCHAR(1000) NULL,
    product_key INT NOT NULL,
    date_id INT NULL,
    Total_Purchases INT,
    Amount FLOAT,
    Total_Amount FLOAT,
    Feedback VARCHAR(1000) NULL,
    Ratings INT NULL
)
WITH (
    DISTRIBUTION = HASH(product_key),
    CLUSTERED COLUMNSTORE INDEX
);