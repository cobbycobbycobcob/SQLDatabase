CREATE DATABASE covid19;
USE covid19;
-- IMPORT DATA
	-- NOTE: Data pre-segmented into 'deaths', 'vaccinations', and 'demographics' tables in EXCEL prior to import
-- FIRST:
-- In terminal mysql, run:
	-- ~ % /usr/local/mysql/bin/mysql -u root -p 
		-- Enter password
	-- mysql> set global local_infile=true; 
	-- mysql> exit;
    -- ~ % /usr/local/mysql/bin/mysql --local_infile=1 -u root -p covid19
    -- Enter password
-- SECOND:
-- In terminal mysql, run:

LOAD DATA LOCAL INFILE '/Users/jacobmorgan/Desktop/SQL/Data/CovidDeaths.csv'
INTO TABLE covid19.deaths FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/jacobmorgan/Desktop/SQL/Data/CovidVaccinations.csv'
INTO TABLE covid19.vax FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/jacobmorgan/Desktop/SQL/Data/CovidDemographics.csv'
INTO TABLE covid19.demos FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Replace '' with NULL
	-- Method 1
		-- Remove Safe Updates Protection
SET SQL_SAFE_UPDATES=0;
	-- Deaths Table
UPDATE covid19.deaths SET iso_code = NULL WHERE iso_code = '';
UPDATE covid19.deaths SET continent = NULL WHERE continent = '';
UPDATE covid19.deaths SET location = NULL WHERE location = '';
UPDATE covid19.deaths SET population = NULL WHERE population = '';
UPDATE covid19.deaths SET new_cases = NULL WHERE new_cases = '';
UPDATE covid19.deaths SET total_cases = NULL WHERE total_cases = '';
UPDATE covid19.deaths SET total_deaths = NULL WHERE total_deaths = '';
UPDATE covid19.deaths SET new_deaths = NULL WHERE new_deaths = '';

	-- Demos Table
UPDATE covid19.demos SET iso_code = NULL WHERE iso_code = '';
UPDATE covid19.demos SET continent = NULL WHERE continent = '';
UPDATE covid19.demos SET location = NULL WHERE location = '';
UPDATE covid19.demos SET population = NULL WHERE population = '';
UPDATE covid19.demos SET stringency_index = NULL WHERE stringency_index = '';
UPDATE covid19.demos SET population_density = NULL WHERE population_density = '';
UPDATE covid19.demos SET median_age = NULL WHERE median_age = '';
UPDATE covid19.demos SET aged_65_older = NULL WHERE aged_65_older = '';
UPDATE covid19.demos SET aged_70_older = NULL WHERE aged_70_older = '';
UPDATE covid19.demos SET gdp_per_capita = NULL WHERE gdp_per_capita = '';
UPDATE covid19.demos SET extreme_poverty = NULL WHERE extreme_poverty = '';
UPDATE covid19.demos SET cardiovasc_death_rate = NULL WHERE cardiovasc_death_rate = '';
UPDATE covid19.demos SET diabetes_prevalence = NULL WHERE diabetes_prevalence = '';
UPDATE covid19.demos SET female_smokers = NULL WHERE female_smokers = '';
UPDATE covid19.demos SET male_smokers = NULL WHERE male_smokers = '';
UPDATE covid19.demos SET handwashing_facilities = NULL WHERE handwashing_facilities = '';
UPDATE covid19.demos SET hospital_beds_per_thousand = NULL WHERE hospital_beds_per_thousand = '';
UPDATE covid19.demos SET life_expectancy = NULL WHERE life_expectancy = '';
UPDATE covid19.demos SET human_development_index = NULL WHERE human_development_index = '';
UPDATE covid19.demos SET excess_mortality_cumulative = NULL WHERE excess_mortality_cumulative = '';

	-- Vax Table
UPDATE covid19.vax SET iso_code = NULL WHERE iso_code = '';
UPDATE covid19.vax SET continent = NULL WHERE continent = '';
UPDATE covid19.vax SET location = NULL WHERE location = '';
UPDATE covid19.vax SET new_tests = NULL WHERE new_tests = '';
UPDATE covid19.vax SET total_tests = NULL WHERE total_tests = '';
UPDATE covid19.vax SET positive_rate = NULL WHERE positive_rate = '';
UPDATE covid19.vax SET tests_per_case = NULL WHERE tests_per_case = '';
UPDATE covid19.vax SET tests_units = NULL WHERE tests_units = '';
UPDATE covid19.vax SET total_vaccinations = NULL WHERE total_vaccinations = '';
UPDATE covid19.vax SET people_vaccinated = NULL WHERE people_vaccinated = '';
UPDATE covid19.vax SET people_fully_vaccinated = NULL WHERE people_fully_vaccinated = '';
UPDATE covid19.vax SET total_boosters = NULL WHERE total_boosters = '';
UPDATE covid19.vax SET new_vaccinations = NULL WHERE new_vaccinations = '';

		-- Restore Safe Updates Protection
SET SQL_SAFE_UPDATES=1;

-- DROP Unwanted COLUMNS
	-- Deaths Table
ALTER TABLE covid19.deaths
DROP COLUMN new_cases_smoothed,
DROP COLUMN new_deaths_smoothed,
DROP COLUMN total_cases_per_million,
DROP COLUMN new_cases_smoothed_per_million,
DROP COLUMN total_deaths_per_million,
DROP COLUMN new_deaths_per_million,
DROP COLUMN new_cases_per_million;

	-- Demos Table
ALTER TABLE covid19.demos
DROP COLUMN excess_mortality_cumulative_per_million;
	-- Vax Table
ALTER TABLE covid19.vax
DROP COLUMN new_tests_smoothed,
DROP COLUMN new_tests_smoothed_per_thousand,
DROP COLUMN new_vaccinations_smoothed,
DROP COLUMN total_tests_per_thousand,
DROP COLUMN total_vaccinations_per_hundred,
DROP COLUMN people_vaccinated_per_hundred,
DROP COLUMN people_fully_vaccinated_per_hundred,
DROP COLUMN total_boosters_per_hundred,
DROP COLUMN new_vaccinations_smoothed_per_million,
DROP COLUMN new_people_vaccinated_smoothed,
DROP COLUMN new_people_vaccinated_smoothed_per_hundred;

-- EXPLORE THE DATA: Canada
SELECT
	location,
    date, 
    total_cases, 
    total_deaths,
	(total_deaths/total_cases) * 100 AS perct_deaths,
    (total_cases/population) * 100 AS perct_pop_infct
FROM covid19.deaths
WHERE deaths.location LIKE 'Canada'
ORDER BY 1,2;

-- Countries with Highest Infection Rate Compared to Population
SELECT
	location,
    population,
    MAX(total_cases) AS MaxInfctCount,
    MAX((total_cases/population)) * 100 as MaxPrctInfct
FROM covid19.deaths
WHERE continent IS NOT NULL
GROUP BY location, population -- NOTE: GROUP BY requires 2 because those are nonaggregated columns
ORDER BY location DESC;

-- Total Death Count By Country
SELECT
	location,
    MAX(total_deaths) AS TotalDeathCount
From covid19.deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Total Death Count By Continent
SELECT
	continent,
    MAX(total_deaths) AS TotalDeathCount
FROM covid19.deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount;

