-- This Sql file Use For Customer Segmentation 


-- Find the Unique Customers 

   SELECT 
       COUNT(DISTINCT customerkey) AS total_customer
   FROM Customer    

-- Customers Who Made a Order 

   SELECT 
       COUNT(DISTINCT customerkey) AS total_active_customer
   FROM Sales    
   
  

   -- Find the Total Active Male and Female Customers By Year 

    SELECT 
    EXTRACT(YEAR FROM s.orderdate) AS order_year,
    COUNT(DISTINCT CASE WHEN gender='male' THEN  s.customerkey END  ) AS active_male_customer,
    COUNT(DISTINCT CASE WHEN gender='female' THEN  s.customerkey END  ) AS active_female_customer,
    COUNT(DISTINCT s.customerkey ) AS total_active_customer
    FROM Sales s
    JOIN Customer c 
    ON s.customerkey = c.customerkey 
    GROUP BY EXTRACT(YEAR FROM s.orderdate)
    ORDER BY total_active_customer DESC


   -- Active & Inactive Customers Count By Continent 

   SELECT 
    c.continent,
    c.gender,
    COUNT(DISTINCT s.customerkey) AS active_customer_by_continent,

    COUNT(DISTINCT CASE WHEN s.customerkey IS NULL THEN c.customerkey 
    END) AS inactive_custome_by_continent,
    COUNT(DISTINCT c.customerkey) AS total_customer
    FROM Customer c
    LEFT JOIN Sales s 
        ON c.customerkey = s.customerkey
    GROUP BY c.continent, c.gender
    ORDER BY c.gender
 

        
            
   -- Top 5 High Active & Inactive  Customers Count Countries 

   SELECT
        countryfull,
        COUNT(DISTINCT s.customerkey)   AS active_customer_by_country,
        COUNT(DISTINCT CASE WHEN s.customerkey IS NULL THEN c.customerkey END) AS total_inactive_customer_country,
        COUNT(DISTINCT c.customerkey)   AS total_customer
    FROM Customer c
    LEFT JOIN Sales s ON c.customerkey = s.customerkey
    GROUP BY countryfull
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

  -- Revenue By Each Gender Each Year 

  SELECT 
      c.gender,
      EXTRACT(YEAR FROM s.orderdate) AS year,
      ROUND(SUM(s.quantity * s.unitprice * s.exchangerate), 2) AS net_revenue,
      COUNT(DISTINCT s.customerkey) AS customer_count 
  FROM Sales s
  JOIN Customer c 
      ON s.customerkey = c.customerkey 
  WHERE EXTRACT(YEAR FROM s.orderdate) > 2021
  GROUP BY 
      c.gender, EXTRACT(YEAR FROM s.orderdate)
  ORDER BY 
      c.gender, year;



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

-- Customer Who Buy Products to Cotributes Revenue Use for Devide the customer as Gold , Silver , Brownce Custoemer 

  SELECT 
      s.customerkey,
      CONCAT(c.givenname, ' ', c.surname) AS customer_name,
      SUM(s.quantity * s.unitprice * s.exchangerate) AS customer_revenue,
      CASE 
          WHEN SUM(s.quantity * s.unitprice * s.exchangerate) > 40000 THEN 'Gold'
          WHEN SUM(s.quantity * s.unitprice * s.exchangerate) BETWEEN 20000 AND 39999 THEN 'Silver'
          WHEN SUM(s.quantity * s.unitprice * s.exchangerate) BETWEEN 10000 AND 19999 THEN 'Bronze'
          ELSE 'Normal'
      END AS customer_seg,
      c.continent,
      c.countryfull AS country 
  FROM Sales s  
  JOIN Customer c ON s.customerkey = c.customerkey
  GROUP BY 
      s.customerkey, c.givenname, c.surname, c.continent, c.countryfull
  HAVING SUM(s.quantity * s.unitprice * s.exchangerate) > 30000
  ORDER BY customer_revenue DESC;

  

   SELECT 
    s.customerkey ,
    CONCAT(c.givenname , ' ', c.surname) AS customer_name,
    ROUND (SUM (s.quantity*s.unitprice*s.exchangerate),2) AS revenue_by_customer,
    p.categoryname AS category
    FROM Sales s 
    JOIN Customer c ON s.customerkey = c.customerkey
    JOIN Product p  ON s.productkey  = p.productkey
    WHERE  (s.quantity*s.unitprice*s.exchangerate) > 20000
    GROUP BY s.customerkey ,c.givenname,c.surname , p.categoryname
    ORDER BY revenue_by_customer DESC
