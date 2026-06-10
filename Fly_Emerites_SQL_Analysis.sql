--- 1. KPI Analysis----
-- 1: Total Flights

SELECT COUNT(*) AS Total_Flights
FROM flights;

-- 2: Total Cancelled Flights
select count(*) as Total_Canclled_flights
from flights
where cancelled = TRUE;

--3: Cancellation Rate (%)
SELECT
    ROUND(
        SUM(CASE WHEN cancelled = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS cancellation_rate
FROM flights;

-- 4: Average Departure Delay
select round(avg(departure_delay),2) as Avg_Departure_Delay
from flights
where cancelled = FALSE;

-- 5: Average Arrival Delay
SELECT
ROUND(AVG(arrival_delay),2) AS Avg_Arrival_Delay
FROM flights
WHERE cancelled = FALSE;

-- 6: On-Time Performance (OTP)
SELECT
ROUND(
COUNT(CASE WHEN arrival_delay <= 15 THEN 1 END)
*100.0 /
COUNT(*),
2
) AS OTP_Rate
FROM flights
WHERE cancelled = FALSE;


--- 2. Airline Performance Analysis
---Best & Worst Airlines
select 
airline,
round(avg(arrival_delay),3) as Avg_Delay
from flights
where cancelled = FALSE
group by airline
order by Avg_Delay;

--- Airline Cancellation Rate
select
airline,
ROUND(SUM(CASE WHEN cancelled = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
2
) as Cancelation_Rate
from flights
group by airline
order by Cancelation_Rate DESC;

---- 3. Airport Performance Analysis
--Airports with Highest Delay
select
origin_airport,
round(avg(departure_delay),2) as Avg_Departure_Delay
from flights
where cancelled = FALSE
group by origin_airport
order by Avg_Departure_Delay desc
limit 20;

--Airports with Highest Cancellation
select
origin_airport,
ROUND(SUM(CASE WHEN cancelled = TRUE THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),2
) as Cancelation_Rate
from flights
group by origin_airport
order by Cancelation_Rate desc
limit 20;

---4. Time-Based EDA
--Monthly Delay Trend
select
month,
round(avg(arrival_delay),2) as Avg_Delay
from flights
where cancelled = FALSE
group by month
order by month;

--Day of Week Analysis
select
day_of_week,
round(avg(arrival_delay),2) as Avg_Delay
from flights
where cancelled = FALSE
group by day_of_week
order by day_of_week;

--Hour-wise Delay Analysis
select
EXTRACT(HOUR FROM actual_departure_time) AS Hour,
round(avg(arrival_delay),2) as Avg_Delay
from flights
where cancelled = FALSE
group by Hour
order by Hour;

ALTER TABLE flights
ADD COLUMN actual_departure_time TIME;

UPDATE flights
SET actual_departure_time =
    scheduled_departure +
    (departure_delay * INTERVAL '1 minute')
WHERE departure_delay IS NOT NULL;

---- 5. Delay Cause Analysis
-- which factor contributes most.
SELECT
ROUND(SUM(airline_delay),0) AS Airline_Delay,
ROUND(SUM(weather_delay),0) AS Weather_Delay,
ROUND(SUM(security_delay),0) AS Security_Delay,
ROUND(SUM(air_system_delay),0) AS Air_System_Delay,
ROUND(SUM(late_aircraft_delay),0) AS Late_Aircraft_Delay
FROM flights;

-- Percentage Contribution
SELECT
ROUND(
SUM(weather_delay)*100.0/
(
SUM(weather_delay)+
SUM(airline_delay)+
SUM(security_delay)+
SUM(air_system_delay)+
SUM(late_aircraft_delay)
),2
) AS Weather_Percentage
FROM flights;

---- 6. Route Analysis
-- Most Busy Routes
select
origin_airport,
destination_airport,
count(*) as flights
from flights
group by origin_airport, destination_airport
order by flights desc
limit 20;

-- Routes with Highest Delays
SELECT
origin_airport,
destination_airport,
ROUND(AVG(arrival_delay),2) AS Avg_Delay
FROM flights
WHERE cancelled = FALSE
GROUP BY origin_airport,destination_airport
ORDER BY Avg_Delay DESC
LIMIT 20;

---- 7. Cancellation Reason Analysis
select
cancellation_reason,
count(*) as Total_Cancelled
from flights
group by cancellation_reason
order by Total_Cancelled desc;

