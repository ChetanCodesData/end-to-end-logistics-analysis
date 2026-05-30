select * from shipment

-- EXPLORATORY DATA ANALYSIS(EDA)

--Total number of shipment 

select count(*) as total_shipment

from shipment

--Average freight_cost

select 
AVG(freight_cost) as avg_cost
from shipment

--3. total number of freight_cost
select 
SUM(freight_cost) as total_cost
from shipment

-- carrier performance analysis

select

carrier,
avg(delivery_days) as avg_days
from shipment

group by carrier
order by avg_days desc

--Highest freight cost by state

select

destination_state,
max(freight_cost) as max_cost_state
from shipment

group by destination_state
order by max_cost_state desc;

--Heavy shipment analysis

select

carrier,
max(weight_kg) as max_weight,
min(weight_kg) as min_weight

from shipment
group by carrier

-- monthly shipment trends

select 

extract(month from ship_date) as month,
count(*) as total_shipments

from shipment

group by month 
order by month;

--Delivery days analysis

select * from shipment
where delivery_days>=7

--damage shipments per carrier

SELECT carrier,
COUNT(*) AS damaged_shipments
FROM shipment
WHERE damage_reported = 'Yes'
GROUP BY carrier
ORDER BY damaged_shipments DESC; 

--Correlation between weight_kg and freight_kg
SELECT
ROUND(CORR(weight_kg, freight_cost)::NUMERIC,2)
AS weight_freight_correlation
FROM shipment;