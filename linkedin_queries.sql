create database LinkedinDB;

use LinkedinDB;

CREATE TABLE STORES (Store varchar(10),Quarter varchar(10),Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ("S1", "Q5",200);
select * from Stores;

# Write a SQL query to find the missing quarter for each store

with str as (
select store, quarter, amount, 10-sum(right(quarter, 1)) over(partition by store) as miss_no from stores)
select store, concat('Q',miss_no) as miss_qur from str
group by store, miss_qur;


select store, quarter, 15-sum(right(quarter, 1)) over(partition by store) as miss_no from stores;


## Business Usecase

create table tickets
(ticket_id varchar(10),
create_date date,
resolved_date date);


insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');

create table holidays
(holiday_date date
,reason varchar(100));

insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');



select * from tickets;
select * from holidays;
show tables;

select*,
datediff(create_date, resolved_date) as actual_days,
datediff(create_date, resolved_date) -2 * datediff(create_date, resolved_date) - no_of_holidays as business_days
from
(select t.ticket_id, t.create_date, t.resolved_date, count(h.holiday_date) as no_of_holidays 
from tickets t 
left join 
holidays h 
on h.holiday_date between t.create_date and t.resolved_date 
group by t.ticket_id, t.create_date, t.resolved_date) A; 




# Tredence Analytics interview question
/* Several friends at a cinema ticket office would like to reserve consecutive available seats,
Can you help to query all the consecutive available seats order by the seat_id using cinema table*/
create table cinema(seat_id int not null auto_increment primary key, free bool);
desc cinema;
#drop table cinema;
show tables;
insert into cinema (free) values (1);
insert into cinema (free) values (0);
insert into cinema (free) values (1);

select * from cinema;

#alter table cinema modify seat_id int not null auto_increment;
#delete from cinema where seat_id = 1;

select row_number() over(partition by free) cos from cinema;

with cte as (
select *, 
lag(seat_id) over(order by seat_id) as lag_seat_id,
lag(free) over(order by seat_id) as lag_free from cinema)
select seat_id from cte
where free = 1 and lag_free = 1
union
select lag_seat_id from cte
where free = 1 and lag_free = 1;


SELECT t1.seat_id + 1 AS start_gap, t2.seat_id - 1 AS end_gap
FROM cinema t1
LEFT JOIN cinema t2 ON t1.seat_id = t2.seat_id - 1
WHERE t2.seat_id IS NULL
ORDER BY t1.seat_id;


show tables;

select * from employee;
select * from performance;
select * from new_table;

# 1. Total Records After Joining Two Tables on All Types of Joins
select * from employee e inner join performance p on e.Emp_id = p.Emp_id;
select * from employee e left join performance p on e.Emp_id = p.Emp_id; 
select * from employee e right join performance p on e.Emp_id = p.Emp_id;
select * from employee e join performance p on e.Emp_id = p.Emp_id;

## 2. Rolling Sum and Nth Salary Based Questions

create table date_table (Emp_id int not null primary key auto_increment, date datetime);
show tables;
desc date_table;

select * from date_table;

insert into date_table(date) values("2019-02-02 09:00:00");
insert into date_table(date) values("2019-06-01 09:30:00");
insert into date_table(date) values("2019-06-08 09:07:00");
insert into date_table(date) values("2019-08-09 09:00:00");
insert into date_table(date) values("2019-08-12 09:00:00");
insert into date_table(date) values("2019-08-16 09:00:00");
insert into date_table(date) values("2019-08-22 09:00:00");
insert into date_table(date) values("2019-08-29 09:00:00");
insert into date_table(date) values("2019-09-02 09:00:00");
insert into date_table(date) values("2019-09-12 09:00:00");
insert into date_table(date) values("2019-09-25 09:00:00");
insert into date_table(date) values("2019-10-02 09:00:00");
insert into date_table(date) values("2019-10-14 09:00:00");
insert into date_table(date) values("2019-11-04 09:00:00");
insert into date_table(date) values("2019-11-12 09:00:00");
insert into date_table(date) values("2019-12-04 09:00:00");
insert into date_table(date) values("2019-12-05 09:00:00");
insert into date_table(date) values("2019-12-06 09:00:00");
insert into date_table(date) values("2020-01-02 09:00:00");
insert into date_table(date) values("2020-02-02 09:00:00");
insert into date_table(date) values("2020-02-03 09:00:00");

select * from date_table;


create table employee_date_table 
(select n.*, d.date
from new_table n 
join 
date_table d 
on 
n.Emp_id = d.Emp_id);

show tables;

select * from employee_date_table;

## Rolling Sum
select Emp_id, date, salary, sum(salary) over (order by date rows between 2 preceding and current row) rolling_sum 
from employee_date_table;


## Nth Highest Salary:
select max(salary) from employee_date_table;

select salary 
from employee_date_table e1
where 7 = (select count(distinct salary)
from employee_date_table e2 where e2.Salary > e1.salary);

## Removing Duplicates
select min(Dept) from employee_date_table group by Dept;
select * from employee_date_table where Dept in (select min(Dept) from employee_date_table group by Dept);

select ceil(avg(salary)-avg(replace(salary, "0", ""))) from employee_date_table;

select abs(min(salary) - max(salary)) + abs(min(age)-max(age)) from employee_date_table;




## two tables like Cricket Players and Formats of cricket
create table players(P_ID int not null, Names varchar(25), FormatId int);


insert into players (P_ID, Names, FormatId) values (1, "Rohit Sharma", 100);
insert into players (P_ID, Names, FormatId) values (2, "Virat Kohli", 100);
insert into players (P_ID, Names, FormatId) values (3, "Hardik Pandya", 101);
insert into players (P_ID, Names, FormatId) values (4, "Ravi Ashwin", 101);
insert into players (P_ID, Names, FormatId) values (5, "Umesh Yadav", 101);
insert into players (P_ID, Names, FormatId) values (6, "J Bumrah", 101);
insert into players (P_ID, Names, FormatId) values (7, "Subhan Gill", 100);
insert into players (P_ID, Names, FormatId) values (1, "Rohit Sharma", 101);
insert into players (P_ID, Names, FormatId) values (2, "Virat Kohli", 101);
insert into players (P_ID, Names, FormatId) values (8, "Ravindra Jadeja", 100);
insert into players (P_ID, Names, FormatId) values (6, "J Bumrah", 100);
insert into players (P_ID, Names, FormatId) values (3, "Hardik Pandya", 102);
insert into players (P_ID, Names, FormatId) values (6, "Rinku Singh", 102);
insert into players (P_ID, Names, FormatId) values (3, "Rohit Sharma", 100);
insert into players (P_ID, Names, FormatId) values (9, "Hardik Pandya", 102);
insert into players (P_ID, Names, FormatId) values (4, "Rinku Singh", 102);

select * from players;

create table formats(FormatId int, Format varchar(10));
alter table formats rename column Format to  Formats;

insert into formats values (100, "TestMatch"),(101, "OneDay"), (102, "T20");
select * from formats;

select p.Names 
from players p 
join 
formats f on p.FormatId = f.FormatId
group by p.Names 
having count(distinct p.formatId) = (select count(formatId) from formats);

## ind out the Total number of orders for the same combination of SKUs each day

create table Ordertable(OrderId int, OrderDate date, UserId int, SKU1 varchar(10), SKU2 varchar(10), SKU3 varchar(10));

insert into Ordertable values (1, "2024-07-01", 101, 'A123', 'B456', 'C789'), (2, "2024-07-01", 102, 'B456', 'C789', 'A123'), (3, "2024-07-01", 102, 'G678', 'H123', 'I456'),
								(4, "2024-07-01", 103, 'I456', 'G678', 'H123'), (5, "2024-07-01", 104, 'H123', 'G678', 'I456'), (6, "2024-07-02", 105, 'C789', 'A123', 'B456'),
                                (7, "2024-07-02", 106, 'B456', 'A123', 'C789'), (8, "2024-07-03", 107, 'A123', 'C789', 'B456'), (9, "2024-07-04", 101, 'D123', 'E456', 'F789');

select * from ordertable;

# Create CTE (Common Table Expression)

with unpivots as
(select orderid, orderdate, userid, sku 
from (select orderid, orderdate, userid, sku1, sku2, sku3 
from ordertable) as sourcetable
unpivot
(sku for skutype in (sku1, sku2, sku3)) as unpivottable),
combined_sku as
(select orderid, orderdate, userid, string_agg(sku, ',') within group (order by sku) as skus
from unpivots
group by orderid, orderdate, userid)

select orderdate, skus, count(orderid) as totalorders
from combined_sku
group by orderdate, skus
order by 1,2;








