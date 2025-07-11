CREATE DATABASE IF NOT EXISTS retail_db;
USE retail_db;
-- Create the odi_cricket table
drop table odi_cricket_data;
CREATE TABLE odi_cricket_data(player_name varchar(50),
role varchar(50),
total_runs int,
strike_rate varchar(50),
total_balls_faced int,
total_wickets_taken int,
total_runs_conceded int,
total_overs_bowled int,
total_matches_played int,
matches_played_as_batter int,
matches_played_as_bowler int,
matches_won int,
matches_lost int,
players_of_match_awards int,
team varchar(100),
average varchar(255),
percentage varchar(255));
Select*from odi_cricket_data;
desc table odi_criket_data;



SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=1;
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\ODI_data.csv"
INTO TABLE odi_cricket_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
select*from odi_cricket_data;

-- Case 1:Categorizing Players by Role 
Select player_name,role,
CASE
WHEN role="Batter" THEN "Batsman"
WHEN role="Bowler" THEN "Bowler"
ELSE "All-Rounder"
END AS player_category from odi_cricket_data;

-- Case 2:Classifying Players Based on Runs Scored 
Select player_name,total_runs,
CASE
WHEN total_runs >=10000 THEN "LEGEND"
WHEN total_runs BETWEEN 5000 AND 9999 THEN "Greate Player"
WHEN total_runs BETWEEN 1000 AND 4999 THEN "Average Player"
Else "Newcomer"
END AS player_class
from odi_cricket_data;

-- Case 3: Evaluting Bowling Performance (Wicket Taken)
SELECT player_name, total_wickets_taken,
CASE 
WHEN total_wickets_taken >=300 THEN "Elite Bowler"
WHEN total_wickets_taken BETWEEN 100 AND 299 THEN "Experienced Bowler"
WHEN total_wickets_taken BETWEEN 50 AND 99 THEN "Developing Bowler"
ELSE "Part_Time Bowler"
END AS bowling_category
FROM odi_cricket_data;

-- Case 4: Classifying Players by Matches Won
Select player_name,matches_won,
CASE
WHEN matches_won >=300 THEN "Matches Winner"
WHEN matches_won BETWEEN 200 AND 299 THEN "Consistent Performance"
WHEN matches_won BETWEEN 100 AND 199 THEN "Contributor"
ELSE "Less Imapact"
END AS match_impact
FROM odi_cricket_data;

-- Case 5: Categorizing Players of the Matche Awards
SELECT player_name, players_of_match_awards,
CASE
WHEN players_of_match_awards >=30 THEN "Superstar"
WHEN players_of_match_awards BETWEEN 15 AND 29 THEN "Key Player"
WHEN players_of_match_awards BETWEEN 5 AND 14 THEN "Occasional Star"
ELSE "Rare Winner"
END AS award_category
FROM odi_cricket_data;

-- Update data 
Update odi_cricket_data 
set strike_rate=substring_index(strike_rate,".",2);

Update odi_cricket_data 
set average=substring_index(average,".",2);

-- QUERIES
-- 1.Get top batsmen by runs
Select player_name,team,strike_rate,total_runs from odi_cricket_data 
where role="Batter" ORDER BY total_runs DESC LIMIT 10;

-- 2.Insert a new player record
Insert into odi_cricket_data(player_name, 
role, 
total_runs ,
strike_rate,
total_balls_faced ,
total_wickets_taken , 
total_runs_conceded ,
total_overs_bowled ,
total_matches_played ,
matches_played_as_batter,
matches_played_as_bowler,
matches_won,
matches_lost,
players_of_match_awards, 
team,average,percentage)
VALUES
("New Players","Batter",5000,85.50,6000,0,0,0,200,200,0,120,80,15,"India",45.5,50.75);

-- Update strike_rate for specific players
Update odi_cricket_data set strike_rate=90.25 where player_name="V Kohli";
select*from odi_cricket_data;
 
 -- Delete records of retrived players
 DELETE FROM odi_cricket_data WHERE total_matches_played<50;
 
 -- Increase the total runs of a players after a recent match
 Update odi_cricket_data set total_runs=total_runs+75,total_balls_faced=total_balls_faced+80
 WHERE player_name="RG Sharma";
 select *from odi_cricket_data where player_name="RG Sharma";
 
 -- Set role as "ALL-Rounder" for players with both runs and wickets
 Update odi_cricket_data set role="All Rounder" WHERE
 total_runs>1000 AND total_wickets_taken>50;
 select*from odi_cricket_data  WHERE
 total_runs>1000 AND total_wickets_taken>50;
 
 -- Reset strike rate and avrage for players with incorrect values 
 UPDATE odi_cricket_data set strike_rate=NULL,average=NULL WHERE strike_rate<0 or average<0;
 SELECT*FROM odi_cricket_data where strike_rate<0 or average<0;
 
 -- Remove palyers who have never won a match
 DELETE FROM odi_cricket_data WHERE matches_won=0;
 
 -- Set average players to 0 for players with zero matches palyers 
 Update odi_cricket_data set average=0 WHERE total_matches_palyed=0;

-- Increase total wicket taken by 5 for bowlers from a specific team
update odi_cricket_data set total_wickets_taken= total_wicket_taken+5 
where role="Bowler" and team="Australia";
