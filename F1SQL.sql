--Create multiple tables for all Formula 1 CSVs
--Create table for circuits 

CREATE TABLE circuits (
	circuitid INT NOT NULL,
	circuitref TEXT NOT NULL,
	name TEXT NOT NULL,
	city TEXT NOT NULL,
    country TEXT NOT NULL,
	lat DECIMAL NOT NULL,
	long DECIMAL NOT NULL,
	alt INT NOT NULL,
	url TEXT NOT NULL
);

SELECT * FROM circuits;
--------------------------------------------

-- Create a table for Constructor Results
CREATE TABLE constructor_results (
	constructorResultsId INT NOT NULL,
	raceId INT NOT NULL,
	constructorId INT NOT NULL,
	points NUMERIC NOT NULL,
	status TEXT NOT NULL	
);
	
SELECT * FROM constructor_results

----------------------------------------------------

--Create a table for constructor_standings	
CREATE TABLE constructor_standings (
	constructorstandingsId INT NOT NULL,
	raceId INT NOT NULL,
	constructorId INT NOT NULL,
	points NUMERIC NOT NULL,
	position INT NOT NULL,
	positiontext TEXT NOT NULL,
	wins INT NOT NULL
);

SELECT * FROM constructor_standings

-----------------------------------------------------
--Create a table for Constructors
CREATE TABLE constructors (
	constructorId INT NOT NULL,
	constructorRef VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	nationality VARCHAR NOT NULL,
	url TEXT NOT NULL	
);

SELECT * FROM constructors
-----------------------------------------------------	
-- Create a table for Driver Standings
	
CREATE TABLE driver_standings (
	driverStandingsId INT NOT NULL,
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	points NUMERIC NOT NULL,
	position INT NOT NULL,
	positionText TEXT NOT NULL,
	wins INT NOT NULL
);

SELECT * FROM driver_standings	



-----------------------------------------------------
--Create table for drivers
	
CREATE TABLE drivers (
	driverId VARCHAR NOT NULL,
	driverRef VARCHAR NOT NULL,
	number TEXT NOT NULL,
	code VARCHAR NOT NULL,
	forename VARCHAR NOT NULL,
	surname VARCHAR NOT NULL,
	dob DATE NOT NULL,
	nationality VARCHAR NOT NULL,
	url TEXT NOT NULL
)
--Add a new column "full_name"
ALTER TABLE drivers ADD COLUMN full_name VARCHAR;

--Combine both 'forename' and 'surname' into a single column
UPDATE drivers 
SET full_name = forename || ' ' || surname;

--Delete both 'forename' and 'surname' columns
ALTER TABLE drivers
	DROP COLUMN forename,
	DROP COLUMN surname;

-- Change driverid column from VARCHAR into INTEGER
ALTER TABLE drivers
ALTER COLUMN driverid TYPE INTEGER USING driverid::INTEGER;
	
SELECT * FROM drivers

-----------------------------------------------------
CREATE TABLE pit_stops (
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	stop INT NOT NULL,
	lap INT NOT NULL,
	time TIME NOT NULL,
	duration TEXT NOT NULL,
	milliseconds INT NOT NULL
);

--- Turn duration TEXT into TIME
SELECT * FROM pit_stops	
-----------------------------------------------------
--Create table Lap Times
CREATE TABLE lap_times (
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	lap INT NOT NULL,
	position INT NOT NULL,
	time TIME NOT NULL,
	milliseconds INT NOT NULL
);
	
SELECT * FROM lap_times

-----------------------------------------------------	
CREATE TABLE races (
	raceId INT NOT NULL,
	year INT NOT NULL,
	round INT NOT NULL,
	circuitId INT NOT NULL,
	name VARCHAR NOT NULL,
	date DATE NOT NULL,
	time TEXT NOT NULL,
	url TEXT NOT NULL,
	fp1_date TEXT NOT NULL,
	fp1_time TEXT NOT NULL,
	fp2_date TEXT NOT NULL,
	fp2_time TEXT NOT NULL,
	fp3_date TEXT NOT NULL,
	fp3_time TEXT NOT NULL,
	quali_date TEXT NOT NULL,
	quali_time TEXT NOT NULL,
	sprint_date TEXT NOT NULL,
	sprint_time TEXT NOT NULL
);
	
SELECT * FROM races

-----------------------------------------------------
-- Create table for Results
CREATE TABLE results (
	resultId INT NOT NULL,
	raceId INT NOT NULL,
	driverId VARCHAR NOT NULL,
	constructorId INT NOT NULL,
	number TEXT NOT NULL,
	grid INT NOT NULL,
	position TEXT NOT NULL,
	positionText TEXT NOT NULL,
	positionOrder INT NOT NULL,
	points NUMERIC NOT NULL,
	laps INT NOT NULL,
	time TEXT NOT NULL,
	milliseconds TEXT NOT NULL,
	fastestLap TEXT NOT NULL,
	rank TEXT NOT NULL,
	fastestLapTime TEXT NOT NULL,
	fastestLapSpeed TEXT NOT NULL,
	statusId INT NOT NULL
);

-- Remove NULL '\N' values from column.
DELETE FROM results WHERE position = '\N';

-- Verify '\N' values have been removed
SELECT * FROM results WHERE position !~ '^\d+$';

-- Change position and driverid datatype into a Integer
ALTER TABLE results
ALTER COLUMN position TYPE INTEGER USING position::INTEGER
ALTER COLUMN driverid TYPE INTEGER USING driverid::INTEGER;
	
SELECT * FROM results

-----------------------------------------------------
--Create a table for Status
CREATE TABLE status (
	statusId INT NOT NULL,
	status VARCHAR NOT NULL
);
	
SELECT * FROM status

	
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------DATA ANALYSIS OF F1-----------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
	
-- What driver has won the most races at the  Monaco Grand Prix?
SELECT d.full_name, COUNT(*) AS monaco_wins
FROM results rr
JOIN drivers d ON rr.driverid = d.driverid
JOIN races r ON rr.raceid = r.raceid
WHERE r.name = 'Monaco Grand Prix'
AND rr.position = 1
GROUP BY d.full_name
ORDER BY monaco_wins DESC
LIMIT 1;


-----------------------------------------------------
--What constructor has won the most races at the Monaco Grand Prix?

SELECT c.name, COUNT(*) AS monaco_wins
FROM results rr
JOIN drivers d ON rr.driverid = d.driverid
JOIN races r ON rr.raceid = r.raceid
JOIN constructors c ON c.constructorid = rr.constructorid
WHERE r.name = 'Monaco Grand Prix'
AND rr.position = 1
GROUP BY c.name
ORDER BY monaco_wins DESC
LIMIT 1;

-----------------------------------------------------

--What driver has the fastest lap time ever at the Monaco Grand Prix?
SELECT 
	d.full_name, 
    lt.time AS lap_time, 
    r.name AS race_name, 
    r.date AS race_date
FROM lap_times lt
JOIN races r ON lt.raceid = r.raceid
JOIN drivers d ON lt.driverid = d.driverid
WHERE r.name = 'Monaco Grand Prix'
ORDER BY lt.time ASC
LIMIT 1;

