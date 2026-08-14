---find the highest score by the player in each group from the tables provided. If 2 players have a same score wiithin the group 
---the player with lower player_id will be considered as the highest scorer


with scores as  --- we use cross join lateral to get player id and player score from matches table and create a cte
(
select  p.player_id,
		p.player_score 

from  matches 
cross join lateral
(
values  (first_player, first_score),
		(second_player, second_score)		
) as p(player_id, player_score)

), final_score as --- with scores cte as reference we perform inner join on players table so as to get respective group id's
				  -- for the players and rank them basis group id and player id in desc and asc order respectively
(                 -- so that we get rank 1 to the player with maximum score and in case of tie to the player id with lesser id value
select  g.group_id,
		s.player_id,
		sum(s.player_score) as player_score,
		row_number() over (partition by group_id order by sum(s.player_score) desc, s.player_id asc) as rn
		

from  scores s 
inner join players g on g.player_id = s.player_id
group by g.group_id, s.player_id
)

select  group_id,
		player_id,
		player_score

from final_score
where rn =1   --- finally using final_score CTE we filter out rnak 1 to get the desired result