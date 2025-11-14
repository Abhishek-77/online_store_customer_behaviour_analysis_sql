-- 1. Find the total number of products sold by each store along with the store name.

SELECT 
    store_name, SUM(od.quantity) AS total_products_sold
FROM
    stores s
        INNER JOIN
    orders o ON s.store_id = o.store_id
        INNER JOIN
    order_items od ON o.order_id = od.order_id
GROUP BY s.store_name


-- 2. Calculate the cumulative sum of quantities sold for each product over time. -- running total

with cte as(
select p.product_id, p.product_name, o.order_date,
sum(oi.quantity) as total_quantity       -- over() partition_by (product_id) we have use in cte as first we need grouped data
from order_items oi
inner join orders o
on oi.order_id = o.order_id
inner join products p
on p.product_id = oi.product_id
group by p.product_id, p.product_name,o.order_date) 
select *, sum(total_quantity) over(partition by product_id order by order_date) as cumulative_sum_of_quantities
from cte;


-- 3. Find the product with the highest total sales (quantity * price) for each category.

with sales_cte as (
SELECT 
    p.category_id,
    p.product_id,
    p.product_name,
    SUM(o.quantity * o.list_price) AS total_sales
FROM
    order_items o
        INNER JOIN
    products p ON o.product_id = p.product_id
GROUP BY p.category_id , p.product_id , p.product_name),

rank_cte as (
select *,
row_number() over(partition by category_id order by total_sales desc) as rn
from sales_cte
)
SELECT 
     product_name
FROM
    rank_cte
WHERE
    rn = 1


-- 4. Find the customer who spent the most money on orders.
  
with sales_cte as(
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(od.quantity * od.list_price) AS total_sales
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items od ON od.order_id = o.order_id
GROUP BY c.customer_id , full_name),
rank_cte as
(
select *,
rank() over(order by total_sales desc) as rnk
from sales_cte
)
SELECT 
    customer_id, full_name
FROM
    rank_cte
WHERE
    rnk = 1
    
    
-- or using subqueries 

with sales_cte as(
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(od.quantity * od.list_price) AS total_sales
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items od ON od.order_id = o.order_id
GROUP BY c.customer_id , full_name)   
SELECT 
    customer_id, full_name,total_sales
FROM
    sales_cte
WHERE
    total_sales = (select max(total_sales) from sales_cte) 
 
 
-- 5. Find the highest-priced product for each category name.

with rank_cte as(
select product_name,
	   category_id,
	   rank() over(partition by category_id order by list_price desc) as rn
from products
)
SELECT 
    category_id, product_name
FROM
    rank_cte
WHERE
    rn = 1

-- ✅ Approach 1: Using MAX() + GROUP BY
-- Step 1: Get the max price per category
WITH max_price_cte AS (
    SELECT 
        category_id,
        MAX(list_price) AS max_price
    FROM products
    GROUP BY category_id
)
-- Step 2: Join back to products
SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM products p
INNER JOIN max_price_cte m
    ON p.category_id = m.category_id
   AND p.list_price = m.max_price;

-- ✅ Approach 2: Correlated Subquery (another classic way)

SELECT 
    p.product_id,
    p.product_name,
    p.category_id,
    p.list_price
FROM products p
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);


-- 6. Find the total number of orders placed by each customer per store.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    s.store_name,
    COUNT(o.order_id) AS total_orders
FROM
    customers c
        LEFT JOIN
    orders o ON c.customer_id = o.customer_id
        LEFT JOIN
    stores s ON s.store_id = o.store_id
GROUP BY c.customer_id , full_name , s.store_name


-- 7. Find the names of staff members who have not made any sales.
SELECT 
    staff_id, CONCAT(first_name, ' ', last_name) AS staff_name
FROM
    staffs
WHERE
    staff_id NOT IN (SELECT 
            staff_id
        FROM
            orders)

-- using not exists
SELECT 
    staff_id, CONCAT(first_name, ' ', last_name) AS staff_name
FROM
    staffs
WHERE not exists( select staff_id from orders 
where orders.staff_id = staffs.staff_id
)

-- using left join 
select * 
from staffs s
left join orders o
on o.staff_id = s.staff_id
where  o.order_id is NULL


-- test
select staff_id from orders
where staff_id in (1,4)


-- 8. Find the top 3 most sold products in terms of quantity.

SELECT 
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM
    products p
        INNER JOIN
    order_items od ON p.product_id = od.product_id
GROUP BY p.product_id , p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 3


SELECT      -- wrong query 
    *
FROM
    products p
        INNER JOIN
    order_items od ON p.product_id = od.product_id
ORDER BY quantity DESC
LIMIT 3


-- 9. Find the median value of the price list. 
with cte as(
select 
list_price, 
row_number() over(order by list_price) as rn,
count(*) over() as n
from order_items)

select
 case
	when n % 2 = 0 then (select avg(list_price) from cte where rn in ((n/2), (n/2)+1))
 else 
	(select list_price from cte where rn = (n+1)/2)
 end as median 
from cte
limit 1


-- find category-wise median price (median per category_id)

WITH ordered_prices AS (
    SELECT 
        p.category_id,
        oi.list_price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY oi.list_price) AS rn,
        COUNT(*) OVER (PARTITION BY p.category_id) AS total_count
    FROM order_items oi
    INNER JOIN products p 
        ON oi.product_id = p.product_id
)
SELECT 
    category_id,
    AVG(list_price) AS median_price
FROM ordered_prices
WHERE rn IN ( (total_count + 1) / 2, (total_count + 2) / 2 )
GROUP BY category_id;


-- 10. List all products that have never been ordered.(use Exists)
-- using not exists

SELECT 
    product_id, product_name
FROM
    products p
WHERE
    NOT EXISTS( SELECT 
            product_id
        FROM
            order_items oi
        WHERE
            p.product_id = oi.product_id)

-- using left join 

SELECT 
    p.product_id, product_name
FROM
    products p
        LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
WHERE
    oi.order_id IS NULL

-- using IN
SELECT 
    product_id, product_name
FROM
    products
WHERE
    product_id NOT IN (SELECT 
            product_id
        FROM
            order_items)    -- here we should filter null values


-- 11. List the names of staff members who have made more sales than the average number of sales by all staff members.

with cte as( 
SELECT 
    s.staff_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    COALESCE(SUM(oi.quantity * oi.list_price), 0) AS total_sales
FROM
    staffs s
        LEFT JOIN
    orders o ON s.staff_id = o.staff_id
        LEFT JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY staff_id , full_name
)
select * 
from cte
where total_sales > (select avg(total_sales) from cte)


-- 12. Identify the customers who have ordered all types of products (i.e., from every category).

SELECT 
    c.customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    COUNT(p.category_id) AS categories_count
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT p.category_id) = (SELECT 
        COUNT(category_id)
    FROM
        categories)

-- test 

SELECT 
    c.customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    p.product_id,
    p.category_id,
    count(oi.order_id)
    -- COUNT(p.category_id) AS categories_count
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, p.product_id,p.category_id


