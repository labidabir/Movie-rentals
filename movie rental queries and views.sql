-- =====================================
-- week4_reports_fixed_final.sql
-- =====================================

PRAGMA foreign_keys = ON;

-- Drop existing views safely
DROP VIEW IF EXISTS top_customers_ytd_1;
DROP VIEW IF EXISTS repeat_rentals_1;
DROP VIEW IF EXISTS movie_utilization_1;
DROP VIEW IF EXISTS store_revenue_share_1;
DROP VIEW IF EXISTS customer_retention_1;
DROP VIEW IF EXISTS seasonal_rentals_1;
DROP VIEW IF EXISTS top_genres_per_store_1;

-- =====================================
  --Top customers by revenue (YTD)
-- =====================================
CREATE VIEW top_customers_ytd_1 AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    SUM(r.rental_fee + IFNULL(r.late_fee, 0)) AS total_revenue
FROM rentals_1 r
JOIN customers_1 c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_revenue DESC
LIMIT 10;

-- =====================================
-- Repeat Rentals (customers renting same movie ≥ 3 times)
-- =====================================
CREATE VIEW IF NOT EXISTS repeat_rentals_1 AS
SELECT 
    c.customer_id,
    c.name AS customer_name,
    m.movie_id,
    m.title AS movie_title,
    COUNT(r.rental_id) AS rental_count
FROM rentals_1 r
JOIN customers_1 c ON r.customer_id = c.customer_id
JOIN movies_1 m ON r.movie_id = m.movie_id
GROUP BY c.customer_id, m.movie_id
HAVING COUNT(r.rental_id) >= 3
ORDER BY rental_count DESC;


-- =====================================
 --Movie utilization
-- =====================================
CREATE VIEW movie_utilization_1 AS
SELECT 
    m.movie_id,
    m.title,
    COUNT(r.rental_id) AS total_rentals
FROM movies_1 m
LEFT JOIN rentals_1 r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_rentals DESC;

-- =====================================
--  Store revenue share (%)
-- =====================================
CREATE VIEW store_revenue_share_1 AS
WITH store_totals AS (
    SELECT 
        s.store_id,
        s.name AS store_name,
        SUM(r.rental_fee + IFNULL(r.late_fee, 0)) AS store_revenue
    FROM rentals_1 r
    JOIN stores_1 s ON r.store_id = s.store_id
    GROUP BY s.store_id
),
total_sum AS (
    SELECT SUM(store_revenue) AS total_revenue FROM store_totals
)
SELECT 
    st.store_id,
    st.store_name,
    ROUND((st.store_revenue / ts.total_revenue) * 100, 2) AS revenue_share_percent
FROM store_totals st, total_sum ts
ORDER BY revenue_share_percent DESC;

-- =====================================
-- Customer retention (simplified)
-- =====================================
CREATE VIEW customer_retention_1 AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(r.rental_id) AS total_rentals
FROM customers_1 c
JOIN rentals_1 r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_rentals DESC;

-- =====================================
-- Seasonal rentals (fallback: count by date_id)
-- =====================================
CREATE VIEW seasonal_rentals_1 AS
SELECT 
    r.date_id,
    COUNT(r.rental_id) AS total_rentals
FROM rentals_1 r
GROUP BY r.date_id
ORDER BY r.date_id;

-- =====================================
--Top genres per store
-- =====================================
CREATE VIEW top_genres_per_store_1 AS
SELECT
    s.store_id,
    s.name AS store_name,
    m.genre,
    COUNT(r.rental_id) AS total_rentals,
    RANK() OVER (PARTITION BY s.store_id ORDER BY COUNT(r.rental_id) DESC) AS genre_rank
FROM rentals_1 r
JOIN stores_1 s ON r.store_id = s.store_id
JOIN movies_1 m ON r.movie_id = m.movie_id
GROUP BY s.store_id, m.genre;

-- =====================================
-- Done creating all views
-- =====================================


SELECT * FROM top_customers_ytd_1;
SELECT * FROM repeat_rentals_1;
SELECT * FROM movie_utilization_1;
SELECT * FROM store_revenue_share_1;
SELECT * FROM customer_retention_1;
SELECT * FROM seasonal_rentals_1;
SELECT * FROM top_genres_per_store_1;
