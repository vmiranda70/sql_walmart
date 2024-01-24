-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Use WalmartSales
use walmartSales;

-- Create table
CREATE TABLE  sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- select all column from sales table --
 
select * from sales;

-- Find the total quantity of each gender found by using aggreagete and groupby --

select gender, sum(quantity)
from sales
group by gender;

-- count the total payment methods and sort by the largest count--

select payment, count(payment)
from sales 
group by payment
order by count(payment) desc;

-- create colum where rating above or equel to 5 is good, while lower is Bad. Used Case function --

select * ,
	case 
		when rating >= 5 then "good"
        when rating < 5 then "bad"
        end as "Rating Grade"
	from sales ;
    
-- find the average rating --

select avg(rating)
from sales;

-- Product with words Food and rating is above 6 --
select *
from sales 
where product_line like "Food%" and rating > 6;

-- select the city produces total sales --
select avg(total), city
from sales 
group by city
having avg(total) > (select avg(total) from sales);

-- select customer type member with gross income greater than the avereage gross_income, made by using subquerie --

select customer_type, gross_income 
from sales
where customer_type ="Member%" and gross_income > (select avg(gross_income) from sales) ;

-- find the revnue made from each each invoice_id --

select (quantity  *unit_price) as total from sales;

-- find the invoice_ids of those after 2019-02-13 --

select invoice_id from sales
where date > "2019-03-13 00;00;00";

-- create new column that include the days of the week --

alter table sales add column day_week varchar(10);

update sales 
set day_week = dayname(date);

-- create new column that includes the month name --

alter table sales add column month_name varchar(10);

update sales 
set month_name = monthname(date);

-- create a new column that includes the time of day such as evening --

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case 	
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "17:00:00" then "Afternoon"
        else "Evening" 
        end
        );
        
-- find how many unique product lines there are --
        
select count(distinct product_line)  from sales;

-- fine the top overrall payment methos --

select payment, count(*) from sales 
group by payment
order  by count(*) desc
limit 1;

-- find the product line that produces the most transactions --

select product_line , count(product_line)
from sales 
group by product_line
order by count(product_line) desc
limit 1;

-- find the month with the most revenue -- 
select month_name, sum(total) as total_revenue
from sales
group by month_name 
order by total_revenue desc
limit 1;

-- find the total revenue for each city --

select city, sum(total) as revenue
from sales 
group by city 
order by revenue;

-- brands that sold more than average product sold --

select 
	branch,
    sum(quantity) as qt
    from sales 
    group by branch
    having sum(quantity) > (select avg(quantity) from sales);
    
 -- The product line that is above the average revenue then make it good, else woul bad --   
select 
	product_line,
    avg(total),
    (case 
		when avg(total) > (select avg(total) from sales)
        then "good" 
        else "bad"
        end) as rating_performaince
    from sales 
    group by product_line ;

-- the number of sales by each day of the week --

select 
	day_week,count(*) as total_sales
    from sales
    group by day_week
    order by total_sales;

-- Which time of day productes the best average rating --

select 
	avg(rating),
    time_of_day
    from sales
    group by time_of_day;
  
-- window functions -- 

-- find a window function that displays the total revenue of each gender --
select *,(sum(total) over (partition by gender order by total))
from sales;

-- find the rank of each product_line by revenue --

SELECT invoice_id,product_line,total,RANK() OVER(partition by product_line order by total desc) as the_rank
from sales;

-- display the average rating of each city  and total amount of total revenue -- 

select *, avg(rating) over(partition by city order by city) as average_rating_city,
round((sum(total) over () ),2)as total_amount_of_revenue_overrall
from sales;

-- find the quanity by the product line by quarter --
select ntile(4) over (order by quantity), product_line, total, quantity
from sales;

-- find the different in the revenue or in other words total --
select  total-lag(total) over(order by total desc)
from sales;

-- find the first invoice from each product line --
select first_value(invoice_id) over(partition by product_line order by quantity) as first_id, product_line
from sales;
    


    


    

    

    
    
  




























