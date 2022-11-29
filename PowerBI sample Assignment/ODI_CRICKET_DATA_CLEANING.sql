-- CREATING DATABASE
CREATE DATABASE CRICKET_ODI;

USE DATABASE CRICKET_ODI;

-- CREATING CUSTOM WAREHOUSE
CREATE WAREHOUSE SAHIL_DEMO_WAREHOUSE WITH WAREHOUSE_SIZE = 'MEDIUM' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE;

/********************************************************************************************************************************************************/
-- ----------------------------------------------- CLEANING OF BATSMEN DATA

--creating BATSMEN_DATA table according given data set
CREATE OR REPLACE TABLE BATSMEN_DATA(
 Score VARCHAR(6), 
 Runs VARCHAR(6), 
 Balls_Faced VARCHAR(6), 
 Strike_Rate VARCHAR(6),
 FOURs VARCHAR(6),	
 SIXs VARCHAR(6),	
 Opposition VARCHAR(50),	
 Ground VARCHAR(50),
 Start_Date VARCHAR(20),	
 Match_ID VARCHAR(20),
 Batsman VARCHAR(50),	
 Player_ID VARCHAR(10),
 PRIMARY KEY (Match_ID,Player_ID)
);

--drop table BATSMEN_DATA;
-- retreiving all records from BATSMEN_DATA
SELECT * FROM BATSMEN_DATA;


-- create a new column PLAYER_STATUS, if score is not any numeric then value will be 'NOT PLAYED' else 'PLAYED'
ALTER TABLE BATSMEN_DATA ADD PLAYER_STATUS VARCHAR(20) AS 
    CASE WHEN Score = 'DNB' OR Score = 'TDNB' OR Score = 'sub' OR Score = 'absent' OR Score = '-'
        THEN 'NOT PLAYED'
        ELSE 'PLAYED'
    END;
    

-- Observing the changes in newly added column
SELECT * FROM BATSMEN_DATA WHERE Score='DNB'OR Score = 'TDNB' OR Score = 'sub' OR Score = 'absent' OR Score = '-';

-- lets update column Runs, replace '-' with NULL
UPDATE BATSMEN_DATA SET Runs = NULL WHERE Runs ='-'

-- lets update column BALLS_FACED, replace '-' with NULL
UPDATE BATSMEN_DATA SET BALLS_FACED = NULL WHERE BALLS_FACED ='-'

-- lets update column STRIKE_RATE, replace '-' with NULL
UPDATE BATSMEN_DATA SET STRIKE_RATE = NULL WHERE STRIKE_RATE ='-'

-- lets update column FOURS, replace '-' with NULL
UPDATE BATSMEN_DATA SET FOURS = NULL WHERE FOURS ='-'

-- lets update column SIXS, replace '-' with NULL
UPDATE BATSMEN_DATA SET SIXS = NULL WHERE SIXS ='-'

 

-- trim column OPPOSITION 
UPDATE BATSMEN_DATA SET OPPOSITION = LTRIM(RTRIM(OPPOSITION));

-- trim column GROUND 
UPDATE BATSMEN_DATA SET GROUND = LTRIM(RTRIM(GROUND));

-- trim column BATSMAN 
UPDATE BATSMEN_DATA SET BATSMAN = LTRIM(RTRIM(BATSMAN));

-- trim column MATCH_ID 
UPDATE BATSMEN_DATA SET MATCH_ID = LTRIM(RTRIM(MATCH_ID));

-- trim column PLAYER_ID 
UPDATE BATSMEN_DATA SET PLAYER_ID = LTRIM(RTRIM(PLAYER_ID));

SELECT * FROM BATSMEN_DATA;

-- removing v and space from prefix of column OPPOSITION
UPDATE BATSMEN_DATA SET OPPOSITION = SUBSTRING(OPPOSITION,2,LEN(OPPOSITION));

-- try to check if length of MATCH_ID is equal or not in the column
SELECT DISTINCT LEN(MATCH_ID) FROM BATSMEN_DATA;

-- now select required data which are required for visualization, and download the result data of the query in csv format
SELECT 
START_DATE, 
MATCH_ID, 
PLAYER_ID, 
BATSMAN,  
CAST(RUNS AS INT) AS RUNS, 
CAST(BALLS_FACED AS INT) AS BALLS_FACED,
CAST(STRIKE_RATE AS FLOAT) AS STRIKE_RATE,
CAST(FOURS AS INT) AS FOURS,
CAST(SIXS AS INT) AS SIXS,
OPPOSITION,
GROUND
FROM BATSMEN_DATA WHERE PLAYER_STATUS = 'PLAYED';

/********************************************************************************************************************************************************/
-- ----------------------------------------------- CLEANING OF BOWLERS DATA

--creating BOWLER_DATA table according given data set
CREATE OR REPLACE TABLE BOWLER_DATA(
 Overs VARCHAR(6), 
 Maiden_balls VARCHAR(6), 
 Runs_given VARCHAR(6),
 Wickets_taken VARCHAR(6),
 Economy VARCHAR(6),
 Average_Ball_Speed VARCHAR(6),
 Strike_Rate VARCHAR(6),	
 Opposition VARCHAR(50),	
 Ground VARCHAR(50),
 Start_Date VARCHAR(20),	
 Match_ID VARCHAR(20),
 Bowler VARCHAR(50),	
 Player_ID VARCHAR(10),
 PRIMARY KEY (Match_ID,Player_ID)
);

-- retreiving all records from BOWLER_DATA
SELECT * FROM BOWLER_DATA;

-- lets update column OVERS, replace '-' with NULL
UPDATE BOWLER_DATA SET OVERS = NULL WHERE OVERS ='-'

-- lets update column MAIDEN_BALLS, replace '-' with NULL
UPDATE BOWLER_DATA SET MAIDEN_BALLS = NULL WHERE MAIDEN_BALLS ='-'

-- lets update column STRIKE_RATE, replace '-' with NULL
UPDATE BOWLER_DATA SET STRIKE_RATE = NULL WHERE STRIKE_RATE ='-'

-- lets update column RUNS_GIVEN, replace '-' with NULL
UPDATE BOWLER_DATA SET RUNS_GIVEN = NULL WHERE RUNS_GIVEN ='-'

-- lets update column WICKETS_TAKEN, replace '-' with NULL
UPDATE BOWLER_DATA SET WICKETS_TAKEN = NULL WHERE WICKETS_TAKEN ='-'

-- lets update column ECONOMY, replace '-' with NULL
UPDATE BOWLER_DATA SET ECONOMY = NULL WHERE ECONOMY ='-'

-- lets update column AVERAGE_BALL_SPEED, replace '-' with NULL
UPDATE BOWLER_DATA SET AVERAGE_BALL_SPEED = NULL WHERE AVERAGE_BALL_SPEED ='-'


-- trim column OPPOSITION 
UPDATE BOWLER_DATA SET OPPOSITION = LTRIM(RTRIM(OPPOSITION));

-- trim column GROUND 
UPDATE BOWLER_DATA SET GROUND = LTRIM(RTRIM(GROUND));

-- trim column BOWLER 
UPDATE BOWLER_DATA SET BOWLER = LTRIM(RTRIM(BOWLER));

-- trim column MATCH_ID 
UPDATE BOWLER_DATA SET MATCH_ID = LTRIM(RTRIM(MATCH_ID));

-- trim column PLAYER_ID 
UPDATE BOWLER_DATA SET PLAYER_ID = LTRIM(RTRIM(PLAYER_ID));



-- removing v and space from prefix of column OPPOSITION
UPDATE BOWLER_DATA SET OPPOSITION = SUBSTRING(OPPOSITION,2,LEN(OPPOSITION));

-- try to check if length of MATCH_ID is equal or not in the column
SELECT DISTINCT LEN(MATCH_ID) FROM BOWLER_DATA;


-- now select required data which are required for visualization, and download the result data of the query in csv format
SELECT 
START_DATE, 
MATCH_ID, 
PLAYER_ID, 
BOWLER,  
CAST(OVERS AS FLOAT) AS OVERS, 
CAST(MAIDEN_BALLS AS INT) AS MAIDEN_BALLS,
CAST(RUNS_GIVEN AS INT) AS RUNS_GIVEN,
CAST(WICKETS_TAKEN AS INT) AS WICKETS_TAKEN,
CAST(ECONOMY AS FLOAT) AS ECONOMY,
CAST(AVERAGE_BALL_SPEED AS FLOAT) AS AVERAGE_BALL_SPEED,
CAST(STRIKE_RATE AS FLOAT) AS STRIKE_RATE,
OPPOSITION,
GROUND
FROM BOWLER_DATA;

/********************************************************************************************************************************************************/
-- ----------------------------------------------- CLEANING OF MATCH RESULT DATA

--creating MATCH_RESULT table according given data set
CREATE OR REPLACE TABLE MATCH_RESULT(
 Result VARCHAR(20), 
 Margin VARCHAR(30), 
 BR VARCHAR(6),
 Toss VARCHAR(6),
 Bat VARCHAR(6),	
 Opposition VARCHAR(50),	
 Ground VARCHAR(50),
 Start_Date VARCHAR(20),	
 Match_ID VARCHAR(20),
 Country VARCHAR(50),	
 Country_ID VARCHAR(10)
);

-- retreiving all records from MATCH_RESULT
SELECT * FROM MATCH_RESULT;

-- MAKE COUNTRY INTO UPPERCASE LETTERS
UPDATE MATCH_RESULT SET COUNTRY = UPPER(COUNTRY);

-- try to identify distinct results
SELECT DISTINCT RESULT FROM MATCH_RESULT; --results are 'won', 'lost', 'n/r', 'tied', 'aban', 'canc' and '-'

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='won';  --663 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='lost';  --562 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='n/r';   --54 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='tied';  --14 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='aban';  --22 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='canc';  --4 RECORDS FOUND

-- RETREIVING NUMBER OF RECORDS WHERE RESULT='won'
SELECT COUNT(*) FROM MATCH_RESULT WHERE RESULT='-';   --3 RECORDS FOUND

-- RETREIVING RESULTS WHERE RESULT='won'
SELECT * FROM MATCH_RESULT WHERE RESULT= '-';  
/*FROM RESULUT WE CAN CONCLUDE THAT MATCH IS PLAYED BUT WE CAN NOT PREDICT THE RESULT, SO HERE WE ASSUME THAT THE MATCH IS N/R(NO RESULT)*/ 
-- UPDATE COLUMN ACCORDING ABOVE ASSUMPTION
UPDATE MATCH_RESULT SET RESULT = 'n/r' WHERE RESULT = '-'; --UPDATE RESULT '-' TO 'n/r'

-- RETREIVING RESULTS WHERE RESULT='won'
SELECT * FROM MATCH_RESULT WHERE RESULT='aban';
/*FROM THE DATA WE CAN NOT PREDICT ANYTHING, THAT WE CAN REPLACE, SO HERE WE ASSUME THAT THE MATCH IS NOT PLAYED */
-- UPDATE COLUMN ACCORDING ABOVE ASSUMPTION
UPDATE MATCH_RESULT SET RESULT = 'NOT PLAYED' WHERE RESULT = 'aban'; --UPDATE RESULT 'aban' TO 'NOT PLAYED'

-- RETREIVING RESULTS WHERE RESULT='won'
SELECT * FROM MATCH_RESULT WHERE RESULT='canc';
/*FROM THE DATA WE CAN NOT PREDICT ANYTHING, THAT WE CAN REPLACE, SO HERE WE ASSUME THAT THE MATCH IS NOT PLAYED*/
-- UPDATE COLUMN ACCORDING ABOVE ASSUMPTION
UPDATE MATCH_RESULT SET RESULT = 'NOT PLAYED' WHERE RESULT = 'canc';   --UPDATE RESULT 'canc' TO 'NOT PLAYED'


-- trim column OPPOSITION
UPDATE MATCH_RESULT SET OPPOSITION = LTRIM(RTRIM(OPPOSITION));

-- trim column GROUND
UPDATE MATCH_RESULT SET GROUND = LTRIM(RTRIM(GROUND));

-- trim column BAT
UPDATE MATCH_RESULT SET BAT = LTRIM(RTRIM(BAT));

-- trim column TOSS
UPDATE MATCH_RESULT SET TOSS = LTRIM(RTRIM(TOSS));

-- trim column MATCH_ID
UPDATE MATCH_RESULT SET MATCH_ID = LTRIM(RTRIM(MATCH_ID));

-- trim column COUNTRY
UPDATE MATCH_RESULT SET COUNTRY = LTRIM(RTRIM(COUNTRY));

-- trim column COUNTRY_ID
UPDATE MATCH_RESULT SET COUNTRY_ID = LTRIM(RTRIM(COUNTRY_ID));



-- removing v and space from prefix of column OPPOSITION
UPDATE MATCH_RESULT SET OPPOSITION = SUBSTRING(OPPOSITION,2,LEN(OPPOSITION));

-- try to check if length of MATCH_ID is equal or not in the column
SELECT DISTINCT LEN(MATCH_ID) FROM MATCH_RESULT; --TWO TYPES OF LENGTH 10,11 EXISTS

-- observing records where length of MATCH_ID is 11, found that in suffix an extra 'a' exists
SELECT * FROM MATCH_RESULT WHERE LEN(MATCH_ID)=11;

-- update the column to remove extra 'a' from from suffix
UPDATE MATCH_RESULT SET MATCH_ID = SUBSTRING(MATCH_ID,1,LEN(MATCH_ID)-1) WHERE LEN(MATCH_ID)=11;

-- try to identify distinct values from TOSS
SELECT DISTINCT TOSS FROM MATCH_RESULT; -- '-' FOUND

-- observing the result of the match where '-' found, results are either 'n/r' or 'NOT PLAYED'
SELECT DISTINCT RESULT FROM MATCH_RESULT WHERE TOSS='-';

-- lets update column TOSS, replace '-' with NULL
UPDATE MATCH_RESULT SET TOSS = NULL WHERE TOSS = '-';

-- try to identify distinct values from BAT
SELECT DISTINCT BAT FROM MATCH_RESULT; -- '-' FOUND

-- observing the result of the match where '-' found, results are either 'n/r' or 'NOT PLAYED'
SELECT DISTINCT RESULT FROM MATCH_RESULT WHERE BAT='-';

-- lets update column BAT, replace '-' with NULL
UPDATE MATCH_RESULT SET BAT = NULL WHERE BAT = '-';


-- observing the result of the match where '-' found in MARGIN column, results ar either 'n/r' or 'NOT PLAYED'
SELECT DISTINCT RESULT FROM MATCH_RESULT WHERE MARGIN='-';

-- lets update column MARGIN, replace '-' with NULL
UPDATE MATCH_RESULT SET MARGIN = NULL WHERE MARGIN = '-';


-- now select required data which are required for visualization, and download the result data of the query in csv format
SELECT 
START_DATE, 
MATCH_ID,
RESULT, 
Margin, 
Toss,
Bat,	
Opposition,	
Ground,
Country,	
Country_ID
FROM MATCH_RESULT;