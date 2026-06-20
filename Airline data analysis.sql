

create database airlines

use airlines


select top 10 * from cleaned_flights

select top 10 * from cleaned_passengers 

-- 1. Which airlines generated the highest total revenue?

select airline_name, count(*) as total_flights, round(sum(total_revenue) / 1000000,2) as revenue_million from cleaned_flights
group by airline_name
order by revenue_million desc

-- 2. Top 10 busiest flight routes

select top 10 concat(origin_airport, ' -> ', destination_airport) as flight_route, count(*) as total_flights
from cleaned_flights
group by origin_airport,destination_airport
order by total_flights desc

-- 3.Which weather conditions cause the highest delays?

select weather_condition, avg(departure_delay_minutes) as avg_delay 
from cleaned_flights
group by weather_condition
order by avg_delay desc

-- 4. Which travel class contributes the most revenue?

select p.travel_class, round(sum(f.total_revenue)/1000000,2) as revenue_millions
from cleaned_passengers p inner join cleaned_flights f
on p.customer_id = f.customer_id
group by p.travel_class
order by revenue_millions desc

-- 5. Monthly Flight Trend

select format(flight_date, 'MMM') as flight_month, count(*) as total_flights
from cleaned_flights
group by format(flight_date, 'MMM'),month(flight_date)
order by month(flight_date) 

-- 6. Top 10 Highest Spending Customers

select top 10 p.customer_id, p.passenger_name, round(sum(f.total_revenue),2) as total_spent
from cleaned_passengers p inner join cleaned_flights f
on p.customer_id = f.customer_id
group by p.customer_id, p.passenger_name
order by total_spent desc

-- 7. Rank Airlines by Revenue

select airline_name, round(sum(total_revenue)/ 1000000,2) as revenue_millions, dense_rank() over (order by round(sum(total_revenue)/ 1000000,2) desc) as revenue_ranks
from cleaned_flights
group by airline_name


-- 8. Which cities have the highest number of passengers?

select city, count(distinct customer_id) as total_passengers from cleaned_passengers
group by city
order by total_passengers desc

-- 9. Categorize customers based on spending.

with customer_spending as(
select p.customer_id, sum(f.total_revenue) as total_spending
from cleaned_passengers p inner join cleaned_flights f
on p.customer_id = f.customer_id
group by p.customer_id
), 
customer_segments as (
select customer_id, case
when total_spending > 700000 then 'High Value'
when total_spending between 70000 and 700000 then 'Medium Value'
else 'Low Value'
end as customer_segment
from customer_spending
)
select customer_segment, count(*) as total_customers
from customer_segments
group by customer_segment
order by total_customers desc

