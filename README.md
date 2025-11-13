# Movie Rental Star Schema (SQLite Project)

## Import Steps
1. Open [SQLite Online](https://sqliteonline.com).
2. Upload and run `movie_schema.sql`.
3. Import CSVs using the “Import” button for each table (_1 versions).
4. Run `views.sql` and `reports.sql` to generate analytics.

## Included Files
- **movie_schema.sql:** star schema (dates, movies, customers, stores, rentals)
- **views.sql:** reporting views (#8–#14)
- **dq_checks.sql:** 5+ data-quality validations
- **performance.md:** index & query-plan comparison
- **ERD.png:** schema diagram (generated via dbdiagram.io or Draw.io)

## Screenshots
- `top_customers_ytd_1` output
- `repeat_rentals_1` result
- EXPLAIN QUERY PLAN before/after
