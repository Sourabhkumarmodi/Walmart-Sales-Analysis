
CREATE TABLE walmart_sales(
                            invoice_id VARCHAR(15),
                            branch	CHAR(1),	
                            city  VARCHAR(25),  
                            customer_type	VARCHAR(15),
                            gender	VARCHAR(15),
                            product_line VARCHAR(55),	
                            unit_price	FLOAT,
                            quantity    INT, 	
                            vat	FLOAT,
                            total	FLOAT,
                            date	date,	
                            time time,
                            payment_method	VARCHAR(15),
                            rating FLOAT
                        );
						
						
COPY walmart_sales
FROM 'D:\Walmart Sales Group By dataset.csv'
delimiter ','
CSV HEADER		


select * from walmart_sales
/*
-- ---------------------------------------------
-- Business Problems :: Basic Level
-- ---------------------------------------------
Q.1 Find the total sales amount for each branch
Q.2 Calculate the average customer rating for each city.
Q.3 Count the number of sales transactions for each customer type.
Q.4 Find the total quantity of products sold for each product line.
Q.4 v1 Calculate the total VAT collected for each payment method.*/
 
--Q.1 Find the total sales amount for each branch.
 select branch,sum(total) as total_sales
 from walmart_sales
 group by branch;
 
--Q.2 Calculate the average customer rating for each city.

SELECT 
    city, avg(rating) as avg_rating
	from walmart_sales
group by city;

--Q.3 Count the number of sales transactions for each customer type.
select customer_type,count(invoice_id) as count_transaction
from walmart_sales
group by customer_type

--Q.4 Find the total quantity of products sold for each product line.
select product_line,sum(quantity) as total_qty
from walmart_sales
group by product_line

--Q.5 v1 Calculate the total VAT collected for each payment method.
select payment_method,sum(vat) as total_vat
from walmart_sales
group by payment_method

-- ---------------------------------------------
-- Business Problems :: Medium Level
-- ---------------------------------------------
/*Q.5 Find the total sales amount and average customer rating for each branch.
Q.6 Calculate the total sales amount for each city and gender combination.
Q.7 Find the average quantity of products sold for each product line to female customers.
Q.8 Count the number of sales transactions for members in each branch.
Q.9 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)*/

--Q.5 Find the total sales amount and average customer rating for each branch.
select branch,sum(total) as sales,avg(rating) as avg_rating 
from walmart_sales
group by branch

--Q.6 Calculate the total sales amount for each city and gender combination.

select city,
gender,--1
sum(total) as sales--2
from walmart_sales
group by 1,2
order by 1;

--Q.7 Find the average quantity of products sold for each product line to female customers.
select product_line,avg(quantity) as avg_qty
from walmart_sales
where gender='Female'
group by product_line;

--8 Count the number of sales transactions for members in each branch.
select branch,count(*) as sales_trans
from walmart_sales
group by branch

--Q.9 Find the total sales amount for each day. (Return day name and their total sales order DESC by amt)

select to_char(date,'day') as day_name,
sum(total) as total_sales
from walmart_sales
group by day_name
order by total_sales desc

-- ---------------------------------------------
-- Business Problems :: Advanced Level
-- ---------------------------------------------
/*Q.10 Calculate the total sales amount for each hour of the day
Q.11 Find the total sales amount for each month. (return month name and their sales)
Q.12 Calculate the total sales amount for each branch where the average customer rating is greater than 8.
Q.13 Find the total VAT collected for each product line where the total sales amount is more than 500.
Q.14 Calculate the average sales amount for each gender in each branch.
Q.15 Count the number of sales transactions for each day of the week.
Q.16 Find the total sales amount for each city and customer type combination where the number of sales transactions is greater than 50.
Q.17 Calculate the average unit price for each product line and payment method combination.
Q.18 Find the total sales amount for each branch and hour of the day combination.
Q.19 Calculate the total sales amount and average customer rating for each product line where the total sales amount is greater than 1000.
Q.20 Calculate the total sales amount for morning (6 AM to 12 PM), afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.

*/
--Q.10 Calculate the total sales amount for each hour of the day
select extract(hour from time) as hours,
sum(total) as total_sales
from walmart_sales
group by hours
order by 2

--Q.11 Find the total sales amount for each month. (return month name and their sales)
select to_char(date,'month') as month,
sum(total) as sales
from walmart_sales
group by 1

--Q.12 Calculate the total sales amount for each branch where the average customer rating is greater than 8.

select branch,sum(total) as sales,avg(rating) from walmart_sales
group by branch
having avg(rating)>7

--Q.13 Find the total VAT collected for each product line where the total sales amount is more than 500.
select product_line,sum(vat) as total_vat,total
from walmart_sales
group by 1,3
having sum(total)>500;

--Q.14 Calculate the average sales amount for each gender in each branch.
select branch,gender,
avg(total) as sales 
from 
walmart_sales
--where gender='Male'
group by branch,gender

--Q.15 Count the number of sales transactions for each day of the week.
select to_char(date,'day') as days,count(*) from walmart_sales
group by days

--Q.16 Find the total sales amount for each city and customer
--type combination where the number of sales transactions is greater than 50.
select city,customer_type,sum(total) as sales
from walmart_sales
group by city,customer_type
having count(*)>50

--Q.17 Calculate the average unit price for each product line and payment method combination.
select product_line,payment_method,avg(unit_price) as avgprice from walmart_sales
group by product_line,payment_method

--Q.18 Find the total sales amount for each branch and hour of the day combination.
select branch,extract(hour from time) as hours,sum(total) as sales from walmart_sales
group by branch,hours

--Q.19 Calculate the total sales amount and average customer rating for each product line
--where the total sales amount is greater than 1000.
select product_line, sum(total) as totalsales, avg(rating) as avgrating
from walmart_sales
group by product_line
having  sum(total)>1000

--Q.20 Calculate the total sales amount for morning (6 AM to 12 PM),
--afternoon (12 PM to 6 PM), and evening (6 PM to 12 AM) periods using the time condition.

SELECT
    CASE
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 18 AND 23 THEN 'Evening'
    END AS period,
    SUM(total) AS total_sales_amount
FROM
    walmart_sales
GROUP BY
    CASE
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM TIME) BETWEEN 18 AND 23 THEN 'Evening'
    END;