-- CREATING CUSTOM WAREHOUSE
CREATE WAREHOUSE SAHIL_DEMO_WAREHOUSE WITH WAREHOUSE_SIZE = 'MEDIUM' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;

-- CREATING DATABASE
CREATE OR REPLACE DATABASE INEURON_SQL_PROJECT_1;

USE INEURON_SQL_PROJECT_1;

/***************************************************  Task 1 **************************************************************/

-- creating shopping_history table according given instruction
create or replace table shopping_history (
product varchar not null,
quantity integer not null,
unit_price integer not null
);

-- inserting records into table shopping_history
insert into shopping_history(product, quantity, unit_price) values
('milk',3,10),
('bread',7,3),
('bread',5,2),
('cheese',6,12),
('butter',5,15),
('butter',4,13),
('cookie',6,3),
('cookie',3,5),
('cookie',6,7),
('cupcake',8,2);

-- retreiving all records from shopping_history
select * from shopping_history;

-- calculate the total price of each product in descending alphabetical order by product
select product, sum(quantity * unit_price) as total_price
from shopping_history group by(product) order by product desc;

/***************************************************  Task 2 **************************************************************/

-- creating table phones
create table phones(
name varchar(20) not null unique,
phone_number integer not null unique
);

-- creating table calls
create table calls(
id integer not null,
caller integer not null,
callee integer not null,
duration integer not null,
unique(id)
);


-- inserting records into phones table
insert into phones(name,phone_number) values
('Jack',1234),
('Leena',3333),
('Mark',9999),
('Anna',7582),
('John',6356),
('Addison',4315),
('Kate',8003),
('Ginny',9831),
('Bruce',8724),
('Natasha',7631);

-- inserting records into calls table
insert into calls(id,caller,callee,duration) values
(25,1234,7582,8),
(7,9999,7582,1),
(18,9999,3333,4),
(2,7582,3333,3),
(3,3333,1234,1),
(21,3333,1234,1),
(65,8003,9831,7),
(100,9831,8003,3),
(145,4315,9831,18),
(172,8724,7631,10);

-- retreiving all records from phones
select * from phones;

-- retreiving all records from calls
select * from calls;

-- finds all clients who talked for at least 10 minutes in total
select name from(
select name,duration from
phones inner join calls on phones.phone_number = calls.caller 
union all
select name,duration from
phones inner join calls on phones.phone_number = calls.callee) 
group by name
having sum(duration) >= 10
order by name;

/***************************************************  Task 3 **************************************************************/

-- creating table transactions
create table transactions(
amount integer not null,
date date not null
);

-- inserting records into transactions table
insert into transactions(amount,date) values 
(1000,'2020-01-06'),
(-10,'2020-01-14'),
(-75,'2020-01-20'),
(-5,'2020-01-25'),
(-4,'2020-01-29'),
(2000, '2020-03-10'),
(-75,'2020-03-12'),
(-20,'2020-03-15'),
(40,'2020-03-15'),
(-50,'2020-03-17'),
(200,'2020-10-10'),
(-200,'2020-10-10');

-- retreiving all records from transactions
select * from transactions;

-- get balance at end of year according given condition
select sum(case when crd_pmnt_cnt >=3 and total_crd_pmnt <= -100 then mnth_amount+5 else mnth_amount end)-60 as balance
from(
select
count(case when amount < 0 then amount end) as crd_pmnt_cnt,
sum(case when amount < 0 then amount else 0 end) as total_crd_pmnt,
sum(amount) as mnth_amount
from transactions
group by month(date)
);

