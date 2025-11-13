-- =====================================
-- dq_checks.sql  (Week 5 - Data Quality)
-- =====================================
PRAGMA foreign_keys = ON;

--  Null date or missing foreign keys in rentals
SELECT rental_id
FROM rentals_1
WHERE date_id IS NULL
   OR movie_id IS NULL
   OR customer_id IS NULL
   OR store_id IS NULL;

--  Negative or zero rental fees or late fees
SELECT rental_id, rental_fee, late_fee
FROM rentals_1
WHERE rental_fee < 0 OR late_fee < 0;

--  Return date earlier than rental date
SELECT r.rental_id, d.full_date AS rental_date, r.return_date
FROM rentals_1 r
JOIN dates_1 d ON r.date_id = d.date_id
WHERE DATE(r.return_date) < DATE(d.full_date);

--  Missing referenced customers (foreign key violation check)
SELECT r.customer_id
FROM rentals_1 r
LEFT JOIN customers_1 c ON r.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Duplicate customer records (same name + city)
SELECT name, city, COUNT(*) AS duplicate_count
FROM customers_1
GROUP BY name, city
HAVING COUNT(*) > 1;
