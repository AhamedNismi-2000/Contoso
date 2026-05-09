 /*
 Use Only if Table Anything Created in Database 
 1. Drop tables if they exist (optional, clean start)

DROP TABLE IF EXISTS public.sales CASCADE;
DROP TABLE IF EXISTS public.currencyexchange CASCADE;
DROP TABLE IF EXISTS public.customer CASCADE;
DROP TABLE IF EXISTS public.product CASCADE;
DROP TABLE IF EXISTS public.store CASCADE;
DROP TABLE IF EXISTS public."date" CASCADE;
*/

--2. Create tables.
-- Create Currency Exchange Table 
-- Currency Exchange Table
CREATE TABLE public.currencyexchange(
  date date NOT NULL,
  fromcurrency VARCHAR(10) NOT NULL,
  tocurrency VARCHAR(10) NOT NULL,
  exchange NUMERIC(12,6),  -- 6 decimals for exchange rates
  PRIMARY KEY (date,fromcurrency,tocurrency)
);

-- Customer Table
CREATE TABLE public.customer (
    customerkey INT NOT NULL PRIMARY KEY,
    geoareakey INT,
    startdt date,
    enddt date,
    continent VARCHAR(50),
    gender VARCHAR(10),
    title VARCHAR(20),
    givenname VARCHAR(50),
    middleinitial VARCHAR(5),
    surname VARCHAR(50),
    streetaddress VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    statefull VARCHAR(100),
    zipcode VARCHAR(20),
    country VARCHAR(50),
    countryfull VARCHAR(100),
    birthday date,
    age INT,
    occupation VARCHAR(100),
    company VARCHAR(100),
    vehicle VARCHAR(100),
    latitude NUMERIC(10,6),   -- 6 decimals for coordinates
    longitude NUMERIC(10,6)
);

-- Date Table
CREATE TABLE public."date" (
    date date NOT NULL PRIMARY KEY,
    datekey INT,
    year INT,
    yearquarter VARCHAR(20),
    yearquarternumber INT,
    quarter VARCHAR(10),
    yearmonth VARCHAR(20),
    yearmonthshort VARCHAR(20),
    yearmonthnumber INT,
    month VARCHAR(20),
    monthshort VARCHAR(10),
    monthnumber INT,
    dayofweek VARCHAR(20),
    dayofweekshort VARCHAR(10),
    dayofweeknumber INT,
    workingday INT,
    workingdaynumber INT
);

-- Product Table
CREATE TABLE public.product(
    productkey INT NOT NULL PRIMARY KEY,
    productcode INT,
    productname VARCHAR(100),
    manufacturer VARCHAR(100),
    brand VARCHAR(50),
    color VARCHAR(30),
    weightunit VARCHAR(10),
    weight NUMERIC(10,3),   -- 3 decimals for weight
    cost NUMERIC(10,2),     -- 2 decimals for money
    price NUMERIC(10,2),
    categorykey INT,
    categoryname VARCHAR(50),
    subcategorykey INT,
    subcategoryname VARCHAR(50)
);

-- Store Table
CREATE TABLE public.store(
    storekey INT NOT NULL PRIMARY KEY,
    storecode INT,
    geoareakey INT,
    countrycode VARCHAR(10),
    countryname VARCHAR(50),
    state VARCHAR(50),
    opendate date,
    closedate date,
    description VARCHAR(100),
    squaremeters NUMERIC(10,2),  -- 2 decimals for area
    status VARCHAR(20)
);

-- Sales Table
CREATE TABLE public.sales(
    orderkey INT NOT NULL,
    linenumber INT NOT NULL,
    orderdate date,
    deliverydate date,
    customerkey INT,
    storekey INT,
    productkey INT,
    quantity NUMERIC(12,2),     -- quantity can have decimals if partial units
    unitprice NUMERIC(10,2),
    netprice NUMERIC(12,2),
    unitcost NUMERIC(10,2),
    currencycode VARCHAR(10),
    exchangerate NUMERIC(12,6),
    PRIMARY KEY (orderkey, linenumber),
    FOREIGN KEY (customerkey) REFERENCES public.customer(customerkey),
    FOREIGN KEY (productkey) REFERENCES public.product(productkey),
    FOREIGN KEY (storekey) REFERENCES public.store(storekey)
);

/* Set table ownership to postgres to ensure full administrative control and avoid permission issues

ALTER TABLE public.currencyexchange OWNER TO postgres;
ALTER TABLE public.customer OWNER TO postgres;
ALTER TABLE public."date" OWNER TO postgres;
ALTER TABLE public.product OWNER TO postgres;
ALTER TABLE public.store OWNER TO postgres;
ALTER TABLE public.sales OWNER TO postgres;

*/