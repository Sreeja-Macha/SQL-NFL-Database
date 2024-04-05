USE nfl_statistics;

# QUESTION 1: Is there a correlation between the weight of defensive players and the number of sacks they make per season?
SELECT p.Weight, AVG(ds.Sacks) AS AvgSacks
FROM PLAYER p
JOIN YEARLY_STATISTICS ys ON P.PlayerID = ys.PlayerID
JOIN DEFENSIVE_STATISTICS ds ON YS.StatID = ds.StatID
GROUP BY p.Weight;

# QUESTION 2: Which are the top 5 colleges in terms of producing players with the highest average rushing yards per game?
SELECT C.Name, ROUND(AVG(RS.RushingYardsPerGame), 2) as AvgRushingYards
FROM COLLEGE C
JOIN PLAYER P ON C.CollegeID = P.CollegeID
JOIN YEARLY_STATISTICS YS ON P.PlayerID = YS.PlayerID
JOIN RUSHING_STATISTICS RS ON YS.StatID = RS.StatID
GROUP BY C.Name
ORDER BY AvgRushingYards DESC
LIMIT 5;

# QUESTION 3: How has the average completion percentage changed for quarterbacks over the past decade?
SELECT
  YS.Year,
  ROUND(AVG(PS.CompletionPercentage), 2) AS AvgCompletionPercentage
FROM PLAYER P
JOIN YEARLY_STATISTICS YS ON P.PlayerID = YS.PlayerID
JOIN PASSING_STATISTICS PS ON YS.StatID = PS.StatID
WHERE P.Position = 'QB' AND YS.Year >= (SELECT MAX(Year) FROM YEARLY_STATISTICS) - 10
GROUP BY YS.Year
ORDER BY YS.Year;

# QUESTION 4: How does the average rushing yards per attempt compare between players who attended college versus those who came directly from high school?
SELECT 'College' AS EducationLevel, ROUND(AVG(rs.YardsPerCarry), 2) AS AvgYardsPerCarry
FROM PLAYER p
JOIN YEARLY_STATISTICS ys ON p.PlayerID = ys.PlayerID
JOIN RUSHING_STATISTICS rs ON ys.StatID = rs.StatID
WHERE p.CollegeID IS NOT NULL
UNION
SELECT 'High School' AS EducationLevel, ROUND(AVG(rs.YardsPerCarry), 2) AS AvgYardsPerCarry
FROM PLAYER p
JOIN YEARLY_STATISTICS ys ON p.PlayerID = ys.PlayerID
JOIN RUSHING_STATISTICS rs ON ys.StatID = rs.StatID
WHERE p.CollegeID IS NULL;

# QUESTION 5: Which quarterbacks who have at least 15 seasons of recorded statistics demonstrate the greatest consistency in their passing performance, as evidenced by their career passer rating?
SELECT 
  p.PlayerName,
  ROUND(AVG(ps.PasserRating), 2) AS AveragePasserRating,
  STDDEV(ps.PasserRating) AS PasserRatingStdDev
FROM PLAYER p
JOIN YEARLY_STATISTICS ys ON p.PlayerID = ys.PlayerID
JOIN PASSING_STATISTICS ps ON ys.StatID = ps.StatID
WHERE p.Position = 'QB'
GROUP BY p.PlayerID
HAVING COUNT(ps.StatID) >= 15
ORDER BY PasserRatingStdDev ASC, AveragePasserRating DESC;

# QUESTION 6: Which running back players, who have participated in at least 15 games, have experienced a decrease in rushing yards but an increase in rushing touchdowns compared to the previous year, focusing on the last five years?
WITH RushingStats AS (
  SELECT
    P.PlayerID,
    P.PlayerName,
    YS.Year,
    RS.RushingYards,
    RS.RushingTDs,
    YS.GamesPlayed,
    LAG(RS.RushingYards) OVER (PARTITION BY P.PlayerID ORDER BY YS.Year) AS PrevYearRushingYards,
    LAG(RS.RushingTDs) OVER (PARTITION BY P.PlayerID ORDER BY YS.Year) AS PrevYearRushingTDs
  FROM
    PLAYER P
    JOIN YEARLY_STATISTICS YS ON P.PlayerID = YS.PlayerID
    JOIN RUSHING_STATISTICS RS ON YS.StatID = RS.StatID
  WHERE
    P.Position = 'RB' AND YS.Year >= (SELECT MAX(Year) FROM YEARLY_STATISTICS) - 5
)
SELECT
  PlayerID,
  PlayerName,
  Year,
  RushingYards,
  RushingTDs
FROM
  RushingStats
WHERE
  RushingYards < PrevYearRushingYards AND RushingTDs > PrevYearRushingTDs
  AND GamesPlayed > 15
ORDER BY Year DESC;

# QUESTION 7: Who are the top 1% of NFL rookie players in terms of total rushing yards who debuted in the latest season?
WITH RookieStats AS (
  SELECT 
    p.PlayerID, 
    p.PlayerName,
    SUM(rs.RushingYards) AS TotalRushingYards
  FROM PLAYER p
  JOIN YEARLY_STATISTICS ys ON p.PlayerID = ys.PlayerID
  JOIN RUSHING_STATISTICS rs ON ys.StatID = rs.StatID
  WHERE p.Experience = '1 Season' AND ys.Year = (SELECT MAX(Year) FROM YEARLY_STATISTICS)
  GROUP BY p.PlayerID, p.PlayerName 
), RankedRookies AS (
  SELECT 
    PlayerID, 
    PlayerName,
    TotalRushingYards,
    DENSE_RANK() OVER (ORDER BY TotalRushingYards DESC) AS RushRank,
    COUNT(*) OVER () AS TotalRookies
  FROM RookieStats
)
SELECT RushRank, PlayerName, TotalRushingYards
FROM RankedRookies
WHERE RushRank <= TotalRookies * 0.01;

# QUESTION 8: Which top 5 teams have shown a trend of improving defense over the last three seasons?
WITH DefensiveTrend AS (
  SELECT
    TeamID,
    Year,
    SUM(ds.Sacks + ds.Ints) AS TotalDefensiveActions,
    LEAD(SUM(ds.Sacks + ds.Ints), 1) OVER (PARTITION BY TeamID ORDER BY Year) AS NextYearDefensiveActions
  FROM DEFENSIVE_STATISTICS ds
  JOIN YEARLY_STATISTICS ys ON ds.StatID = ys.StatID
  GROUP BY TeamID, Year
), MaxYear AS (
  SELECT MAX(Year) AS MaxYear FROM YEARLY_STATISTICS
)
SELECT
  t.TeamName,
  ROUND(AVG(dt.NextYearDefensiveActions - dt.TotalDefensiveActions),2) AS AvgImprovement
FROM DefensiveTrend dt
JOIN TEAM t ON dt.TeamID = t.TeamID
CROSS JOIN MaxYear
WHERE dt.Year BETWEEN MaxYear.MaxYear - 3 AND MaxYear.MaxYear - 1
GROUP BY t.TeamName
HAVING AVG(dt.NextYearDefensiveActions - dt.TotalDefensiveActions) > 0
ORDER BY AvgImprovement DESC
LIMIT 5;