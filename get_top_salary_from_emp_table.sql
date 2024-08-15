show tables;
create table employee (Emp_id int(5) not null primary key auto_increment, Emp_Name varchar(32), Age int(3), Exp int(3), Salary bigint(6));
drop table employee;
desc employee;

insert into employee (Emp_Name, Age, Exp, Salary) values("Naresh", 30, 2, 40000),("Kumar", 28, 4, 50000),("Tata", 15, 6, 100000),
															("Sulochana", 23, 5, 60000), ("Hikshith", 13, 4, 90000);
select * from employee;

select count(*) from employee;

select * from
(select *,
dense_rank() over(order by Salary desc) as sal_rank 
from employee) as sal_table where sal_rank=4;

select * from (select *, 
rank() over(order by Salary desc) as sal_rank 
from employee) as sal_tbl where sal_rank=7;
	

alter table employee
add column  Dept varchar(25) after Age;

desc employee;

select * from employee;

update employee set Dept = "CSE" where Emp_id = 17;
update employee set Dept = "CSE" where Emp_id = 2;
update employee set Dept = "CSE" where Emp_id = 8;
update employee set Dept = "CSE" where Emp_id = 3;
update employee set Dept = "CSE" where Emp_id = 7;
update employee set Dept = "CSE" where Emp_id = 4;
update employee set Dept = "ECE" where Emp_id = 5;
update employee set Dept = "ECE" where Emp_id = 11;
update employee set Dept = "EEE" where Emp_id = 6;
update employee set Dept = "Mech" where Emp_id = 10;
update employee set Dept = "EEE" where Emp_id = 14;
update employee set Dept = "Civil" where Emp_id = 20;

update employee set Salary=10000 where Emp_id = 15;
select * from employee; 

select * from (select *, dense_rank() over(partition by Dept order by Salary desc) as sal_ranking from employee) as ranking where sal_ranking = 3;

select * from employee order by Salary desc limit 2;

select * from employee where Salary >= (select distinct(Salary) from employee order by Salary desc);
select distinct(Salary) from employee order by Salary desc limit 2;

select distinct(Salary) 
from employee e
where 4>=(select count(distinct Salary) 
from employee e1
where e1.Salary >= e.Salary)
order by e.Salary Desc;

select distinct(Salary) 
from employee e
where 4>=(select count(distinct Salary) 
from employee e1
where e1.Salary <= e.Salary)
order by e.Salary Desc;


select * from employee;


update employee set Dept = "Mech" where Emp_id = 21;

#drop table performance;
create table performance(Emp_id int not null primary key auto_increment, Grade varchar(2), Sal_Hike varchar(10));
show tables;
desc performance;

select * from performance;

insert into performance(Grade, Sal_Hike) values("B", "85%");

select count(Emp_id) from employee;
select count(Emp_id) from performance;


delete from performance where Emp_id = 21;


create table new_table select  e.Emp_id, e.Emp_Name, e.Age, e.Dept, e.Exp, e.Salary, p.Grade, p.Sal_Hike from employee e join performance p on e.Emp_id = p.Emp_id;
select * from new_table;

select Emp_Name, Age, Dept, Exp, salary, 
Rank() over (partition by Dept order by Salary desc) as sal_rank, 
Dense_Rank() over (partition by Dept order by Salary desc) as sal__dense_rank,
Row_number() over (partition by Dept order by Salary desc) as sal_row_num
from new_table;

select Dept, salary, dense_rank() over(partition by Dept order by Salary Desc) de_rnk from new_table;
select Dept, max(Salary) from new_table group by Dept;

with CTE as(
select Emp_Name, Age, Dept, Exp, Salary, dense_rank() over (order by Salary Desc) dns_rnk
from new_table)

select Emp_Name, Dept, Salary, dns_rnk from CTE where dns_rnk <= 5;

select Emp_Name, Age, Dept, Salary from new_table order by salary desc limit 5;

select Emp_Name, Age, Dept, Salary from new_table where salary < (select avg(salary) from new_table) order by Salary desc;