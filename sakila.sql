USE sakila;

-- * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, " ", last_name) AS `Actor Name` FROM actor;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name from actor where last_name like('%GEN%');

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name FROM actor where last_name like('%LI%')
ORDER BY last_name, first_name;

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor ADD COLUMN description BLOB;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS last_name_count from actor GROUP BY last_name;

-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS last_name_count from actor GROUP BY last_name HAVING last_name_count > 1;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SELECT * FROM actor WHERE (first_name, last_name) = ('GROUCHO', 'WILLIAMS');
UPDATE actor SET first_name = 'HARPO' WHERE actor_id = 172;

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = 'GROUCHO' WHERE actor_id = 172;

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT staff.first_name, staff.last_name, address.address FROM staff JOIN address ON staff.address_id = address.address_id;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS 'Total $ Aug-2005' FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
WHERE YEAR(payment_date) = 2005 AND MONTH(payment_date) = 8
-- WHERE payment.payment_date LIKE ('2005-08%')
GROUP BY staff_id;

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id) AS actor_count
FROM film_actor INNER JOIN film ON film_actor.film_id = film.film_id
GROUP BY film.film_id;
-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, count(title) AS number_of_copies
FROM film INNER JOIN inventory ON inventory.film_id = film.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY film.film_id;

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT last_name, first_name, SUM(amount) AS total_paid FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;
