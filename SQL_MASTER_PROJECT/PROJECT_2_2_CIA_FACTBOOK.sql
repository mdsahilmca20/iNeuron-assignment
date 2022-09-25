/*CREATING DATABASE*/
CREATE DATABASE CIA_FACTBOOK;

USE CIA_FACTBOOK;


/*****************************************************************************************************/
/***************************************** CREATING TABLES *******************************************/
/*****************************************************************************************************/

CREATE TABLE FACT(
country VARCHAR(100) NOT NULL, area BIGINT, birth_rate FLOAT, death_rate FLOAT, infant_mortality_rate FLOAT,
internet_users BIGINT, life_exp_at_birth FLOAT, maternal_mortality_rate FLOAT, net_migration_rate FLOAT,
population BIGINT, population_growth_rate FLOAT);



/***************************************************************************************************/
/*************************************** LOAD DATA INTO TABLE *************************************/
/***************************************************************************************************/

/*In the given dataset, values are given as "NA" in many of the places. As "NA" is not valid for a number 
attribute, I put NULL where the value was "NA" during the loading of the file.*/


LOAD DATA INFILE 'D:/technical skill studies/data analysis/assignment/INEURON/FSDA assignment/assignment-2/task-2/cia_factbook.csv'
INTO TABLE FACT
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11)
SET country = @col1,
	area = if(@col2='NA',NULL,@col2),
	birth_rate = if(@col3='NA',NULL,@col3),
	death_rate = if(@col4='NA',NULL,@col4),
	infant_mortality_rate = if(@col5='NA',NULL,@col5),
	internet_users = if(@col6='NA',NULL,@col6),
	life_exp_at_birth = if(@col7='NA',NULL,@col7),
	maternal_mortality_rate = if(@col8='NA',NULL,@col8),
	net_migration_rate = if(@col9='NA',NULL,@col9),
	population = if(@col10='NA',NULL,@col10),
	population_growth_rate = if(@col11='NA',NULL,@col11);


/*Retreiving all records from table*/
SELECT *FROM FACT;


/***************************************************************************************************/
/**************************************** SOLVING PROBLEMS *****************************************/
/***************************************************************************************************/

/*1. Which country has the highest population?*/
select country as 'Highest Populated country',(population/1000000) as 'Total Population in Million' 
from FACT where 
population = (select max(population) from FACT);  

/*2. Which country has the least number of people?*/
select country as 'Lowest Populated country',population as 'Total Population' 
from FACT where 
population = (select min(population) from FACT);

/*3. Which country is witnessing the highest population growth?*/
select country 'Country with highest population growth',
population_growth_rate as 'population growth rate'
from FACT where
population_growth_rate = (select max(population_growth_rate) from FACT);

/*4. extraordinary number for the population?*/
/*4.1. Which countries will add the most people to their populations next year?*/
 select country, population_increase
 from (select country,population,population_growth_rate,
 population*(population_growth_rate/100) as population_increase,
 rank()over(order by(population*(population_growth_rate/100)) desc) as 'rank' from FACT) as test
 where `rank`=1;
 
 /*4.2. Which countries have a higher birth rate than death rate and maximum life experience?*/
select country, birth_rate, death_rate, life_exp_at_birth
from FACT where
birth_rate > death_rate and 
life_exp_at_birth > (select avg(life_exp_at_birth) from FACT)
order by 2 desc,3 asc,4 desc;


/*5.1.  Which is the most densely populated country in the world?*/
/*Population Density = Number Of People / Land Area*/
select country,
population,
area,
(population/area) as 'Density'
from FACT where
(population/area) = (select max(population/area) from FACT);


/*5.2. Finding Densely Populated Countries*/
/* Considering, countries that are densely populated have:
--Above average values for population.
--Below average values for area.
*/
Select country as 'Population densed country',
area,
population
from FACT where
population > (select avg(population) from FACT) and
area < (select avg(area) from FACT)
order by population desc,area asc;
 