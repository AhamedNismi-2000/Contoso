
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
   
   
-- Revenue Summary

    SELECT 
      EXTRACT(YEAR FROM s.orderdate) AS year ,
      ROUND(SUM(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue,
      ROUND(AVG(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS avg_revenue,
      ROUND(MIN(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS min_revenue,
      ROUND(MAX(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS max_revenue
    FROM Sales s  
    WHERE orderdate BETWEEN '2022-01-01' AND '2024-12-31' 
    GROUP BY  EXTRACT(YEAR FROM s.orderdate)
    ORDER BY year


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


 -- Revenue Distribution By Tier

   WITH percentile AS (
      SELECT 
         PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ROUND((s.quantity * s.unitprice * s.exchangerate), 2)) AS revenue_25_percentile,
         PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY ROUND((s.quantity * s.unitprice * s.exchangerate), 2)) AS revenue_50_percentile,
         PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ROUND((s.quantity * s.unitprice * s.exchangerate), 2)) AS revenue_75_percentile
      FROM Sales s
      WHERE orderdate BETWEEN '2022-01-01' AND '2024-12-31'
   )

      SELECT 
         p.categoryname AS category,
         CASE 
            WHEN ROUND((s.quantity * s.unitprice * s.exchangerate), 2) 
                  <= prc.revenue_25_percentile 
            THEN 'LOW-Revenue'
            WHEN ROUND((s.quantity * s.unitprice * s.exchangerate), 2) 
                  >= prc.revenue_75_percentile 
            THEN 'HIGH-Revenue'
            ELSE 'MEDIUM-Revenue'
         END AS revenue_tier,
         SUM(ROUND((s.quantity * s.unitprice * s.exchangerate), 2)) AS total_revenue
      FROM Sales s
      JOIN Product p
      ON s.productkey = p.productkey
      CROSS JOIN percentile prc
      WHERE s.orderdate BETWEEN '2022-01-01' AND '2024-12-31'
      GROUP BY 
         p.categoryname,revenue_tier
      ORDER BY category 