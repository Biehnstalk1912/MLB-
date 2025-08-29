USE baseball;

SELECT * 
FROM appearances a
JOIN players p
ON a.playerID = p.playerID
JOIN teams t
ON a.yearID = t.yearID AND a.teamID = t.teamID
ORDER BY a.yearID ASC;

