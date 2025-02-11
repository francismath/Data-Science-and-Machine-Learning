create table delivery (
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date
)

insert into delivery values
(1, 1, '2019-08-01','2019-08-02'),
(2, 2, '2019-08-02','2019-08-02'),
(3, 1, '2019-08-11','2019-08-12'),
(4, 3, '2019-08-24','2019-08-24'),
(5, 3, '2019-08-21','2019-08-22'),
(6, 2, '2019-08-11','2019-08-13'),
(7, 4, '2019-08-09','2019-08-09')

with cte1 as (
select 
	customer_id, 
	min(order_date) as first_order
from delivery
group by customer_id
),

cte2 as(
select 
	d1.customer_id, 
case 
	when cte1.first_order=d1.customer_pref_delivery_date then 'immediate'
	else 'scheduled'
end as time_urgency
from delivery d1
join cte1
on d1.customer_id=cte1.customer_id
where d1.order_date=cte1.first_order)

select 
	(100.0*count(
		case when time_urgency='immediate' then 1 end
		)
	)/count(*) as immediate_percentage
from cte2

select round(100.0*sum(
				case when order_date=customer_pref_delivery_date
					 then 1
					 else 0
				end
				)/count(*),2) 
	   as immediate_percentage
from delivery
where order_date in (
select min(order_date)
from delivery
group by customer_id
)

drop table if exists activity
create table activity (
player_id int, 
device_id int,
event_date date,
games_played int
primary key (player_id, event_date)
);

insert into activity values
(1, 2, '2016-03-01',5),
(1, 2, '2016-03-02',6),
(2, 3, '2017-06-25',1),
(3, 1, '2016-03-02',0),
(3, 4, '2018-07-03',5)


select * from activity

with a0 as (
	select 
		player_id, 
		min(event_date) as min_date
	from activity
	group by player_id
),
a1 as(
	select 
		player_id, 
		event_date,
		lead(event_date) over (partition by player_id order by event_date)
		as pre_date
	from activity
),
a2 as (
select player_id, 
	event_date,
	case when datediff(day, event_date, pre_date)=1 then 1
	else 0 
	end as is_next_day
from a1
)

select 
	round(
			sum(
				case when a2.is_next_day=1 then 1 else 0 end
				)*1.0/count(*),2) as fraction
from a2
join a0 on a0.player_id=a2.player_id
where a2.event_date=a0.min_date




select player_id, sum(is_next_day) as num
from a2
group by player_id

a3 as (
select player_id, sum(is_next_day) as num
from a2
group by player_id
)



select round(sum(case when num=1 then 1 else 0 end)*1.0/count(*),2) as fraction
from a3

CREATE TABLE Teacher (
    teacher_id INT NOT NULL,
    subject_id INT NOT NULL,
    dept_id INT NOT NULL,
    PRIMARY KEY (subject_id, dept_id) -- Composite key to enforce the relationships shown in your data
);

-- Insert the data you provided
INSERT INTO Teacher (teacher_id, subject_id, dept_id) VALUES
(1, 2, 3),
(1, 2, 4),
(1, 3, 3),
(2, 1, 1),
(2, 2, 1),
(2, 3, 1),
(2, 4, 1);

select teacher_id, count(distinct subject_id) as cnt
from Teacher
group by teacher_id

drop table if exists activity
CREATE TABLE Activity (
    user_id INT NOT NULL,
    session_id INT NOT NULL,
    activity_date DATE NOT NULL,
    activity_type VARCHAR(255) NOT NULL,  -- Or a more appropriate length
    
);

-- Insert the data you provided
INSERT INTO Activity VALUES
(1, 1, '2019-07-20', 'open_session'),
(1, 1, '2019-07-20', 'scroll_down'),
(1, 1, '2019-07-20', 'end_session'),
(2, 4, '2019-07-20', 'open_session'),
(2, 4, '2019-07-21', 'send_message'),
(2, 4, '2019-07-21', 'end_session'),
(3, 2, '2019-07-21', 'open_session'),
(3, 2, '2019-07-21', 'send_message'),
(3, 2, '2019-07-21', 'end_session'),
(4, 3, '2019-06-25', 'open_session'),
(4, 3, '2019-06-25', 'end_session');

select activity_date, count(distinct user_id) as active_users
from Activity
where activity_type is not null and 
activity_date between '2019-06-28' and '2019-07-27'
group by activity_date

select activity_date, count(distinct user_id) as active_users
from Activity
where activity_type is not null and 
datediff(day, activity_date, '2019-07-27')<=30 and datediff(day, activity_date, '2019-07-27')>0
group by activity_date

-- Create the Product table
drop table if exists product
CREATE TABLE Product (
    product_id INT NOT NULL PRIMARY KEY,  -- Primary key constraint
    product_name VARCHAR(255) NOT NULL -- Product name, adjust length as needed
);

-- Create the Sales table
drop table if exists sales
CREATE TABLE Sales (
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    year INT NOT NULL,
    quantity INT NOT NULL,
    price int NOT NULL, -- Use DECIMAL for currency to avoid floating-point issues
    PRIMARY KEY (sale_id, year),         -- Composite primary key
);

-- Insert data into the Product table
INSERT INTO Product VALUES
(100, 'Nokia'),
(200, 'Apple'),
(300, 'Samsung');

-- Insert data into the Sales table
INSERT INTO Sales VALUES
(1, 100, 2008, 10, 5000),
(2, 100, 2009, 12, 5000),
(7, 200, 2011, 15, 9000);

select 
	product_id,
	year as first_year,
	s.quantity,
	s.price
from sales s
where year in (
	select min(year)
	from sales s2
	where s2.product_id = s.product_id
)

drop table if exists employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,  -- Primary key constraint ensures uniqueness
    name VARCHAR(255) NOT NULL,   -- Name cannot be null
    reports_to INT NULL,         -- Can be null (for top-level employees)
    age INT NULL,                -- Age can be null
);
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES
(9, 'Hercy', NULL, 43),
(6, 'Alice', 9, 41),
(4, 'Bob', 9, 36),
(2, 'Winston', NULL, 37);
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES
(80, 'Yehudit', 43, 37),
(55, 'Golda', 72, 52),
(7, 'Yehudit', 66, 40),
(81, 'Sarah', 80, 30),
(96, 'Azriel', 12, 50),
(47, 'Aharon', NULL, 38);

-- Insert the data you provided
INSERT INTO Employees (employee_id, name, reports_to, age) VALUES
(5, 'Levi', 74, 41),
(100, 'Michael', NULL, 30),
(25, 'Menachem', 64, 47),
(79, 'Eliyahu', 59, 39),
(9, 'David', 66, 39),
(80, 'Yehudit', 43, 37),
(55, 'Golda', 72, 52),
(7, 'Yehudit', 66, 40),
(81, 'Sarah', 80, 30),
(96, 'Azriel', 12, 50),
(47, 'Aharon', NULL, 38),
(72, 'Zahava', 40, 33),
(23, 'Azriel', 79, 32),
(43, 'Miriam', 16, 43),
(38, 'Azriel', 36, 34),
(76, 'Moshe', 42, 41),
(33, 'Sarah', 7, 28),
(93, 'Yehudah', 14, 36),
(62, 'Adam', 59, 30),
(45, 'Refael', 12, 35),
(14, 'Eliyahu', NULL, 30),
(50, 'Sarah', 43, 36),
(98, 'Yaakov', 19, 33),
(46, 'Azriel', 6, 27),
(42, 'Golda', 93, 52),
(32, 'Adam', 40, 38),
(34, 'Benjamin', 68, 40),
(10, 'Rachel', NULL, 36),
(40, 'Levi', 93, 47),
(87, 'Sarah', 74, 35),
(12, 'Freida', NULL, 32),
(11, 'Ezra', 32, 28),
(19, 'Miriam', 40, 25),
(74, 'Tamar', 42, 46),
(20, 'Yehudah', 50, 47),
(64, 'Moshe', 25, 45),
(29, 'Ezra', 32, 24),
(44, 'Eliyahu', 23, 60),
(66, 'Yehudah', 7, 55),
(36, 'Yosef', 67, 28),
(8, 'Aharon', NULL, 26),
(52, 'Yosef', 81, 57),
(61, 'Eliyahu', NULL, 23),
(30, 'Tamar', 25, 48),
(6, 'Gelleh', 67, 51),
(37, 'Naftali', NULL, 37),
(39, 'Azriel', 80, 60),
(48, 'Azriel', 62, 31),
(68, 'Golda', 55, 48),
(67, 'Ezra', NULL, 60),
(22, 'Sarah', 72, 33),
(16, 'Rachel', 9, 49),
(59, 'Ezra', 12, 48);

select 
	e.employee_id, e.name,
	count(e.employee_id),
	round(avg(cast (r.age as float)),0) as average_age 
from employees e
join employees r
on e.employee_id = r.reports_to
group by e.employee_id,e.name
--group by e.employee_id, r.reports_to

	e.employee_id,
	e.name,
	count()


with a1 as (
	select 
		reports_to,
		cast (age as float) as age,
		name
	from Employees
	where reports_to is not null
),

a2 as  (
	select 
		reports_to,
		count(name) as reports_count,
		round(avg(age),0) as average_age
	from a1
	group by reports_to
)

select 
	a2.reports_to as employee_id,
	a.name,
	a2.reports_count,
	a2.average_age
from a2
join employees a on 
a.employee_id = a2.reports_to

drop table if exists Employee
CREATE TABLE Employee (
    employee_id INT,
    department_id INT,
    primary_flag CHAR(1),
	primary key (employee_id, department_id) );

INSERT INTO Employee VALUES
(1, 1, 'N'),
(2, 1, 'Y'),
(2, 2, 'N'),
(3, 3, 'N'),
(4, 2, 'N'),
(4, 3, 'Y'),
(4, 4, 'N');

select  * from Employee

with cte as (
select 
	employee_id,
	count(department_id) as cnt_dep
from Employee
group by employee_id
)

select 	
	e.employee_id,
	e.department_id
from Employee as e
join cte on cte.employee_id = e.employee_id
where cte.cnt_dep = 1 or (cte.cnt_dep > 1 
	and e.primary_flag = 'Y')

select 	
	employee_id,
	department_id
from Employee
where primary_flag = 'Y' or 
	employee_id in (
		select employee_id
		from Employee
		group by employee_id
		having count(employee_id)=1) 

CREATE TABLE Triangle (
    x INT,
    y INT,
    z INT,
    PRIMARY KEY (x, y, z)
);

INSERT INTO Triangle (x, y, z) VALUES
(13, 15, 30),
(10, 20, 15);
select x, y, z, 
	case when x+y>z and x+z>y and y+z>x then 'Yes'
	else 'No'
	end as triangle
from Triangle

CREATE TABLE Logs (
    id INT,
    num INT
);

INSERT INTO Logs (id, num) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

with cte as (
select id,num, 
lead(num) over (order by id) 
as ld_num
from logs
)
select num as ConsecutiveNums
from cte
where num=ld_num
group by num
having count(num)>1

with cte2 as (
select id,num, 
lead(num) over (order by id) 
as next_num,
lag(num) over (order by id) 
as pre_num
from logs
)
select distinct num as ConsecutiveNums
from cte2
where num=next_num and num=pre_num



drop table if exists sales
CREATE TABLE Sales (
    Company VARCHAR(255),
    Year INT,
    Amount INT
);

INSERT INTO Sales VALUES
('ABC Ltd.', 2015, 5000),
('XYZ Ltd.', 2015, 4600),
('ABC Ltd.', 2017, 5500),
('ABC Ltd.', 2016, 5400),
('XYZ Ltd.', 2016, 6500),
('ABC Ltd.', 2018, 5400),
('XYZ Ltd.', 2017, 4700),
('XYZ Ltd.', 2018, 5400);

select Company, Year, Amount,
lead(year) over (partition by company order by year)
from sales