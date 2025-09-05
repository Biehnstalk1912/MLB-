USE baseball;
WITH Team_Performance AS ( 
    SELECT 
        yearID, 
        teamID, 
        name AS team_name, 
        wins, 
        losses,
        park,
        ROUND(AVG(wins) OVER (
            PARTITION BY teamID 
            ORDER BY yearID ASC 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 0) AS running_average_wins
    FROM teams 
    WHERE wins + losses >= 150
),

Ranked AS ( 
    SELECT 
        a.yearID, 
        a.teamID, 
        p.weight, 
        p.height, 
        a.games_played, 
        ROW_NUMBER() OVER (PARTITION BY a.yearID, a.teamID ORDER BY a.games_played) AS rn_gp, 
        COUNT(*) OVER (PARTITION BY a.yearID, a.teamID) AS cnt, 
        AVG(p.weight) OVER (PARTITION BY a.yearID, a.teamID) AS avg_weight, 
        AVG(p.height) OVER (PARTITION BY a.yearID, a.teamID) AS avg_height, 
        AVG(a.games_played) OVER (PARTITION BY a.yearID, a.teamID) AS avg_games_played 
    FROM appearances a 
    JOIN players p ON a.playerID = p.playerID 
),

Roster_Size AS ( 
    SELECT yearID, teamID, COUNT(DISTINCT playerID) AS roster_size 
    FROM appearances
    GROUP BY yearID, teamID 
),

Team_Roster_Stats AS ( 
    SELECT 
        r.yearID, 
        r.teamID, 
        r.avg_weight, 
        r.avg_height, 
        s.roster_size, 
        r.avg_games_played, 
        MAX(CASE WHEN rn_gp = FLOOR((cnt+1)/2) THEN games_played END) AS median_games_played 
    FROM Ranked r 
    JOIN Roster_Size s 
        ON r.yearID = s.yearID AND r.teamID = s.teamID 
    GROUP BY r.yearID, r.teamID, r.avg_weight, r.avg_height, s.roster_size, r.avg_games_played 
)

SELECT 
    t.yearID, 
    t.teamID,
    t.team_name, 
    t.wins, 
    t.losses, 
    t.running_average_wins, 
    ROUND(p_stats.avg_weight, 2) AS avg_weight, 
    ROUND(p_stats.avg_height, 2) AS avg_height, 
    p_stats.roster_size, 
    ROUND(p_stats.avg_games_played, 0) AS avg_games_played, 
    p_stats.median_games_played,
    park.parkID,
    park.name AS park_name,
    park.city,
    park.state,
    COALESCE(park.country, 'USA') AS country
FROM Team_Performance t
JOIN Team_Roster_Stats p_stats 
    ON t.yearID = p_stats.yearID AND t.teamID = p_stats.teamID
JOIN parks park
    ON REPLACE(LOWER(t.park), '.', '') = REPLACE(LOWER(park.name), '.', '') -- flexible join
ORDER BY t.yearID DESC, t.teamID;
