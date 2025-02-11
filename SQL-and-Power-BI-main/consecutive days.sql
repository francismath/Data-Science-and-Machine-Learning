create table stock (
supplier_id int,
product_id int,
stock_quantity int,
record_date date
);
insert into stock (supplier_id,product_id,stock_quantity,record_date)
values
 (1, 1, 60, '2022-01-01'),
 (1, 1, 40, '2022-01-02'),
 (1, 1, 35, '2022-01-03'),
 (1, 1, 45, '2022-01-04'),
 (1, 1, 51, '2022-01-06'),
 (1, 1, 55, '2022-01-09'),
 (1, 1, 25, '2022-01-10'),
 (1, 1, 48, '2022-01-11'),
 (1, 1, 45, '2022-01-15'),
 (1, 1, 38, '2022-01-16'),
 (1, 2, 45, '2022-01-08'),
 (1, 2, 40, '2022-01-09'),
 (2, 1, 45, '2022-01-06'),
 (2, 1, 55, '2022-01-07'),
 (2, 2, 45, '2022-01-08'),
 (2, 2, 48, '2022-01-09'),
 (2, 2, 35, '2022-01-10'),
 (2, 2, 52, '2022-01-15'),
 (2, 2, 23, '2022-01-16');

 select * from stock
 select supplier_id, product_id, max(stock_quantity)as ma_below50,record_date
 from stock
 where stock_quantity < 50
 group by supplier_id,product_id,record_date
 /*group by supplier_id*/

 with cte as (
	 select 
		supplier_id, 
		product_id, 
		stock_quantity, 
		record_date,
		/*add a column prev_stock_quantity that 
		holds the previous stock_quantity value 
		for each supplier_id and product_id 
		combination using the LAG window function.*/
		lag(record_date) over (
			partition by supplier_id,product_id 
			order by record_date
		) as pre_date
	 from stock
	 where stock_quantity < 50
 )

consecutive_days as (
	select 
		supplier_id,
		product_id,
		stock_quantity,
		record_dates,
		lead(record_date) over (
		partition by supplier_id,product_id
		order by record_date
		) as next_date
	from cte
	where next_date is not null
)
SELECT 
		supplier_id,
		product_id,
		STRING_AGG(record_date::text, ', ') as consecutive dates
FROM consecutive_days
group by supplier_id, product_id
ORDER BY supplier_id, product_id;




/*cte practice*/
drop table revenue

create table revenue (
Organization char(50),
Year smallint,
Revenue int
)

insert into revenue (Organization, Year, Revenue)
values
('ABCD News',	2013, 440000),
('ABCD News',	2014, 480000),
('ABCD News',	2015, 490000),
('ABCD News',	2016, 500000),
('ABCD News',	2017, 520000),
('ABCD News',	2018, 525000),
('ABCD News',	2019, 540000),
('ABCD News',	2020, 550000)

insert into revenue (Organization, Year, Revenue)
values
('Z News',	2016, 720000),
('Z News',	2017, 750000),
('Z News',	2018, 780000),
('Z News',	2019, 880000),
('Z News',	2020, 910000)
select * from revenue

with cte as (
	select
		Organization, Year, Revenue,
		LAG(revenue) over (partition by organization
		order by year
		) as PreRevenue
		--revenue-PreRevenue as yearonyeargrowth
	from revenue
	)

select cte.*, cte.revenue-cte.PreRevenue as yearonyeargrowth
from cte


WITH cte AS (
    SELECT
        supplier_id,
        product_id,
        stock_quantity,
        record_date,
        LAG(record_date, 1) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS prev_date
    FROM
        stock
    WHERE
        stock_quantity < 50
),
consecutive_dates AS (
    SELECT
        supplier_id,
        product_id,
        record_date,
        LEAD(record_date, 1) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS next_date
    FROM
        cte
    WHERE
        DATEDIFF(LEAD(record_date, 1) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date), record_date) = 1
)
SELECT
    supplier_id,
    product_id,
    STRING_AGG(record_date::TEXT, ', ') AS consecutive_dates
FROM
    consecutive_dates
GROUP BY
    supplier_id,
    product_id
ORDER BY
    supplier_id,
    product_id;
