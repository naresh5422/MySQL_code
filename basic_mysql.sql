CREATE TABLE your_table (your_column integer);

INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (4);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (10);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (NULL);
INSERT INTO your_table VALUES (3);


select * from your_table;



with cte_row as (select your_column, row_number() over(order by (select null)) rw from your_table),
cte_grp as (select your_column, rw, count(your_column) over (order by rw desc) grp from cte_row)
select sum(your_column) over(partition by grp) from cte_grp order by rw;


