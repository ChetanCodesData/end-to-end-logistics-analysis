--1. View Raw Data
SELECT *FROM shipments;

--2. Check Total Rows
SELECT COUNT(*)FROM shipments;

--3. Find NULL Values
SELECT *
FROM shipments
WHERE origin_warehouse IS NULL
   OR destination_city IS NULL
   OR carrier IS NULL;

 --4 Remove Extra Spaces
UPDATE shipments
SET origin_warehouse = TRIM(origin_warehouse),
    destination_city = TRIM(destination_city),
    carrier = TRIM(carrier);

--5. Proper Capitalization
UPDATE shipments
SET origin_warehouse = INITCAP(origin_warehouse),
    destination_city = INITCAP(destination_city),
	destination_state = UPPER(INITCAP(destination_state)),
	damage_report = INITCAP(damage_report),
	shipment_status = INITCAP(shipment_status);

--6. Convert Carrier to Uppercase
UPDATE shipments
SET carrier = UPPER(carrier);

--7. Replace NULL Values
UPDATE shipments
SET carrier = 'UNKNOWN'
WHERE carrier IS NULL;

-- Handling null values
UPDATE shipments
SET carrier = COALESCE(carrier, 'UNKNOWN'),
    destination_city = COALESCE(destination_city, 'N/A'),
    freight_cost = COALESCE(freight_cost, 0),
    weight_kg = COALESCE(weight_kg, 0),
    ship_date = COALESCE(ship_date, '2026-01-01'),
	delivery_date= COALESCE(delivery_date, '2026-02-26');

--8. Check Duplicate Rows
SELECT shipment_id, COUNT(*)
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;

--9. Remove Duplicates using ROW_NUMBER
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY shipment_id
               ORDER BY shipment_id
           ) AS rn
    FROM shipments
)

DELETE FROM shipments
WHERE shipment_id IN (
    SELECT shipment_id
    FROM cte
    WHERE rn > 1
);

--10. Find Negative Values
SELECT *
FROM shipments
WHERE freight_cost < 0
   OR weight_kg < 0;


--11. Convert Negative to Positive
UPDATE shipments
SET freight_cost = ABS(freight_cost)
WHERE freight_cost < 0;

UPDATE shipments
SET items_count = ABS(items_count)
WHERE items_count < 0;


--12. Fix Weight Values
UPDATE shipments
SET weight_kg = ABS(weight_kg)
WHERE weight_kg < 0;

--13. Find Suspicious Values
SELECT *
FROM shipments
WHERE freight_cost > 100000
   OR weight_kg > 1000;

--14. Calculate Transit Days
SELECT shipment_id,
       delivery_date - ship_date AS transit_days
FROM shipments;

--15. Find Wrong Dates
SELECT *
FROM shipments
WHERE delivery_date < ship_date;





