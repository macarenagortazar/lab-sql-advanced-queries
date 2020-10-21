
-- In this lab, you will be using the Sakila database of movie rentals.
use sakila;

-- Instructions

-- 1. List each pair of actors that have worked together.
select fa1.film_id,a1.actor_id, concat(a1.first_name," ", a1.last_name) as "Actor 1", a2.actor_id, concat(a2.first_name," ", a2.last_name) as "Actor 2" from sakila.film_actor as fa1
join sakila.actor as a1
on fa1.actor_id=a1.actor_id
join sakila.actor as a2
on a1.actor_id<>a2.actor_id
group by a1.actor_id,a2.actor_id
order by a1.actor_id;

-- 2. For each film, list actor that has acted in more films.

#Number of movies acted
create view movies as (select actor_id, count(*) as acted from sakila.film_actor
group by actor_id
order by count(*) desc);
select*from movies;

#List of movies, with all actor and the total number of movies they have acted in
select film_id, a.actor_id, acted, row_number () over (partition by film_id) as Position from sakila.film_actor as a
join movies as m
on a.actor_id=m.actor_id
group by film_id, actor_id
order by film_id,acted desc;

with cte_movies_actors as (select film_id, a.actor_id, acted, row_number () over (partition by film_id) as Position from sakila.film_actor as a
join movies as m
on a.actor_id=m.actor_id
group by film_id, actor_id
order by film_id,acted desc)
select*from cte_movies_actors
where Position=1;

-- Pretty version
create view movies2 as (select m.actor_id, concat(first_name," ",last_name) as actor, acted from movies as m
join sakila.actor as a
on m.actor_id=a.actor_id
order by acted desc);
select*from movies2;

select f.title, m2.actor, m2.acted, row_number () over (partition by title order by acted desc) as Position from sakila.film_actor as fa
join sakila.film as f 
on fa.film_id=f.film_id
join movies2 as m2
on fa.actor_id=m2.actor_id
group by title, actor
order by title, acted desc;

with cte_movies_actors2 as (select f.title, m2.actor, m2.acted, row_number () over (partition by title order by acted desc) as Position from sakila.film_actor as fa
join sakila.film as f 
on fa.film_id=f.film_id
join movies2 as m2
on fa.actor_id=m2.actor_id
group by title, actor
order by title, acted desc)
select*from cte_movies_actors2
where Position=1;
