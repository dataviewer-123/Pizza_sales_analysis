USE pizza_sales


--KPIs

--1) Total Revenue


Select 
	round(SUM(quantity * price), 2) AS [Total Revenue]
from order_details AS o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id


--2) Average Order Value 
--total order value/order count
 

 Select
	round(SUM(quantity * price)/COUNT(DISTINCT order_id), 2) AS [Average Order Value]
 from order_details AS o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id


3)Total pizzas Sold

Select 
	SUM(quantity) AS [Total Pizzas Sold]
FROM order_details;


--4) Total Orders

Select 
	Count(DISTINCT order_id) AS [Total Orders]
From order_details


--5) Average pizza per order
--pizzas sold/no.of pizzas

Select 
	SUM(quantity)/COUNT(DISTINCT order_id) AS [Average pizza per order]
from order_details



--OUESTIONS TO ANSWER

--1) Daily trends for Total Orders

Select 
	FORMAT(date, 'dddd') AS DAYofWEEk
	,COUNT(DISTINCT order_id) AS total_orders
FROM orders
Group by FORMAT(date, 'dddd')
Order by total_orders Desc;


--2) Hourly trend for Total Orders 

Select 
	DATEPART(HOUR,time) AS [Hour]
	,COUNT(DISTINCT order_id) AS count
from orders
group by DATEPART(HOUR,time)
order by [HOUR];


--3)Percentage of Sales by Pizza Category
-- a: calcluate total revenue per category
--b) % sales calculated as (a:/total revenue) * 100

SELECT 
    pt.category,
    SUM(p.price * od.quantity) AS total_sales,
   round((SUM(p.price * od.quantity) / 
        (SELECT SUM(p.price * od.quantity)
         FROM order_details od
         JOIN pizzas p ON od.pizza_id = p.pizza_id
        ) * 100),2) AS percent_of_total_sales
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY percent_of_total_sales DESC;


--4) Percentage of Sales by Pizza Size

SELECT 
    p.size,
    SUM(p.price * od.quantity) AS total_sales,
   round((SUM(p.price * od.quantity) / 
        (SELECT SUM(p.price * od.quantity)
         FROM order_details od
         JOIN pizzas p ON od.pizza_id = p.pizza_id
        ) * 100),2) AS percent_of_total_sales
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    p.size
ORDER BY percent_of_total_sales DESC;


--5)Total pizza sold by Pizza Category

SELECT 
    pt.category,
    SUM(od.quantity) AS total_pizzas_sold
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.category
ORDER BY total_pizzas_sold DESC;



--6) Top 5 Best sellers By Total Pizza Sold

SELECT TOP 5
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_pizzas_sold
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    total_pizzas_sold DESC;


--Q7)Bottom 5 Worst Sellers Pizzas Sold

SELECT TOP 5
    pt.name AS pizza_name,
    SUM(od.quantity) AS total_pizzas_sold
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    total_pizzas_sold ASC;


