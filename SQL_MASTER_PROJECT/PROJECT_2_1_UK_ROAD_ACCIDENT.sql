/*CREATING DATABASE*/
CREATE DATABASE ACCIDENT_BY_VEHICLE;

USE ACCIDENT_BY_VEHICLE;

/*****************************************************************************************************/
/***************************************** CREATING TABLES *******************************************/
/*****************************************************************************************************/

CREATE TABLE ACCIDENT(
	ACCIDENT_INDEX VARCHAR(13),
    ACCIDENT_SEVERITY INT
);

CREATE TABLE VEHICLES(
	ACCIDENT_INDEX VARCHAR(13),
    VEHICLE_TYPE VARCHAR(50)
);

CREATE TABLE VEHICLE_TYPES(
	VEHICLE_CODE INT,
    VEHICLE_TYPE VARCHAR(100)
);

/***************************************************************************************************/
/*************************************** LOAD DATA INTO TABLES *************************************/
/***************************************************************************************************/

LOAD DATA INFILE 'D:/technical skill studies/data analysis/assignment/INEURON/FSDA assignment/assignment-2/Accidents_2015.csv'
INTO TABLE ACCIDENT
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET ACCIDENT_INDEX=@col1, ACCIDENT_SEVERITY=@col2;


LOAD DATA INFILE 'D:/technical skill studies/data analysis/assignment/INEURON/FSDA assignment/assignment-2/Vehicles_2015.csv'
INTO TABLE VEHICLES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET ACCIDENT_INDEX=@col1, VEHICLE_TYPE=@col2;


LOAD DATA INFILE 'D:/technical skill studies/data analysis/assignment/INEURON/FSDA assignment/assignment-2/vehicle_type.csv'
INTO TABLE VEHICLE_TYPES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


/***************************************************************************************************/
/*********************************** SOLVING GIVEN PROBLEMS ****************************************/
/***************************************************************************************************/

/*1. Evaluate the median severity value of accidents caused by various Motorcycles*/
WITH ACCIDENTS_TEMP_EACH AS(
SELECT vt.VEHICLE_TYPE, a.ACCIDENT_SEVERITY
FROM ACCIDENT a
JOIN VEHICLES v ON a.ACCIDENT_INDEX = v.ACCIDENT_INDEX
JOIN VEHICLE_TYPES vt ON v.VEHICLE_TYPE = vt.VEHICLE_CODE
WHERE vt.VEHICLE_TYPE LIKE '%Motorcycle%'
ORDER BY a.ACCIDENT_SEVERITY)

SELECT 
    VEHICLE_TYPE, 
    AVG(ACCIDENT_SEVERITY) AS MEDIAN_SEVERITY
FROM (
SELECT 
    VEHICLE_TYPE,
    ACCIDENT_SEVERITY, 
    ROW_NUMBER() OVER(PARTITION BY VEHICLE_TYPE ORDER BY ACCIDENT_SEVERITY) rn,
    count(*) OVER(PARTITION BY VEHICLE_TYPE) cnt
  FROM ACCIDENTS_TEMP_EACH
) AS acc
WHERE rn IN ( FLOOR((cnt + 1) / 2), FLOOR( (cnt + 2) / 2) )
GROUP BY VEHICLE_TYPE;


/*CREATE INDEX ON ACCIDENT_INDEX AS IT IS USING IN BOTH VEHICLES AND ACCIDENT TABLES AND JOIN CLAUSES USING INDEXES WILL PERFORM FASTER */
CREATE INDEX ACCIDENT_INDEX ON ACCIDENT(ACCIDENT_INDEX);
CREATE INDEX ACCIDENT_INDEX ON VEHICLES(ACCIDENT_INDEX);


/*2. Evaluate Accident Severity and Total Accidents per Vehicle Type*/
SELECT vt.VEHICLE_TYPE AS VEHICLE_TYPE, a.ACCIDENT_SEVERITY AS SEVERITY, 
COUNT(vt.VEHICLE_TYPE) AS TOTAL_ACCIDENTS
FROM ACCIDENT a 
JOIN VEHICLES v ON a.ACCIDENT_INDEX = v.ACCIDENT_INDEX
JOIN VEHICLE_TYPES vt ON v.VEHICLE_TYPE = vt.VEHICLE_CODE
GROUP BY 1
ORDER BY 2,3; 

/*3. Calculate the Average Severity by vehicle type*/
SELECT vt.VEHICLE_TYPE AS VEHICLE_TYPE, AVG(a.ACCIDENT_SEVERITY) AS AVERAGE_SEVERITY
FROM ACCIDENT a 
JOIN VEHICLES v ON a.ACCIDENT_INDEX = v.ACCIDENT_INDEX
JOIN VEHICLE_TYPES vt ON v.VEHICLE_TYPE = vt.VEHICLE_CODE
GROUP BY 1
ORDER BY 2;

/*4. Calculate the Average Severity and Total Accidents by Motorcycle.*/
SELECT vt.VEHICLE_TYPE AS VEHICLE_TYPE, AVG(a.ACCIDENT_SEVERITY) AS AVERAGE_SEVERITY,
COUNT(vt.VEHICLE_TYPE) AS TOTAL_ACCIDENTS
FROM ACCIDENT a 
JOIN VEHICLES v ON a.ACCIDENT_INDEX = v.ACCIDENT_INDEX
JOIN VEHICLE_TYPES vt ON v.VEHICLE_TYPE = vt.VEHICLE_CODE
WHERE vt.VEHICLE_TYPE LIKE '%Motorcycle%'
GROUP BY 1
ORDER BY 2,3;