CREATE DATABASE airline_project;
USE airline_project;

SELECT COUNT(*) AS Total_Records
FROM maindata_final;

SELECT *
FROM maindata_final
LIMIT 10;
DESCRIBE maindata_final;


-- Question 1 
SELECT
`Year`,
`Month (#)`,
`Day`,

STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d') AS Date_Field,

`Year` AS YearNo,

`Month (#)` AS MonthNo,

MONTHNAME(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d')) AS MonthName,

CONCAT('Q',QUARTER(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d'))) AS Quarter,

DATE_FORMAT(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d'),'%Y-%b') AS YearMonth,

DAYNAME(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d')) AS WeekDayName,

WEEK(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d')) AS WeekNo

FROM maindata_final;

-- Question 2
-- Yearly load factor %
SELECT
    `Year`,
    CONCAT(
        ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100, 2),
        '%'
    ) AS `Load Factor %`
FROM maindata_final
GROUP BY `Year`
ORDER BY `Year`;

-- Quarterly load factor %
SELECT
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d'))) AS Quarter,
    CONCAT(
        ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100, 2),
        '%'
    ) AS `Load Factor %`
FROM maindata_final
GROUP BY Quarter
ORDER BY Quarter;

-- Monthly load factor %
SELECT
    MONTHNAME(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) AS MonthName,

    CONCAT(
        ROUND((SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100, 2),
        '%'
    ) AS `Load Factor %`

FROM maindata_final

GROUP BY
    `Month (#)`,
    MonthName

ORDER BY
    `Month (#)`;


-- Question 3
-- Load factor by Carrier name
SELECT
    `Carrier Name`,
    CONCAT(
        ROUND(
            (SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,
            2
        ),
        '%'
    ) AS `Load Factor %`
FROM maindata_final
GROUP BY `Carrier Name`
ORDER BY (SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) DESC;

-- Question 4
-- Top 10 Carrier Names based on passengers preference
SELECT
    `Carrier Name`,
    SUM(`# Transported Passengers`) AS Total_Passengers
FROM maindata_final
GROUP BY `Carrier Name`
ORDER BY Total_Passengers DESC
LIMIT 10;

-- Question 5
-- Top Routes (From - To City) based on the number of transported passengers.
SELECT
    `From - To City`,
    SUM(`# Transported Passengers`) AS Total_Passengers
FROM maindata_final
GROUP BY `From - To City`
ORDER BY Total_Passengers DESC
LIMIT 10;

-- Question 6
-- Load Factor Percentage on Weekdays vs Weekends.
SELECT
    CASE
        WHEN DAYOFWEEK(STR_TO_DATE(CONCAT(`Year`, '-', `Month (#)`, '-', `Day`), '%Y-%m-%d')) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS `Day Type`,
    CONCAT(
        ROUND(
            (SUM(`# Transported Passengers`) / SUM(`# Available Seats`)) * 100,
            2
        ),
        '%'
    ) AS `Load Factor %`
FROM maindata_final
GROUP BY `Day Type`;

-- Question 7
-- Number of Flights based on Distance Group.
SELECT
    `%Distance Group ID` AS `Distance Group ID`,
    SUM(`# Departures Performed`) AS Total_Flights
FROM maindata_final
GROUP BY `%Distance Group ID`
ORDER BY `%Distance Group ID`;