--1.Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

select distinct(market) from dim_customer
where customer='Atliq Exclusive' and region='APAC'




 --2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields, unique_products_2020 unique_products_2021 percentage_chg ?

with unique_products_2020 as 
(select count(distinct product_code) as unique_products_2020
from fact_gross_price
where fiscal_year='2020),
with unique_products_2021 as 
(select count(distinct product_code) as unique_products_2021
from fact_gross_price
where fiscal_year='2021)
select unique_products_2020,unique_products_2021,
round(((unique_products_2020/unique_products_2021)*100,2) as percentage_chg
from unique_products_2020
inner join unique_products_2021







--3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains 2 fields, segment product_count.

select count(distinct product_code) as product_count,segment
from dim_product
group by segment
order by count(distinct product_code) desc







--4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields, segment product_count_2020 product_count_2021 difference.


with cte1 as (
select segment,count(distinct x.product_code) product_count_2020
from dim_product x
inner join fact_sales_monthly y
on x.product_code=y.product_code
where fiscal_year='2020'
group by segment),
with cte2 as (
select segment,count(distinct x.product_code) product_count_2021
from dim_product x
inner join fact_sales_monthly y
on x.product_code=y.product_code
where fiscal_year='2021'
group by segment),
cte3 as (
selectcte1.segment,product_count_2020,product_count_2021,product_count_2021-product_count_2020 as difference
from cte1 join cte2
on cte1.segment=cte2.segment)
select * from cte3
order by difference desc



--5. Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields, product_code product manufacturing_cost.

with cte as (
select y.product_code as product_code,product,
rank() over (order by manufacturing_cost desc) highestt,
rank() over (order by manufacturing_cost asc) lowestt,
manufacturing_cost
from fact_manufacturing_cost x
join dim_product y
on x.product_code=y.product_code)

select product_code,product,manufacturing_cost
from cte where
highestt=1 or lowestt=1

      

--6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields, customer_code customer average_discount_percentage.

