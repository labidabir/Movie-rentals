CREATE TABLE `rentals` (
  `rental_id` integer PRIMARY KEY,
  `date_id` integer,
  `movie_id` integer,
  `customer_id` integer,
  `store_id` integer,
  `rental_fee` numeric,
  `return_date` date,
  `late_fee` numeric
);

CREATE TABLE `dates` (
  `date_id` integer PRIMARY KEY,
  `full_date` date,
  `day` integer,
  `month` integer,
  `quarter` integer,
  `year` integer
);

CREATE TABLE `movies` (
  `movie_id` integer PRIMARY KEY,
  `title` varchar(255),
  `genre` varchar(255),
  `release_year` integer,
  `rating` varchar(255)
);

CREATE TABLE `customers` (
  `customer_id` integer PRIMARY KEY,
  `name` varchar(255),
  `city` varchar(255),
  `state` varchar(255),
  `join_date` date
);

CREATE TABLE `stores` (
  `store_id` integer PRIMARY KEY,
  `name` varchar(255),
  `city` varchar(255),
  `state` varchar(255)
);

ALTER TABLE `rentals` ADD FOREIGN KEY (`date_id`) REFERENCES `dates` (`date_id`);

ALTER TABLE `rentals` ADD FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`);

ALTER TABLE `rentals` ADD FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`);

ALTER TABLE `rentals` ADD FOREIGN KEY (`store_id`) REFERENCES `stores` (`store_id`);
