select * from person
select * from friend



-- problem statement--

-- Find the number of friends a person have where the score of his/her friends is greater than 100


select  pers.person_id,
		pers.person_name,
		count(1) as no_of_friends,
		sum(p.score) as over_all_friends_score

from friend f
inner join person p on f.friend_id = p.person_id  -- join the friend table with person table to get the respective friends score for the persons 
inner join person pers on f.person_id = pers.person_id -- again join it with person table to get the name of the person 

group by pers.person_name, pers.person_id -- group by person name and id

having sum(p.score) > 100  -- use having to get the friends of the person whose overall score is greater than 100
order by over_all_friends_score desc