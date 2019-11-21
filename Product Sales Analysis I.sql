

--1068.(Easy) Product Sales Analysis I

-- Reports all product names of the products in the Sales table 
-- along with their selling year and price


Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+

Result table:
+--------------+-------+-------+
| product_name | year  | price |
+--------------+-------+-------+
| Nokia        | 2008  | 5000  |
| Nokia        | 2009  | 5000  |
| Apple        | 2011  | 9000  |
+--------------+-------+-------+


-- join sales with product by product_id --> distinct

select distinct
    s.product_name
    ,s.year
    ,s,price

from Sales s left join Product p
    on s.product_id = p.product_id


-- 1069.(Easy) Product Sales Analysis II

-- group by product_id --> sum(quantity)

Result table:
+--------------+----------------+
| product_id   | total_quantity |
+--------------+----------------+
| 100          | 22             |
| 200          | 15             |
+--------------+----------------+


select   
    s.product_id
    ,sum(s.quantity) as quantity_total
from Sales s 
group by 1


-- 1070.(Medium) Product Sales Analysis III

-- Selects the product id, year, quantity, and price for the first year.

Result table:
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+

-- first year == 1st year being sold
-- assumming price stays same in any given year


-- product_id, year, sum(quantity), and min(price) --> assign ranking --> choose 1st

with base as (
    select 
    s.product_id
    s.year
    ,sum(quantity) as quantity_total
    ,min(price) as price
    ,row_number() over(partition by s.product_id
                       order by s.year asc) as rank
    from Sales s
    group by 1,2
)

select 
    product_id
    ,year as year_first
    ,quantity_total
    ,price
from base
where rank = 1

-- or 
SELECT 
    product_id,
    year first_year, 
    quantity, 
    price
FROM Sales
WHERE (product_id, year) IN (SELECT product_id, MIN(year)
                             FROM Sales
                             GROUP BY product_id)