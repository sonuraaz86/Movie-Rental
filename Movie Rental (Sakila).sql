#New vs Repeat Customer Purchasing Patterns
SELECT * FROM movierental.merged_sakila;
WITH customer_rentals AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_rentals = 1 THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS num_customers,
    AVG(total_rentals) AS avg_rentals
FROM customer_rentals
GROUP BY customer_type;


#Films with Highest Rental Rates & Demand
SELECT * FROM movierental.merged_sakila;
SELECT 
    f.title,
    f.rental_rate,
    COUNT(r.rental_id) AS total_rentals
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY f.rental_rate DESC, total_rentals DESC
LIMIT 10;


#Staff Performance vs Customer Spending
SELECT * FROM movierental.merged_sakila;
SELECT 
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    COUNT(p.payment_id) AS transactions,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS avg_transaction
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id
ORDER BY total_revenue DESC;

#Seasonal Trends in Customer Behavior
SELECT * FROM movierental.merged_sakila;
SELECT 
    MONTH(r.rental_date) AS month,
    COUNT(*) AS total_rentals
FROM rental r
GROUP BY MONTH(r.rental_date)
ORDER BY month;


#Language Popularity by Customer Location
SELECT * FROM movierental.merged_sakila;
SELECT 
    l.name AS language,
    ctry.country,
    COUNT(r.rental_id) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN language l ON f.language_id = l.language_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country ctry ON ci.country_id = ctry.country_id
GROUP BY l.name, ctry.country
ORDER BY rentals DESC;



#Customer Loyalty Impact on Revenue
SELECT * FROM movierental.merged_sakila;
SELECT 
    c.customer_id,
    COUNT(r.rental_id) AS total_rentals,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;


#Film Categories by Location
SELECT * FROM movierental.merged_sakila;
SELECT 
    cat.name AS category,
    ci.city,
    COUNT(r.rental_id) AS rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY cat.name, ci.city
ORDER BY rentals DESC;
