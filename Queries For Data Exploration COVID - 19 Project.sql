--Queries For Data Exploration Project

-- Select Data that we are going to be using

SELECT "location", Date, total_cases, new_cases, total_deaths, population
FROM "public"."CovidDeaths" 
ORDER BY 1, 2 

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihhod of dying if you cantract covid in specific countries

SELECT "location", Date, total_cases, total_deaths, ("total_deaths"/"total_cases")*100 AS Percent_popualtion_deaths
FROM "public"."CovidDeaths"
ORDER BY 1, 2 

--Looking at the Total cases vs Population
-- Shows what percentage of the population has got covid

SELECT "location", Date, total_cases, population, (total_cases/population)*100 AS Percent_population_infected
FROM "public"."CovidDeaths"
ORDER BY 1, 2 

--Looking at countries with Highest Infection Rate compared to Poulation

SELECT "location", population, MAX(total_cases) AS Highest_Infection_Count, Max((total_cases/population))*100 AS Percent_population_infected
FROM "public"."CovidDeaths"
GROUP BY "location", population
ORDER BY Percent_population_infected DESC

--Showing the countries with the highest death count per population

SELECT "location", MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM "public"."CovidDeaths"
WHERE continent IS NOT NULL
GROUP BY "location"
ORDER BY total_death_count DESC

--Showing the continents witht he highest death count

SELECT "location", MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM "public"."CovidDeaths"
WHERE continent IS NULL
GROUP BY LOCATION
ORDER BY total_death_count DESC

--GLOBAL NUMBERS

SELECT Date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Death_Percentage
FROM "public"."CovidDeaths"
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2


-- Looking at total population Vs Vaccinations

WITH PopvsVac (continent, LOCATION, date, population, new_vaccinations, Rolling_People_Vaccinated)
AS 
(SELECT "CovidDeaths"."continent", "CovidDeaths"."location", "CovidDeaths"."date", "CovidDeaths"."population", "CovidVaccination"."new_vaccinations" , sum(CAST("CovidVaccination"."new_vaccinations" AS INT)) OVER (PARTITION BY "CovidDeaths"."location" ORDER BY "CovidDeaths"."location", "CovidDeaths"."date") AS Rolling_People_Vaccinated 
FROM "public"."CovidDeaths"
JOIN "public"."CovidVaccination"
    ON "public"."CovidDeaths"."location" = "public"."CovidVaccination"."location"
    AND "public"."CovidDeaths"."date" = "public"."CovidVaccination"."date"
WHERE "CovidDeaths"."continent" IS NOT NULL
)
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopvsVac








