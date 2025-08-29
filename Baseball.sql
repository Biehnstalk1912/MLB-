USE baseball;

SELECT * 
FROM appearances a
JOIN players p
ON a.playerID = p.playerID
JOIN teams t
ON a.yearID = t.yearID AND a.teamID = t.teamID
ORDER BY a.yearID ASC;

-- banana
SELECT yearID, teamID, name AS team_name, wins, losses
FROM teams
ORDER BY yearID DESC;

-- Average player atributes per team
SELECT a.yearID,
	   a.teamID,
       ROUND(AVG(p.weight), 2) AS avg_weight,
       ROUND(AVG(p.height), 2) AS avg_height,
       COUNT(DISTINCT a.playerID) AS roster_size,
       AVG(a.games_played) AS avg_games_played
FROM appearances a
JOIN players p
ON a.playerID = p.playerID
GROUP BY a.yearID, a.teamID
ORDER BY a.yearID DESC;








	










