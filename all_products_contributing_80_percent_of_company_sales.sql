-- problem statement: write a query to find all the products that contribute 80 percent of the total sales within a company

with sales_t as -- calculating the sales by product id using cte
(
select  product_id,
		sum(sales) as product_sales

from orders 
group by product_id
order by product_sales desc
), calc_sales as -- calculating the running total of the sales using cte and creating a total_sales column for comparision
(
select  product_id,
		product_sales,
		sum(product_sales) over(order by sum(product_sales) desc rows between unbounded preceding and 0 preceding) as running_total,
		sum(product_sales) over() as total_sales

from sales_t

group by  product_id, product_sales
)

select  * -- filtering out all the product_ids where running total is less than the total_sales 

from calc_sales 

where running_total < (0.8* total_sales)