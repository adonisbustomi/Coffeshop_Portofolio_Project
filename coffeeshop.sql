create database coffeeshop;
use coffeeshop;
SHOW VARIABLES LIKE 'secure_file_priv';
set global local_infile = 1;
SET SQL_SAFE_UPDATES = 0;
SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
CREATE TABLE transactions
(
transaction_id INT PRIMARY KEY,
transaction_date text,
transaction_time time,
transaction_qty int,
store_id int,
store_location text,
product_id int,
unit_price float,
product_category text,
product_type text,
product_detail text
);

load data local infile 'C:/Data housing/Coffeeshopsales.csv'
into table transactions
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

########################################################################################
#Cleaning
-- mengganti tipe data date dari text menjadi date

select
	transaction_date,
    STR_TO_DATE(transaction_date, '%m/%d/%Y')
from
	transactions;

update transactions
set transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');

#######################################################################################
#data exploration
select
	*
from
	transactions;
#cek produk apa yang jadi top seller dan menyumbang revenue terbesar per bulan
-- 1. total revenue
select
	sum(transaction_qty * unit_price) as total_revenue
from
	transactions;
-- 2. tren revenue per bulan (secara garis besarnya)
select
	month(transaction_date) as calendar_month,
	sum(transaction_qty * unit_price) as total_revenue
from
	transactions
group by
	calendar_month
order by
	total_revenue desc;
-- 3. cari tau total revenue per bulannya dan cari tau share per product categorynya
-- misal bulan 1 total revenue sekian trus cari tau category a nyumbang berapa dll
with monthly_revenue as(
select
	month(transaction_date) as calendar_month,
	sum(transaction_qty * unit_price) as monthly_revenue
from
	transactions
group by
	calendar_month)
,
monthly_category_revenue as(
select
	month(transaction_date) as calendar_month,
    product_category,
    sum(transaction_qty * unit_price) as category_revenue,
    row_number() over(partition by month(transaction_date)
    order by sum(transaction_qty * unit_price)desc) as category_rank
from
	transactions
group by
	calendar_month,
    product_category)
    
select
	mcr.calendar_month,
    mcr.product_category,
    mcr.category_revenue,
    mr.monthly_revenue
from
	monthly_category_revenue mcr
join
	monthly_revenue mr on mcr.calendar_month = mr.calendar_month;
use coffeeshop;
    
-- 4. bandingin revenue per product_category 
-- dengan total revenue keseluruhan, supaya nanti bisa hitung kontribusi masing-masing kategori. 
with total_revenue as
(
select
	sum(transaction_qty * unit_price) as total_revenue
from
	transactions
),
monthly_category_revenue as
(
select
    product_category,
    sum(transaction_qty * unit_price) as category_revenue
from
	transactions
group by
    product_category
)

select
    mcr.product_category,
    mcr.category_revenue,
    tr.total_revenue
from
	monthly_category_revenue mcr
cross join
    total_revenue tr
order by
	category_revenue desc;
    
-- 5. product category apa yang paling laku tiap bulan dan penyumbang revenue terbesar
with monthly_category_revenue as(
select
	month(transaction_date) as calendar_month,
    product_category,
    sum(transaction_qty * unit_price) as revenue,
    row_number() over(partition by month(transaction_date)
    order by sum(transaction_qty * unit_price)desc) as ranking
from
	transactions
group by
	calendar_month,
    product_category)
select
	*
from
	monthly_category_revenue
where
	ranking = 1;
    
-- 6. Top product performance within each product type (with contribution to type revenue)
with product_type_revenue as
(
select
	product_type,
    sum(transaction_qty * unit_price) as type_revenue
from
	transactions
group by
	product_type
), 

product_detail_revenue as(
select
	product_type,
	product_detail,
    sum(transaction_qty * unit_price) as product_revenue,
    rank() over(partition by product_type
    order by sum(transaction_qty * unit_price) desc) as rankingnye
from
	transactions
group by
	product_type,
	product_detail)
    
select
	pdr.product_type,
    pdr.product_detail,
    pdr.product_revenue,
    ptr.type_revenue,
    rankingnye
from
	product_detail_revenue pdr
join
	product_type_revenue ptr on pdr.product_type = ptr.product_type
order by
	product_type,
    rankingnye;
-- 7. product type revenue paling tinggi
select
	product_type,
    sum(transaction_qty * unit_price) as revenue
from	
	transactions
group by
	product_type
order by
	revenue desc;

-- 8. product detail yang paling laku revenue paling tinggi
select
	product_detail,
    sum(transaction_qty * unit_price) as revenue
from
	transactions
group by
	product_detail
order by
	revenue desc;
-- 9. Jam sibuk
SELECT
	month(transaction_date) as calendar_month,
	CASE
		WHEN HOUR(transaction_time) BETWEEN 7 AND 10 THEN '07:00 - 10:00'
		WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN '11:00 - 14:00'
		WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00 - 17:00'
		WHEN HOUR(transaction_time) BETWEEN 18 AND 21 THEN '18:00 - 21:00'
		ELSE 'Lainnya'
	END AS interval_jam,
  SUM(transaction_qty * unit_price) AS revenue,
  COUNT(*) AS total_transaksi
FROM
	transactions
group by
	calendar_month,
    interval_jam;
-- 10. Average Order Value (AOV)

-- 11 daily trend
WITH daily_rev AS (
  SELECT 
    transaction_date,
    SUM(transaction_qty * unit_price) AS daily_revenue
  FROM transactions
  GROUP BY transaction_date
)
SELECT 
  transaction_date,
  daily_revenue,
  LAG(daily_revenue) OVER (ORDER BY transaction_date) AS prev_day_revenue,
  CASE 
    WHEN daily_revenue < LAG(daily_revenue) OVER (ORDER BY transaction_date)
    THEN 'TURUN'
    ELSE 'NAIK / SAMA'
  END AS trend
FROM daily_rev;


-- "Analisis Perubahan Revenue Bulanan per Interval Jam"
with monthly_revenue_by_hour as
(
select
	month(transaction_date) as calendar_month,
    case
		when hour(transaction_time) between 7 and 10 then '07:00 - 10:00'
        when hour(transaction_time) between 11 and 14 then '11:00 - 14:00'
        when hour(transaction_time) between 15 and 17 then '15:00 - 17:00'
        when hour(transaction_time) between 18 and 21 then '18:00 - 21:00'
        else 'lainnya'
	end as interval_jam,
	sum(transaction_qty * unit_price) as revenue
from
	transactions
group by
	month(transaction_date),
    interval_jam
)
select
	calendar_month,
    interval_jam,
    revenue,
    lag(revenue) over(partition by interval_jam order by calendar_month) as prev_revenue,
    case
		when revenue > lag(revenue) over(partition by interval_jam order by calendar_month)
        then 'Naik'
        else 'Turun'
	end as keterangan
from
	monthly_revenue_by_hour;


-- Monthly growth revenue
with monthly_growth_revenue as
(
select
	month(transaction_date) as calendar_month,
    sum(transaction_qty * unit_price) as revenue
from
	transactions
group by
	calendar_month
)
select
	calendar_month,
    revenue,
    lag(revenue) over(order by calendar_month) as prev_revenue,
    round((revenue - LAG(REVENUE) over(order by calendar_month)) * 100.0 / 
    LAG(REVENUE) over(order by calendar_month), 2) as growth
from
	monthly_growth_revenue;
    
select
	*
from
	transactions;
    
    
select
	sum(transaction_qty * unit_price) as revenue
from
	transactions;
    
    
with monthly_revenue as
(
select
	month(transaction_date) as calendar_month,
    sum(transaction_qty * unit_price) as revenue
from
	transactions
group by
	calendar_month
)
select
	sum(revenue)
from
	monthly_revenue;
-- 9. Jam sibuk
SELECT 
    CASE
        WHEN HOUR(transaction_time) BETWEEN 7 AND 10 THEN '07:00 - 10:00'
        WHEN HOUR(transaction_time) BETWEEN 11 AND 14 THEN '11:00 - 14:00'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN '15:00 - 17:00'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 21 THEN '18:00 - 21:00'
        ELSE 'Lainnya'
    END AS interval_jam,
    SUM(transaction_qty * unit_price) AS revenue,
    COUNT(*) AS total_transaksi
FROM
    transactions
GROUP BY interval_jam;

use coffeeshop;
select * from transactions; 

