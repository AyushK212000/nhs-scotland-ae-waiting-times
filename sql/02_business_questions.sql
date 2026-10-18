-- Q1: How has Scotland's 4-hour performance changed since 2018?
-- Note: 2026 covers January to August only.
USE nhs_ae;

-- SELECT YEAR(Month) AS Year,
-- SUM(NumberOfAttendancesAll) AS Attendances,
-- SUM(NumberWithin4HoursAll) AS Within4Hours,
-- ROUND(100 * SUM(NumberWithin4HoursAll) / SUM(NumberOfAttendancesAll),1) AS PcWithin4Hours
-- FROM ae_activity
-- WHERE NumberWithin4HoursAll IS NOT NULL
-- GROUP BY YEAR(Month)
-- ORDER BY Year;

-- Finding: performance fell from 90.9% (2018) to 68.4% (2024) and has stayed around
-- 68-70% since 2022 with no recovery. The 95% standard was not met in any year.
-- 2024 had fewer attendances than 2019, so demand alone does not explain the decline.


-- Q2: Which health boards perform best and worst, and is the gap widening?
-- Major emergency departments (Type 1) only, comparing 2018 with 2025 (latest full year).
-- WITH board_year AS(
--     SELECT HBName,
--     YEAR(Month) as Year,
--     100 * SUM(NumberWithin4HoursAll) / SUM(NumberOfAttendancesAll) AS Pct
--     FROM ae_activity 
--     WHERE DepartmentType = 'Type 1' AND NumberWithin4HoursAll IS NOT NULL AND YEAR(Month) IN (2018, 2025)
--     GROUP BY HBName, YEAR(Month)
-- )

-- SELECT HBName, 
-- ROUND(MAX(CASE WHEN Year = 2018 THEN Pct END), 1) AS Pct2018,
-- ROUND(MAX(CASE WHEN Year = 2025 THEN Pct END), 1) AS Pct2025,
-- ROUND(MAX(CASE WHEN Year = 2025 THEN Pct END) - MAX(CASE WHEN Year = 2018 THEN Pct END), 1) AS PctChange
-- FROM board_year
-- GROUP BY HBName
-- ORDER BY Pct2025 DESC;

-- Finding: all 14 boards declined between 2018 and 2025 (Type 1 sites).
-- NHS Forth Valley was lowest in both years (80.1% -> 48.2%).
-- Largest falls: Grampian (-37.6 pts) and Lanarkshire (-36.8 pts).
-- Gap between best and worst board grew from 18.4 to 45.3 points.
-- Island boards (Orkney, Western Isles) remain near 95% but have much smaller departments.


