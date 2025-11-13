EXPLAIN QUERY PLAN
SELECT c.name, SUM(r.rental_fee)
FROM rentals_1 r
JOIN customers_1 c ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

CREATE INDEX idx_rentals_customer_id ON rentals_1(customer_id);
CREATE INDEX idx_rentals_movie_id ON rentals_1(movie_id);
CREATE INDEX idx_rentals_date_id ON rentals_1(date_id);


EXPLAIN QUERY PLAN
SELECT c.name, SUM(r.rental_fee)
FROM rentals_1 r
JOIN customers_1 c ON r.customer_id = c.customer_id
GROUP BY c.customer_id;
