-- =====================================
-- movie_schema.sql
-- Movie Rental Star Schema for SQLite
-- =====================================

-- Enable Foreign Key Constraints
PRAGMA foreign_keys = ON;

-- Drop tables if they already exist
DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS dates;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stores;

-- ====================
-- Dimension: dates
-- ====================
CREATE TABLE dates (
    date_id INTEGER PRIMARY KEY,
    full_date DATE,
    day INTEGER,
    month INTEGER,
    quarter INTEGER,
    year INTEGER
);

-- ====================
-- Dimension: movies
-- ====================
CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT,
    genre TEXT,
    release_year INTEGER,
    rating TEXT
);

-- ====================
-- Dimension: customers
-- ====================
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT,
    city TEXT,
    state TEXT,
    join_date DATE
);

-- ====================
-- Dimension: stores
-- ====================
CREATE TABLE stores (
    store_id INTEGER PRIMARY KEY,
    name TEXT,
    city TEXT,
    state TEXT
);

-- ====================
-- Fact Table: rentals
-- ====================
CREATE TABLE rentals (
    rental_id INTEGER PRIMARY KEY,
    date_id INTEGER,
    movie_id INTEGER,
    customer_id INTEGER,
    store_id INTEGER,
    rental_fee REAL,
    return_date DATE,
    late_fee REAL,
    FOREIGN KEY (date_id) REFERENCES dates(date_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

SELECT * FROM dates_1;
SELECT * FROM movies_1;
SELECT * FROM customers_1;
SELECT * FROM stores_1;
SELECT * FROM rentals_1;

-- =====================================
-- reports.sql
-- =====================================

-- Rentals per store (last 90 days)
SELECT 
    s.store_id,
    s.name AS store_name,
    COUNT(r.rental_id) AS rentals_last_90_days
FROM rentals_1 r
JOIN stores_1 s ON r.store_id = s.store_id
JOIN dates_1 d ON r.date_id = d.date_id
WHERE d.full_date >= DATE('now', '-90 days')
GROUP BY s.store_id, s.name
ORDER BY rentals_last_90_days DESC;

--  Top 5 movies by rental count (YTD) -- FIXED
SELECT 
    m.movie_id,
    m.title,
    COUNT(r.rental_id) AS rental_count
FROM rentals_1 r
JOIN movies_1 m ON r.movie_id = m.movie_id
JOIN dates_1 d ON r.date_id = d.date_id
WHERE d.full_date >= DATE('now', 'start of year')  -- fixed line
GROUP BY m.movie_id, m.title
ORDER BY rental_count DESC
LIMIT 5;

--  Revenue by genre (monthly roll-up)
SELECT 
    d.year,
    d.month,
    m.genre,
    SUM(r.rental_fee) AS total_revenue
FROM rentals_1 r
JOIN movies_1 m ON r.movie_id = m.movie_id
JOIN dates_1 d ON r.date_id = d.date_id
GROUP BY d.year, d.month, m.genre
ORDER BY d.year, d.month, total_revenue DESC;

--  Active customers per store (last 60 days)
SELECT 
    s.store_id,
    s.name AS store_name,
    COUNT(DISTINCT r.customer_id) AS active_customers
FROM rentals_1 r
JOIN stores_1 s ON r.store_id = s.store_id
JOIN dates_1 d ON r.date_id = d.date_id
WHERE d.full_date >= DATE('now', '-60 days')
GROUP BY s.store_id, s.name
ORDER BY active_customers DESC;

--  Late returns per store
SELECT 
    s.store_id,
    s.name AS store_name,
    COUNT(r.rental_id) AS late_returns
FROM rentals_1 r
JOIN stores_1 s ON r.store_id = s.store_id
WHERE r.late_fee > 0
GROUP BY s.store_id, s.name
ORDER BY late_returns DESC;

--  Average rental fee per genre
SELECT 
    m.genre,
    ROUND(AVG(r.rental_fee), 2) AS avg_rental_fee
FROM rentals_1 r
JOIN movies_1 m ON r.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY avg_rental_fee DESC;

--  Monthly revenue trend (with running total)
SELECT 
    d.year,
    d.month,
    SUM(r.rental_fee) AS monthly_revenue,
    SUM(SUM(r.rental_fee)) OVER (ORDER BY d.year, d.month) AS running_total
FROM rentals_1 r
JOIN dates_1 d ON r.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
