use music_store   -- access the database

-- senior most employee
select * from employee
order by levels desc
limit 1

-- which countries have the most invoices
select billing_country,count(Distinct invoice_id) as Total_invoice
from invoice
group by billing_country
order by Total_invoice desc
limit 5

-- top 3 values total invoice
select * from invoice
order by total desc
limit 3


-- which city has the best customers based on money. In those cities we would like to throw a promotion
select billing_city,sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc
where g.name='Rock'

-- which country has the best customer -- the customer who sped most 

select c.customer_id,concat(first_name,'   ',last_name) as Full_name,round(sum(total),1) as Total_spend from customer c
join invoice i on i.customer_id=c.customer_id
group by c.customer_id,first_name,last_name
order by Total_spend desc
limit 1

-- write query to return all email,name, genre of all rock music listeners

select Distinct c.customer_id,concat(first_name,'   ',last_name) as Full_name, email from invoice i
join invoice_line il on il.invoice_id=i.invoice_id
join customer c on c.customer_id=i.customer_id
join track t on t.track_id=il.track_id 
join genre g on g.genre_id=t.genre_id
where g.name like 'Rock'
order by  email


-- Let's invite all the artists who write most of the rock muscis . retur artist name and track count 

select ar.name,count(Distinct track_id) as Track_no from artist ar
join album2 al on al.artist_id=ar.artist_id
join track t on t.album_id=al.album_id
join genre g on g.genre_id=t.genre_id
Where g.name like 'Rock'
group by ar.name
order by Track_no desc


-- return thetrack name that a song length more than the average length 
select track_id,name,milliseconds from track
where milliseconds> (select avg(milliseconds) from track)
order by milliseconds desc

-- how much amount spend by each customer on each customer
select c.customer_id,concat(first_name,'   ' ,last_name) as Customer_full_name,ar.name as Artist_name,round(sum(total),1) as Total_Spend from customer c
join invoice i on i.customer_id=c.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album2 a on a.album_id=t.album_id
join artist ar on ar.artist_id=a.artist_id
group by c.customer_id,first_name,last_name,ar.name
order by customer_id ASC,Artist_name ASC


-- most popular music genre in each country 

select purchases,country,name,genre_id from
(select count(invoice_line.quantity)as purchases ,customer.country,genre.name,genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rnk
from invoice_line 
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2)k
where k.rnk<2
order by 2 ASC,1 DESC


# best customer on each customer
select customer_id,Full_name,country,Total from
(select *,dense_rank() over(partition by country order by Total desc)as rnk from
(select c.customer_id,concat(first_name, '   ',last_name) as Full_name,country,round(sum(total),1) as Total
from customer c
join invoice i on i.customer_id=c.customer_id
group by c.customer_id,Full_name,country
order by Total desc)k)p
where p.rnk<2



-- writedown the top 5 countries where rock music are demanding and revenue
select  billing_country,round(sum(total),1) as Total from invoice i
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
where g.name like'Rock'
group by billing_country
order by Total desc
Limit 5






