use sakila;

# 1.How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film;

select title, count(inventory_id) from inventory
join film using (film_id) where title = 'Hunchback Impossible';

# 2. List all films whose length is longer than the average of all the films.
select title, length from film
where length > (select avg(length) from film);

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film_actor;
select first_name, last_name from actor 
where actor_id in (select actor_id from film_actor where film_id in (select film_id from film where title = 'Alone Trip'));

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized 
# as family films.
select * from film_category;
select * from category;

select f.film_id, f.title from film f
join film_category fc using (film_id)
join category c using (category_id)
where c.name = 'family';

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify 
# the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select * from customer; #address_id, first_name, last_name, email
select * from address; #address_id, city_id
select * from city; #city_id, country_id
select * from country; #country

select first_name, last_name, email from customer
join address using (address_id)
join city using (city_id)
join country using (country_id) where country = 'Canada';

select first_name, last_name, email from customer 
where address_id in(select address_id from address where city_id in (select city_id from city where country_id in (select country_id from country where country = 'Canada')));

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select film_id from film_actor where actor_id in (select actor_id from(
select actor_id, count(film_id) from film_actor
group by actor_id
order by count(film_id) desc limit 1)sub);


select * from film_actor;

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
# ie the customer that has made the largest sum of payments
select * from rental; # customer_id, inventory_id, 
select * from payment; #rental_id, amount, customer_id, 
select * from inventory; #inventory_id, film_id

select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) desc limit 1; 

select film_id from inventory
join rental using (inventory_id) 
where customer_id in (select customer_id from (select customer_id, sum(amount) from payment
group by customer_id order by sum(amount) desc limit 1)sub); 

# 8.Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
with cte as(
select customer_id, sum(amount) as total_amount_spent from payment 
group by customer_id)
select customer_id, total_amount_spent from cte where total_amount_spent > (select avg(total_amount_spent) from cte);







