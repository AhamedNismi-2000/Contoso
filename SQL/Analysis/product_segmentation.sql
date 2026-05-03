

SELECT * FROM Product  

-- Product Total Count Per Category 

SELECT 
    categoryname,
    COUNT(categoryname) AS total_count
FROM product
GROUP BY categoryname


-- Most Revenue Product 
 SELECT * FROM Sales  

    SELECT 
        p.categoryname,
        ROUND(SUM(s.quantity*s.exchangerate*s.unitprice),2) AS net_revenue 
    FROM Product p 
    JOIN Sales s
    ON p.productkey = s.productkey 
    GROUP BY p.categoryname
    ORDER BY net_revenue DESC

 -- Total Revenue By Year and Category Name  

    SELECT 
       p.categoryname,
       ROUND(SUM(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2022,
       ROUND(SUM(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2023,
       ROUND(SUM(CASE WHEN s.orderdate BETWEEN '2024-01-01' AND '2024-12-31' THEN s.quantity*s.unitprice*s.exchangerate END ),2) AS net_revenue_2024
    FROM Sales s
    JOIN Product p 
    ON s.productkey =  p.productkey
    GROUP BY categoryname 



    