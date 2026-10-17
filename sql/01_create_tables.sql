-- Create database and tables for the NHS Scotland A&E project
CREATE DATABASE IF NOT EXISTS nhs_ae;
USE nhs_ae;

-- Monthly attendance and waiting time
DROP TABLE IF EXISTS ae_activity;
CREATE TABLE ae_activity(
Month DATE NOT NULL,
HBT CHAR(9) NOT NULL,
HBName VARCHAR(50),
TreatmentLocation VARCHAR(10)  NOT NULL,
HospitalName VARCHAR(120),
DepartmentType VARCHAR(10)  NOT NULL,
NumberOfAttendancesAll        INT,
NumberWithin4HoursAll         INT,
NumberOver4HoursAll           INT,
PercentageWithin4HoursAll     DECIMAL(5,2),
NumberOfAttendancesEpisode    INT,
NumberWithin4HoursEpisode     INT,
NumberOver4HoursEpisode       INT,
PercentageWithin4HoursEpisode DECIMAL(5,2),
NumberOver8HoursEpisode       INT,
PercentageOver8HoursEpisode   DECIMAL(5,2),
NumberOver12HoursEpisode      INT,
PercentageOver12HoursEpisode  DECIMAL(5,2),
PRIMARY KEY (Month, TreatmentLocation, DepartmentType)
);

-- Attendances by day of week and hour of arrival
DROP TABLE IF EXISTS ae_when;
CREATE TABLE ae_when (
Month               DATE        NOT NULL,
HBT                 CHAR(9)     NOT NULL,
HBName              VARCHAR(50),
TreatmentLocation   VARCHAR(10) NOT NULL,
HospitalName        VARCHAR(120),
DepartmentType      VARCHAR(10),
Day                 VARCHAR(10),
DayNumber           TINYINT,
Week                VARCHAR(10),
Hour                VARCHAR(20),
HourStart           TINYINT,
`InOut`             VARCHAR(15),
NumberOfAttendances INT
);