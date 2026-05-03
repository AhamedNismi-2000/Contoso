
-- Net Revenue By Year

    SELECT 
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2022,
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2023,
       ROUND(SUM(CASE WHEN orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2024
    FROM Sales s


        