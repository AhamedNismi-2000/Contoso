-- This Sql file Use For Customer Segmentation

-- Find the Unique Customer 

   SELECT 
       COUNT(DISTINCT customerkey) AS total_unique_customer
   FROM Customer    


   
-- Find the Unique Customer By Year 

   SELECT 
       COUNT(DISTINCT CASE WHEN orderdate BETWEEN '2022-01-01' AND '2022-12-31'THEN c.customerkey END ) AS total_2022_customer, 
       COUNT(DISTINCT CASE WHEN orderdate BETWEEN '2023-01-01' AND '2023-12-31'THEN c.customerkey END ) AS total_2023_customer,
       COUNT(DISTINCT CASE WHEN orderdate BETWEEN '2024-01-01' AND '2024-12-31'THEN c.customerkey END ) AS total_2024_customer
   FROM Customer c
   JOIN Sales s 
   ON c.customerkey = s.customerkey
   

   -- Query By Rows 

    SELECT 
        EXTRACT(YEAR FROM s.orderdate) AS order_year,
        COUNT(DISTINCT c.customerkey) AS total_customers
    FROM Customer c
    JOIN Sales s 
        ON c.customerkey = s.customerkey
    WHERE orderdate BETWEEN '2022-01-01' AND '2024-12-31'
    GROUP BY EXTRACT(YEAR FROM s.orderdate)
    ORDER BY order_year;


-- Customer By Continent Which Continent Customer Most 

    SELECT 
    Continent,
    COUNT(DISTINCT CASE WHEN Continent='Australia' THEN customerkey 
                    WHEN  Continent='Europe' THEN customerkey 
                    WHEN Continent='North America' THEN customerkey END ) AS cunstomer_continent 
    FROM customer
    GROUP BY continent 
                    

