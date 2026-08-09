-- Problem Statement: Take a list of cricket match outcomes between teams and dynamically aggregate 
--them to generate no.of matches played, matches won, and matches lost by the teams 


select  t.team_name,
		count(1) as matches_played,
		sum(case when t.team_name = winner then 1 else 0 end)  as matches_won,
		count(1) - sum(case when t.team_name = winner then 1 else 0 end) as matches_lost

from icc_world_cup
cross join lateral
(

values  (team_1),
		(team_2)

) as t(team_name)

group by t.team_name
order by matches_won desc
