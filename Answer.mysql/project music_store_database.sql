--q1.senior most employee based on job title---
select employee_id , last_name, first_name ,title,levels 
from employee
order by levels desc
limit 1;

--q2.which countries have most invoices
select billing_country,count(*) as total_invoices
from invoice
group by billing_country
order by count(*) desc;

--q3.what are top 3 values of invoices
select total
from invoice
order by total desc
limit 3;

--q4. city that have highest total invoice
select billing_city , sum(total) as total_invoices
from invoice
group by billing_city
order by total_invoices desc
limit 1;
--q5 write a query that return the customer who have spent the most money
select  c.customer_id ,c.first_name,c.last_name,sum(i.total) as money_spent
from customer as c
join invoice as i 
on i.customer_id = c.customer_id
group by 1,2,3
order by money_spent desc
limit 1;

--q6. query to return first_name,last_name,email,genre of all music listner order alphabetically based on email
select c.first_name,c.last_name,c.Email
from genre as g
join track as t 
on t.genre_id = g.genre_id 
join invoice_line as l
on l.track_id = t.track_id 
join invoice as i 
on i.invoice_id = l.invoice_id
join customer as c 
on c.customer_id = i.customer_id
where g.name = 'Rock'
order by email asc;
--q7.write a query that returns the artist name and total track count of the top 10 rock band.
select a.artist_id, a.name , count(a.artist_id) as number_of_songs
from artist as a 
join album as b 
on b.artist_id=a.artist_id
join track as t 
on t.album_id = b.album_id 
join genre as g 
on g.genre_id = t.genre_id
where g.name = 'Rock'
group by 1
order by 3 desc
limit 10;

--q8.return track_name that have song length longer than average song length 
select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) as length_songs
				   from track)
order by milliseconds desc;

--q9:Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent *
with cte as (select a.artist_id,a.name,sum(l.unit_price*l.quantity) as total_spent
			from customer as c 
			join invoice as i 
			on i.customer_id = c.customer_id 
			join invoice_line as l 
			on l.invoice_id = i.invoice_id 
			join track as t 
			on t.track_id = l.track_id 
			join album as b 
			on b.album_id = t.album_id
			join artist as a 
			on a.artist_id = b.artist_id
			group by 1
			order by 3 desc
			limit 1)
select c.first_name,c.last_name,e.name,e.total_spent
from customer as c 
join invoice as i 
on i.customer_id = c.customer_id 
join invoice_line as l 
on l.invoice_id = i.invoice_id 
join track as t 
on t.track_id = l.track_id
join album as b 
on b.album_id = t.album_id
join cte as e
on e.artist_id = b.artist_id
group by 1,2,3,4
order by 4 desc;

-- Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
--the maximum number of purchases is shared return all Genres. */

with cte as (select g.genre_id,g.name,c.country as country,
			count(l.quantity) as amount_of_purchase,
			row_number()over(partition by c.country order by count(l.quantity)desc)as rank_no
			from genre as g 
			join track as t 
			on t.genre_id =g.genre_id
			join invoice_line as l 
			on l.track_id = t.track_id
			join invoice as i 
			on i.invoice_id = l.invoice_id
			join customer as c 
			on c.customer_id = i.customer_id
			group by 1,2,3
			order by 3asc ,4 desc)

select * from cte 
where rank_no = 1;

--Q11: Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount. */

with cte as (select c.customer_id,c.first_name,c.last_name,i.billing_country,
			 sum(i.total) as total_amount,
			 row_number() over(partition by i.billing_country order by sum(i.total) desc) as rank_no
			from customer as c
			join invoice as i 
			on i.customer_id = c.customer_id
			 group by 1,2,3,4)
select*from cte 
where rank_no = 1;
			


