

-- First we calculate the first order date for each customer id and with that as CTE we join customer orders table
with first_order as 
(
select  customer_id,
		min(order_date) as first_order_date

from customer_orders 
group by customer_id
)
--- from first order table we join customer orders and calculate new customers using sum(case) and condition where order date is equal to first order table
select  c.order_date,
		sum(case when c.order_date = fo.first_order_date then 1 else 0 end) as new_customers,
		sum(case when c.order_date != fo.first_order_date then 1 else 0 end)  as repeat_customers
from  first_order fo
inner join customer_orders c on fo.customer_id = c.customer_id
group by c.order_date
order by c.order_date

