

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
