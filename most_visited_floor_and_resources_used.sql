--**Problem Statement:**  
--Calculate total visits, most visited floor(s), and a distinct list of resources used by each visitor. 
--Ties in floor visits are preserved using rank.

select * from entries 
with floor_visits as --creating cte for finding the most visited floor 
(
select  name,
		floor,
		count(1),
		rank() over(partition by name order by count(1) desc) as rn
from entries 
group by name, floor 
), all_visits as -- creating the cte to find and aggregate distinct resources used by the persons
(
select  name,
		count(1) as total_visits,
		string_agg(distinct resources, ', ') as resources_used

from entries 
group by name 
)  ---- perfroming inner join between the two on name column filtering out the rank 1 which keeps the most visited floor by the user

select  av.name,
		av.total_visits,
		fv.floor as most_visited_floor,
		av.resources_used

from all_visits av
inner join floor_visits fv on fv.name = av.name 

where rn =1