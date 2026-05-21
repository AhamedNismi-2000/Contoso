
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
 

  -- Median Category Revenue 

  WITH category_median AS (
     SELECT 
        p.categoryname AS caetegory,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ROUND(s.quantity*s.unitprice*s.exchangerate ,2)) AS median 
     FROM Sales s
     JOIN Product p ON p.productkey = s.productkey
     WHERE EXTRACT(YEAR FROM s.orderdate) > 2021
     GROUP BY p.categoryname
  )
     SELECT
         p.categoryname,
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) < cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2022 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS low_2022_revenue, 
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) > cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2022 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS high_2022_revenue,  
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) < cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2023 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS low_2023_revenue,  
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) > cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2023 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS high_2023_revenue,  
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) < cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2024 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS low_2024_revenue,  
         SUM(CASE WHEN (s.quantity*s.unitprice*s.exchangerate) > cm.median  AND EXTRACT(YEAR FROM s.orderdate)= 2024 THEN ROUND((s.quantity*s.unitprice*s.exchangerate),2)  END  ) AS high_2024_revenue  
      FROM Sales s
      JOIN Product p ON s.productkey = p.productkey  
      CROSS JOIN category_median cm    
      GROUP BY p.categoryname


   -- Average Delivery Processing Time For Each Year 

     SELECT
        DATE_PART('year' , s.orderdate) AS year,
        ROUND(AVG(EXTRACT(DAY FROM AGE(s.deliverydate ,s.orderdate))),2) AS delivery_days, 
          CAST(ROUND(SUM(s.quantity * s.unitprice * s.exchangerate), 2) AS INTEGER) AS net_revenue
     FROM Sales s   
     WHERE DATE_PART('year' , s.orderdate) >= 2020
     GROUP BY  year

  -- Daily Net Revnue 

     SELECT 
         s.orderdate,
         ROUND(SUM(s.quantity * s.unitprice * s.exchangerate),2) AS revenue_per_day
     FROM Sales s  
     GROUP BY s.orderdate
     ORDER BY  revenue_per_day DESC

-- Daily Revenue With Orderkey 

    SELECT 
        s.orderdate,
        s.orderkey,
        (s.quantity * s.unitprice * s.exchangerate)  net_revenue,
        ROUND(SUM(s.quantity * s.unitprice * s.exchangerate) OVER(PARTITION BY s.orderdate),2) AS net_revenue_per_day
   FROM Sales s  

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


  -- Cohort Year By Customer   
    
  WITH yearly_cohort AS ( 
   SELECT 
      DISTINCT customerkey,
      EXTRACT(YEAR FROM MIN(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM Sales 
   ORDER BY customerkey
   
  )
  SELECT 
      c.cohort_year,
      EXTRACT(YEAR FROM s.orderdate) AS purchase_year,
      ROUND(SUM(s.quantity* s.unitprice *s.exchangerate),2) AS net_revenue 
  FROM Sales s 
  LEFT JOIN yearly_cohort yc 
  ON s.customerkey = yc.customerkey
  GROUP BY yc.cohort_year, EXTRACT(YEAR FROM s.orderdate)
  ORDER BY yc.cohort_year 


 -- Customer Count Each Cohort Year 

   WITH  yearly_cohort  AS(
      SELECT 
         DISTINCT customerkey,
         EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)) AS cohort_year,
         EXTRACT(YEAR FROM orderdate) AS purchase_year
      FROM Sales     
   )
   SELECT 
      cohort_year,
      purchase_year,
      COUNT(*) AS customer_count
   FROM yearly_cohort 
   GROUP BY cohort_year,purchase_year
   ORDER BY cohort_year   


-- Customer Life Time Value

   WITH yearly_ltv AS (
   SELECT 
      s.customerkey,
      c.surname , c.givenname,
      EXTRACT(YEAR FROM MIN(orderdate)) AS cohort_year,
      ROUND(SUM(s.quantity*s.unitprice*s.exchangerate),2) AS customer_ltv
   FROM Sales s
   JOIN Customer c
   ON c.customerkey = s.customerkey 
   GROUP BY s.customerkey,  c.surname , c.givenname 
   )
   SELECT 
      *,
      ROUND(AVG(customer_ltv) OVER(PARTITION BY customerkey),2) AS avg_ltv
   FROM yearly_ltv 
   ORDER BY customer_ltv DESC

   
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


