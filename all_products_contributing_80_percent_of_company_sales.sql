
--------------------------------------------------------------------
-- problem statement: write a query to find all the products that contribute 
--80 percent of the total sales within a company


with sales_t as -- calculating the sales by product id using cte
(
select  product_id,
		sum(sales) as product_sales

from orders 
group by product_id
order by product_sales desc
), running_t as -- calculating the running total of the sales using cte and creating a total_sales column for comparision
(
select  product_id,
		product_sales,
		sum(product_sales) over(order by sum(product_sales) desc rows between unbounded preceding and 0 preceding) as running_total,
		sum(product_sales) over() as total_sales

from sales_t
group by product_id, product_sales 
), calc_sales as --- creating the lag so that the row below 0.8*total_sales is not selected and the one above it is selected 
(                --- if we dont use lag, the row where is 80% will be neglected 
select  product_id,
		product_sales,
		running_total,
		total_sales,
		coalesce(lag(running_total) over(order by running_total asc),0) as prev_running_total

from running_t
)

select  product_id,
		product_sales,
		running_total,
		prev_running_total,
		total_sales,
		round(running_total/total_sales *100,2) as percentage

from calc_sales 

where prev_running_total < (0.8* total_sales) --- filtering out where the running sales is 80% of the total_sales(using lag)

		