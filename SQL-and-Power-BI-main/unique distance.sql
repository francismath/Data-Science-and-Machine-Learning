/*A SQL problem asked in the ITC Infotech interview.
Given a table of distances between cities, you need to remove duplicates in case the distance is also the same.
also when you remove duplicates keep the first one in output. 
The topic originated from a LinkedIn post by Ankit Bansal.*/

drop table if exists distance;
drop table if exists city_distance;
create table city_distance (
distance int,
source varchar(512),
des varchar(512)
);
insert into city_distance (distance,source,des)
values 
('100', 'New Delhi', 'Panipat'),
('200', 'Ambala', 'New Delhi'),
('150', 'Bangalore', 'Mysore'),
('150', 'Mysore', 'Bangalore'),
('250', 'Mumbai', 'Pune'),
('250', 'Pune', 'Mumbai'),
('2500', 'Chennai', 'Bhopal'),
('2500', 'Bhopal', 'Chennai'),
('60', 'Tirupati', 'Tirumala'),
('80', 'Tirumala', 'Tirupati');

/*
select source, des, distance
from city_distance
*/

select source, des, distance
from (
	select *,
		row_number() over 
		(partition by distance
		order by distance
		) as rn
	from city_distance
) subquery
where rn = 1

-- Alternative method
with cte as (
	select *, ROW_NUMBER() over 
		(partition by distance order by distance) as rn
	from city_distance
)
select source, des, distance
from cte
where rn = 1

-- To check if distances have been assigned row number within the same values 
with cte as (
	select *, ROW_NUMBER() over 
		(partition by distance order by distance) as rn
	from city_distance
)
select source, des, distance, rn
from cte