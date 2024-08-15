show databases;

create database newdb;


use newdb;

create table first_table (id int, f_name varchar(25), l_name varchar(25), dob date);

insert into first_table values (1, "Naresh", "Kumar", "1994-03-12");
insert into first_table values (2, "Narendra", "Kumar", "2000-05-04");
insert into first_table values (3, "Sulochana", "Baby", "1999-12-02");
insert into first_table values (4, "Narasimhulu","Raju", "1981-01-01");
insert into first_table values (5, "Venkata","Subbamma", "1985-01-19");

select * from first_table;

create table new_table select id, f_name, l_name, year(dob) as year_of_dob, month(dob) as month_of_dob, day(dob) as day_of_dob from first_table;
select * from new_table;
create table dob_table select *, date(concat(year_of_dob,"-",month_of_dob,"-",day_of_dob)) as new_dob from new_table;

insert into first_table values (2, "Narendra", "Kumar", "2000-05-04");
insert into first_table values (3, "Sulochana", "Baby", "1999-12-02");
insert into first_table values (4, "Narasimhulu","Raju", "1981-01-01");
insert into first_table values (5, "Venkata","Subbamma", "1985-01-19");

select * from first_table;

select *, concat(f_name, " ", l_name) as full_name from first_table;

create table first_salary (id int not null, salary decimal);

create view first_view as (select ft.id, ft.f_name, ft.l_name, ft.dob, fs.salary from first_table ft left join first_salary fs on ft.id = fs.id); 

select * from first_view;

select * from first_salary;
alter table first_salary modify column id int primary key auto_increment not null;

desc first_salary;

insert into first_salary (salary) values (30000);
select * from first_salary;

select distinct(fs.salary) from first_table as ft right join first_salary as fs on ft.id = fs.id order by fs.salary asc limit 4;

select max(salary) from first_salary where salary not in (
select max(salary) from first_salary where salary not in (
select max(salary) from first_salary));

select * from first_salary where salary > 40000 order by salary desc;

select distinct(salary) from first_salary order by salary desc limit 1, 1;

select top 1 salary from first_salary from (select top 3 salary from first_salary order by salary desc) as camp order by salary asc;

select max(salary) from first_salary where salary < (select max(salary) from first_salary where salary not in (select max(salary) from first_salary));





