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
SELECT* FROM dates_1;
SELECT * FROM movies_1;
SELECT * FROM customers_1;
SELECT * FROM stores_1;
SELECT * FROM rentals_1;