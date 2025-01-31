SELECT *
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project]..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 3,4

-- Change the data type
ALTER TABLE [Portfolio Project]..CovidDeaths
ALTER COLUMN total_cases FLOAT

ALTER TABLE [Portfolio Project]..CovidDeaths 
ALTER COLUMN total_deaths FLOAT

ALTER TABLE [Portfolio Project]..CovidDeaths 
ALTER COLUMN new_cases FLOAT


--DATA EXPLORATION
--Select the data we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1,2

--Checking rate of death by countries. And possiblity of dying if you contact covidin your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE 'Nigeria'
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%Africa%'
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%States%'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS Percentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE 'Nigeria'
AND continent IS NOT NULL 
ORDER BY 1,2

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
--AND continent IS NOT NULL 
ORDER BY 1,2

--Looking at countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
--AND continent IS NOT NULL 
GROUP BY  location, population
ORDER BY PercentPopulationInfected desc

--Showing the contries with the Highest Death Count Per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL 
GROUP BY  location
ORDER BY TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing Continent with the Highest Death Count by Population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL 
GROUP BY  continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS
-- I added the function CAST to new_deaths to change the data type another way of changing data type other than ALTER.

SELECT date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int))as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--Without the date
SELECT SUM(new_cases)as total_cases, SUM(cast(new_deaths as int))as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 AS Deathpercentage
FROM [Portfolio Project]..CovidDeaths
--WHERE location LIKE '%States%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

--JOINS
--Looking at Total Population vs Vaccinations
SELECT *
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date

--Contination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3	 

-- I used CONVERT instead of CAST to change the Data Type
--USE CTE
With PopvsVac(continent,location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)* 100
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT*, (RollingPeopleVaccinated/population)* 100
FROM PopvsVac


--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVacinnated
CREATE TABLE #PercentPopulationVacinnated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVacinnated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)* 100
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)* 100
FROM #PercentPopulationVacinnated

--Creating view to store data for later visualizations 

CREATE VIEW PercentPopulationVacinnated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(FLOAT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)* 100
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
