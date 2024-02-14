----step 1: select data that we are going to be using

--select Location, Date, total_cases, new_cases, total_deaths,
--population
--from [dbo].[TotalCovidData]
--order by 1, 2

----looking at total cases vs total deaths

--select Location, Date, total_cases, total_deaths,
--(convert(float, total_deaths) / convert (float, total_cases)*100)
--as DeathPercentage
--from [dbo].[TotalCovidData]
--where total_cases is not null and total_deaths is not null
----and location = or like '_'
--order by 1, 2

----looking at total cases vs population. No data available for current number of infected by date.

--select Location, Date, population, total_cases, 
--(convert (float, total_cases)/convert(float, population)*100)
--as PercentHasBeenInfected
--from [dbo].[TotalCovidData]
--where total_cases is not null and total_deaths is not null
----and location = or like '_'
--order by 1, 2

----showing countries with highest death count for population

--select Location, max(cast (total_deaths as float)) as TotalDeathCount, 
--Population
--from [dbo].[TotalCovidData]
--where total_deaths is not null
--and continent is not null
----shows only countries and not continents/groups of countries
------and location = or like '_'
--group by location, population
--order by 2 desc

----showing continents with highest death counts

--select continent, max(population) as MaxPopulation,
--max(cast (total_deaths as float)) as TotalDeathCount 
--from [dbo].[TotalCovidData]
--where continent is not null
--group by continent
--order by TotalDeathCount desc

----Global Numbers - UPDATED WEEKLY

----To show every day

--select Date, Total_Cases, Total_Deaths, (New_Deaths/Total_Cases*100) as DailyDeathPercentage
--from [dbo].[TotalCovidData]
--where location = 'World'
----and location = or like '_'
--order by date

------to show every week

----create temp table

--Drop table if exists #TempCovidWorldData
--select Date, Total_Cases, Total_Deaths, (New_Deaths/Total_Cases*100) as DeathPercentage
--into #TempCovidWorldData
--from [dbo].[TotalCovidData]
--where location = 'World';

------number the rows and select every 7th

--WITH NumberedRows AS (
--    SELECT *, ROW_NUMBER() OVER (ORDER BY date) AS RowNum
--    FROM #TempCovidWorldData
--)
--SELECT Date, Total_Cases, Total_Deaths, DeathPercentage
--FROM NumberedRows
--WHERE RowNum % 7 = 1;

----looking at Population vs. Vaccination

--select Continent, Date, Location, Population, New_Vaccinations,
--sum(cast(New_Vaccinations as float)) over (Partition by location 
--order by Location, Date) as PeopleVaccinated_Rolling
--from [dbo].[TotalCovidData]
--where continent is not null
--order by Location, Date;

--with PopVsVac (Continent, Date, Location, Population, New_Vaccinations, PeopleVaccinated_Rolling) 
--as (
--		select Continent, Date, Location, Population, New_Vaccinations,
--sum(cast(New_Vaccinations as float)) over (Partition by location 
--order by Location, Date) as PeopleVaccinated_Rolling
--from [dbo].[TotalCovidData]
--where continent is not null
--)
--select*, (PeopleVaccinated_Rolling/Population)*100 as RollingVaccinationPercentage
--from PopVsVac
--order by Location, Date

----creating view to store data for future visualization

--create view PercentPopulationVaccinated as
--select Continent, Date, Location, Population, New_Vaccinations,
--sum(cast(New_Vaccinations as float)) over (Partition by location 
--order by Location, Date) as PeopleVaccinated_Rolling
--from [dbo].[TotalCovidData]
--where continent is not null
----order by Location, Date;