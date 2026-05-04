-- This Sql file Use For Customer Segmentation

-- Find the Unique Customer 

   SELECT 
       COUNT(DISTINCT customerkey) AS total_unique_customer
   FROM Customer    

-- Customer Who Made a Order 

   SELECT 
       COUNT(DISTINCT customerkey) AS total_active_customer
   FROM Sales     


   -- Find the Total  Customer By Year   Query By Rows 

    SELECT 
    EXTRACT(YEAR FROM s.orderdate) AS order_year,
    COUNT(DISTINCT s.customerkey) AS ordered_customers
    FROM Sales s
    WHERE s.orderdate BETWEEN '2022-01-01' AND '2024-12-31'
    GROUP BY EXTRACT(YEAR FROM s.orderdate)
    ORDER BY order_year DESC;

   
-- Find the Unique Customer By Year 

   SELECT 
      COUNT(DISTINCT CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN c.customerkey END ) AS customer_2022,
      COUNT(DISTINCT CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN c.customerkey END ) AS customer_2023,
      COUNT(DISTINCT CASE WHEN s.orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN c.customerkey END ) AS customer_2024 
    FROM Sales s
    JOIN Customer c
    ON s.customerkey = c.customerkey


 



-- Customer By Continent Which Continent Customer Most 

    SELECT 
        continent,
        COUNT(DISTINCT CASE WHEN Continent='Australia' THEN customerkey  
              WHEN  Continent='Europe' THEN customerkey  
              WHEN  Continent='North America' THEN customerkey END ) AS customer_continent 
    FROM Customer 
    GROUP BY continent 
    ORDER BY continent 


    SELECT 
            
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

-- How Many Orders Made By Each Genders  

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
      COUNT(age)  AS customer_count,
      ROUND(SUM(s.quantity*s.exchangerate*s.unitprice),2) AS net_revenue,
      categoryname
  FROM Customer c     
  JOIN  Sales s 
  ON  c.customerkey = s.customerkey 
  JOIN Product p 
  ON p.productkey = s.productkey
  GROUP BY age,categoryname
  ORDER BY age 


-- Analyse By Age and Gender 

  SELECT
      age,
      COUNT(age) age_count,
      ROUND(SUM(s.quantity*s.exchangerate*s.unitprice),2) AS net_revenue,
      gender,
      categoryname
  FROM Customer c     
  JOIN Sales s 
  ON s.customerkey = c.customerkey
  JOIN  Product p 
  ON s.productkey = p.productkey 
  GROUP BY age,categoryname,gender
  ORDER BY age 

