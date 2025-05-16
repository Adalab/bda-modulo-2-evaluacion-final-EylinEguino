USE SAKILA;

-- 1.- Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

-- 2.  Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
FROM film
WHERE rating = 'PG-13';

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción

SELECT title, description
FROM film
WHERE description LIKE '%amazing%';

-- 4.  Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title
FROM film
WHERE length > 120;

-- 5.  Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Películas que no tienen clasificación "R" ni "PG-13"
SELECT title
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT rating, COUNT(rating) AS total_movies
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT cat.name AS category, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY rental_count DESC;

-- 12.  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, ROUND(AVG(length), 2) AS average_length
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love';

-- 14. Películas con "dog" o "cat" en la descripción
SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- 15. Actores que no aparecen en ninguna película
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- 16. Películas lanzadas entre 2005 y 2010
SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Películas de la misma categoría que "Family"
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
  SELECT category_id
  FROM category
  WHERE name = 'Family'
);

-- 18. Actores que aparecen en más de 10 películas
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración

SELECT c.name AS category, ROUND(AVG(f.length), 2) AS avg_length
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final

SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE DATEDIFF(r.return_date, r.rental_date) > 5;

-- 23.  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la 
-- categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
-- películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
  SELECT fa.actor_id
  cd "C:\Users\eguin\Desktop\adalab\modulo 2\bda-modulo-2-evaluacion-final-EylinEguino"
  FROM film_actor fa
  JOIN film_category fc ON fa.film_id = fc.film_id
  JOIN category c ON fc.category_id = c.category_id
  WHERE c.name = 'Horror'
);

-- BONUS*
-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas.
SELECT title
FROM film
WHERE film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy'
)
AND length > 180;

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. Pista: usa un JOIN de la tabla consigo misma (self join).
SELECT 
  a1.first_name AS actor1_first_name,
  a1.last_name AS actor1_last_name,
  a2.first_name AS actor2_first_name,
  a2.last_name AS actor2_last_name,
  COUNT(*) AS films_together
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY a1.actor_id, a2.actor_id
HAVING COUNT(*) >= 1;