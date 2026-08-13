--- problem statement -----
--- find the number and percentage of cancelled rides by the unbanned category, i.e. ubanned by drivers and clients


select * from trips
select * from users

with unbanned as 
(
select  t.request_at, -- we hoin the trips table with users table twice to find unbanned drivers and unbanned clients
		t.status,	  -- inner join first on client id against users id and then on driver_id against users_id 
		t.client_id,
		t.driver_id,
		u.banned,
		ur.banned

from trips t 
inner join users u on t.client_id = u.users_id
inner join users ur on t.driver_id = ur.users_id

where u.banned = 'No' and ur.banned = 'No' --- we filter out banned clients and drivers from the joined table
)

select  request_at,
		count(1) as total_trips,
		sum(case when status in ('cancelled_by_driver', 'cancelled_by_client') then 1 else 0 end) as cancelled_trips, -- we calcualte the number of cancelled rides and find out the percentage of them 
		round(1.0*sum(case when status in ('cancelled_by_driver', 'cancelled_by_client') then 1 else 0 end)/count(1) * 100,2) as percentage_of_cancelled_trips

from unbanned 

group by request_at
order by request_at asc

