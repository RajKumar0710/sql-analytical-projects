-- ipl 2026 matches toss, batting first perfromance analysis
-- Problem Statement: Analyze IPL match data to evaluate toss impact, calculating total matches played, 
--total toss wins, matches won after winning the toss,
--and the toss-to-match conversion win percentage for each franchise.


with team_data as (
    select  
        t.team_name,
        count(1) as matches_played,
        sum(case when t.team_name = winner then 1 else 0 end) as total_wins,
        sum(case when t.team_name = toss_won_by then 1 else 0 end) as toss_wins,
        sum(case when t.team_name = toss_won_by and t.team_name = winner then 1 else 0 end) as toss_and_match_win,
        sum(case when t.team_name = batting_first then 1 else 0 end) as bat_first,
        sum(case when t.team_name = batting_first and t.team_name = winner then 1 else 0 end) as bat_first_wins
    from ipl_2026_matches
    cross join lateral (
        values 
            (team1),
            (team2)
    ) as t(team_name)
    group by t.team_name
)

select  
    team_name,
    matches_played,
    total_wins,
    matches_played - total_wins as matches_lost,
    round((1.0 * toss_and_match_win / nullif(toss_wins, 0)) * 100, 2) as toss_and_match_win_percent, 
    round((1.0 * bat_first_wins / nullif(bat_first, 0)) * 100, 2) as bat_first_wins_percent --nullif takes care the zero division error
from team_data
order by total_wins desc;
