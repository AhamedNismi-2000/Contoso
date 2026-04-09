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

   -- Top 5 High Customer Count Countries 

    SELECT
       countryfull,
       continent, 
       COUNT(DISTINCT customerkey) AS distinct_customer
    FROM Customer 
    GROUP BY countryfull,continent
    ORDER BY countryfull DESC
    LIMIT 5 


-- Gender Analysis 

-- Total Male & Female 
  SELECT
    gender,
    COUNT(DISTINCT customerkey) AS gender_count
  FROM customer 
  GROUP BY gender

-- How Many Orders Made By Genders  
  SELECT 
     gender,
     COUNT(DISTINCT s.orderkey) AS order_per_gender  
  FROM customer c 
  JOIN sales s 
  ON c.customerkey = s.customerkey
  GROUP BY gender    


-- Which Gender Order What Category of Item

  SELECT 
    DISTINCT gender,
    categoryname,
    COUNT(DISTINCT s.orderkey) AS gender_count
    
  FROM Customer c 
  JOIN Sales s 
  ON s.customerkey = c.customerkey
  JOIN  Product p 
  ON s.productkey = p.productkey 
  GROUP BY categoryname,gender
  


  -- Product Category Analyse By Age

  SELECT
      age,
      COUNT(age) age_count,
      categoryname
  FROM Customer c     
  JOIN Sales s 
  ON s.customerkey = c.customerkey
  JOIN  Product p 
  ON s.productkey = p.productkey 
  GROUP BY age,categoryname
  ORDER BY age 


-- Analyse By Age and Gender 
  SELECT
      age,
      COUNT(age) age_count,
      gender,
      categoryname
  FROM Customer c     
  JOIN Sales s 
  ON s.customerkey = c.customerkey
  JOIN  Product p 
  ON s.productkey = p.productkey 
  GROUP BY age,categoryname,gender
  ORDER BY age 

