-- problem statement --

-- find whether second order sold by the seller is their favorite brand or not, sellers who have sold less than 2
-- order should also be included with No in the respective columns  

with ranking as --- first we create a cte by putting row numbers based on the order date and seller id
(
select  *, 
		row_number() over(partition by seller_id order by order_date asc) as rn

from orders1
)  --- with ranking cte we left join the users table and filter out 2 row numbers, this way we keep the users who did 
   ---- not sell 2 orders, finally we join with items table to find whether the 2 item is sellers favorite or not
select  u.user_id,
		rk.order_date,
		rk.rn,
		u.favorite_brand,
		i.item_brand,
		case when i.item_brand = u.favorite_brand then 'Yes' else 'No' end as second_item_sold
		

from  users1 u
left join ranking rk on rk.seller_id = u.user_id and rn=2
left join items1 i on i.item_id = rk.item_id


