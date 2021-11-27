Queries used FOR Tableau Project

-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM "public"."CovidDeaths"
--Where location like '%states%'
WHERE continent IS NOT NULL 
--Group By date
ORDER BY 1,2


-- 2. 

SELECT LOCATION, SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM "public"."CovidDeaths"
--Where location like '%states%'
WHERE continent IS NULL 
AND LOCATION NOT IN ('World', 'European Union', 'International')
GROUP BY LOCATION
ORDER BY TotalDeathCount DESC


-- 3.

SELECT LOCATION, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM "public"."CovidDeaths"
--Where location like '%states%'
GROUP BY LOCATION, Population
ORDER BY PercentPopulationInfected DESC


-- 4.

SELECT LOCATION, Population,date, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM "public"."CovidDeaths"
--Where location like '%states%'
GROUP BY LOCATION, Population, date
ORDER BY PercentPopulationInfected DESC








