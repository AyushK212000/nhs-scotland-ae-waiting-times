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

-- Q3: Is there a winter pressure pattern?
-- Type 1 sites, full years 2018-2025 only, so every calendar month covers the same 8 years.

-- SELECT 
-- MONTH(Month) AS MonthNum,
-- MONTHNAME(Month) AS MonthName,
-- ROUND(SUM(NumberOfAttendancesAll) / COUNT(DISTINCT YEAR(Month))) AS AvgAttendances,
-- ROUND(100 * SUM(NumberWithin4HoursAll) / SUM(NumberOfAttendancesAll) , 1) AS PctWithin4Hours
-- FROM ae_activity 
-- WHERE DepartmentType = "Type 1" AND NumberWithin4HoursAll IS NOT NULL AND YEAR(Month) BETWEEN 2018 AND 2025
-- GROUP BY MONTH(Month), MONTHNAME(Month)
-- ORDER BY MonthNum;

-- Finding: performance declines every autumn, from 76.4% (Aug) to a low of 71.2% (Dec),
-- and is best in May-July (~78%). The worst months are not the busiest: August has the
-- most attendances, December has fewer than average, so winter pressure is not driven
-- by attendance volume alone. Spring 2020 (COVID) slightly lifts April-May figures.

-- Q4a: Which days of the week are busiest?
-- 58 sites submitting episode-level data, full years 2018-2025.

-- SELECT DayNumber, Day, SUM(NumberOfAttendances) AS Attendances, 
-- ROUND(100*SUM(NumberOfAttendances) / SUM(SUM(NumberOfAttendances)) OVER () , 1) AS PctOfWeek
-- FROM ae_when
-- WHERE YEAR(Month) BETWEEN 2018 AND 2025
-- GROUP BY DayNumber, Day
-- ORDER BY DayNumber;

-- Q4b: Which hours are busiest?
-- SELECT HourStart, Hour, SUM(NumberOfAttendances) AS Attendances, 
-- ROUND(100*SUM(NumberOfAttendances) / SUM(SUM(NumberOfAttendances)) OVER () , 1) AS PctOfDay
-- FROM ae_when
-- WHERE YEAR(Month) BETWEEN 2018 AND 2025
-- GROUP BY HourStart, Hour
-- ORDER BY HourStart;

-- Finding (Q4a): Monday is busiest (16.0% of weekly attendances vs 14.3% if even);
-- demand falls through the week to a low on Saturday (13.1%). Monday has ~22% more
-- attendances than Saturday.
-- Finding (Q4b): peak hour is 11:00-11:59 (7.1%), about 6x the quietest hour
-- (05:00-05:59, 1.2%). 10:00-18:59 accounts for ~59% of attendances; midnight-08:00 ~12%.
-- Based on 58 sites submitting episode-level data; attendance counts only (no waits).

-- Q5: Are long waits (8+ and 12+ hours) growing faster than attendances?
-- Episode-level sites only (8h/12h waits are only recorded there), full years 2018-2025.
-- Rates are the main measure, because the number of sites reporting episode-level
-- data changed over time.

WITH yearly AS (
    SELECT
        YEAR(Month)                      AS Year,
        SUM(NumberOfAttendancesEpisode)  AS Attendances,
        SUM(NumberOver8HoursEpisode)     AS Over8Hours,
        SUM(NumberOver12HoursEpisode)    AS Over12Hours
    FROM ae_activity
    WHERE NumberOfAttendancesEpisode IS NOT NULL
      AND YEAR(Month) BETWEEN 2018 AND 2025
    GROUP BY YEAR(Month)
)
SELECT
    Year,
    Attendances,
    Over8Hours,
    Over12Hours,
    ROUND(100 * Over8Hours  / Attendances, 2) AS PctOver8Hours,
    ROUND(100 * Over12Hours / Attendances, 2) AS PctOver12Hours,
    ROUND(Attendances / FIRST_VALUE(Attendances) OVER (ORDER BY Year), 2) AS AttendancesVs2018,
    ROUND(Over12Hours / FIRST_VALUE(Over12Hours) OVER (ORDER BY Year), 2) AS Over12HoursVs2018
FROM yearly
ORDER BY Year;