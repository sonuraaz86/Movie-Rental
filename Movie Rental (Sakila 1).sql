#Staff Availability Impact (Proxy: Transactions per Staff)
SELECT * FROM movierental.sakila_data;
SELECT 
    s.staff_id,
    COUNT(r.rental_id) AS rentals_handled,
    COUNT(DISTINCT r.customer_id) AS unique_customers
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id
ORDER BY rentals_handled DESC;

#Store Proximity vs Rental Frequency (Approximation)
SELECT * FROM movierental.sakila_data;
SELECT 
    s.store_id,
    ci.city,
    COUNT(r.rental_id) AS rentals
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN rental r ON st.staff_id = r.staff_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY s.store_id, ci.city;

#Film Categories vs Customer Segments (Proxy: Active Status)
SELECT * FROM movierental.sakila_data;
SELECT 
    cat.name AS category,
    c.active,
    COUNT(r.rental_id) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY cat.name, c.active;

#Highest Spending Customer Demographics
SELECT * FROM movierental.sakila_data;
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ci.city,
    ctry.country,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country ctry ON ci.country_id = ctry.country_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

#Inventory Availability Impact
SELECT * FROM movierental.sakila_data;
SELECT 
    ctry.country,
    cat.name AS category,
    COUNT(r.rental_id) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country ctry ON ci.country_id = ctry.country_id
GROUP BY ctry.country, cat.name
ORDER BY rentals DESC;

#Busiest Hours & Days

SELECT * FROM movierental.sakila_data;
SELECT 
    DAYNAME(rental_date) AS day,
    HOUR(rental_date) AS hour,
    COUNT(*) AS rentals
FROM rental
GROUP BY day, hour
ORDER BY rentals DESC;

#Cultural/Demographic Factors
SELECT * FROM movierental.sakila_data;
SELECT 
    ctry.country,
    cat.name AS category,
    COUNT(r.rental_id) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country ctry ON ci.country_id = ctry.country_id
GROUP BY ctry.country, cat.name
ORDER BY rentals DESC;

#Language Availability Impact

SELECT * FROM movierental.sakila_data;
SELECT 
    l.name AS language,
    COUNT(DISTINCT f.film_id) AS films_available,
    COUNT(r.rental_id) AS rentals
FROM language l
LEFT JOIN film f ON l.language_id = f.language_id
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY l.name
ORDER BY rentals DESC;











