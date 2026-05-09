
COPY currencyexchange
FROM 'D:\Mine\Projects\Contoso\csv_files\currencyexchange.csv'
WITH (FORMAT csv , HEADER TRUE , DELIMITER ','  ,ENCODING   'UTF8') 

COPY customer
FROM 'D:\Mine\Projects\Contoso\csv_files\customer.csv'
WITH (FORMAT csv , HEADER TRUE , DELIMITER ',' , ENCODING  'UTF8' )

COPY date
FROM 'D:\Mine\Projects\Contoso\csv_files\date.csv'
WITH (FORMAT csv , HEADER TRUE , DELIMITER ',' , ENCODING  'UTF8' )

COPY product 
FROM 'D:\Mine\Projects\Contoso\csv_files\product.csv'
WITH (FORMAT csv , HEADER TRUE ,    NULL '\N' , DELIMITER ',' , ENCODING  'UTF8')

COPY sales 
FROM 'D:\Mine\Projects\Contoso\csv_files\sales.csv'
WITH (FORMAT csv , HEADER TRUE , DELIMITER ',' , ENCODING  'UTF8')

COPY store
FROM 'D:\Mine\Projects\Contoso\csv_files\store.csv'
WITH (FORMAT csv , HEADER TRUE , NULL '\N' , DELIMITER ',' , ENCODING  'UTF8' )



