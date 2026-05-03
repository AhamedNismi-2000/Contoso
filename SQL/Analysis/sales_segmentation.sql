
-- Net Revenue By Year

    SELECT 
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2022,
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2023,
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2024
    FROM Sales s
    
 -- Average Sales Each Year    
    SELECT 
       ROUND(AVG(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2022,
       ROUND(AVG(CASE WHEN orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2023,
       ROUND(AVG(CASE WHEN orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2024
    FROM Sales s

 -- Median Sales Each Year By Product Category 
 
   SELECT 
      p.categoryname AS category,
      PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY (CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN ROUND(s.quantity*s.unitprice*s.exchangerate,2) END )) AS median_revenue_2022,
      PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY (CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN ROUND(s.quantity*s.unitprice*s.exchangerate,2) END )) AS median_revenue_2023,
      PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY (CASE WHEN s.orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN ROUND(s.quantity*s.unitprice*s.exchangerate,2) END )) AS median_revenue_2024
    FROM Sales s       
    JOIN Product p
    ON s.productkey = p.productkey 
    GROUP BY p.categoryname




      