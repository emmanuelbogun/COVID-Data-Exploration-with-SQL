Select * 
From PortfolioProject..CovidDeaths

Select * 
From PortfolioProject..CovidVaccinations

-- Selecting all from Nigeria
Select *
From PortfolioProject..CovidDeaths
Where location = 'Nigeria'
Order by date


-- Important Info on Nigeria
Select location, 
date, 
population, 
total_cases, 
total_deaths
From PortfolioProject..CovidDeaths
Where location = 'Nigeria'
Order by 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- The likelihood of dying if you contract Covid19 in Nigeria
Select location, 
date, 
population, 
total_cases, 
total_deaths, 
(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = 'Nigeria'
Order by 1,2

-- TOTAL CASES VS POPULATION
-- shows what percentage of the total population got Covid
Select location, 
date, 
population, 
total_cases, 
total_deaths, 
(total_cases/population)*100 as Infected_pop
From PortfolioProject..CovidDeaths
Where location = 'Nigeria'
Order by 1,2

-- AFRICAN COUNTRIES WITH THE HIGHEST INFECTION RATE
Select continent, 
location, 
population,
MAX(total_cases) as TotalCases,
MAX((total_cases/population))*100 as PercentInfected
From PortfolioProject..CovidDeaths
Where continent = 'Africa'
Group by continent, location, population
Order by PercentInfected desc

--saving in a view
create view InfectionRate as
Select 
dea.location,
dea.population,
MAX(dea.total_cases) as TotalCases,
SUM(cast(vac.new_vaccinations as int)) as TotalVaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Africa' 
and vac.new_vaccinations is not null
Group by dea.location, dea.population
-- Order by dea.location

-- AFRICAN COUNTRY WITH THE HGHEST DEATH COUNT
Select location, 
MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent = 'Africa'
group by location
order by TotalDeaths desc

-- saving in a view
create view DeathRate as
Select location, 
MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent = 'Africa'
group by location

--COUNTRY WITH THE HIGHEST DEATH COUNT GLOBALLY
Select location, 
MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeaths desc


-- LOOKING AT TOTAL POPULATION VS VACCINATION
-- Joining the the CovidDeaths and CovidVaccinations tables
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Order by dea.location, dea.date

-- Vaccinated Population in each Country --
Select 
dea.location,
dea.population,
MAX(dea.total_cases) as TotalCases,
SUM(cast(vac.new_vaccinations as int)) as VaccinatedPop
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Africa' 
and vac.new_vaccinations is not null
Group by dea.location, dea.population
order by VaccinatedPop Desc

-- TOTAL POPULATION vs VACCINATIONS IN AFRICA 

-- Using CTE to perform the calculation
with PopvsVac (Location, Population, TotalCases, VaccinatedPop)
as (
Select 
dea.location,
dea.population,
MAX(dea.total_cases),
SUM(cast(vac.new_vaccinations as int))
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Africa' 
and vac.new_vaccinations is not null
Group by dea.location, dea.population)
select *, (PopvsVac.VaccinatedPop/Population)*100 as PercentVaccinatedPop
From PopvsVac
order by PercentVaccinatedPop Desc

--- creating temp table
create table percentvacpop
(
Location nvarchar(255),
Population numeric,
TotalCases numeric,
Vaccinatedpop numeric
)

Insert into percentvacpop
Select 
dea.location,
dea.population,
MAX(dea.total_cases),
SUM(cast(vac.new_vaccinations as int))
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Africa' 
and vac.new_vaccinations is not null
Group by dea.location, dea.population
Order by dea.location

Select *, (VaccinatedPop/Population)*100 as PercentVac
From percentvacpop

-- making changes to the temp table -- You can use the 'drop table if exist table_name --

-- CREATING VIEWS TO STORE DATA FOR VIZ
-- view1
create view percentvaccinationpop as
Select 
dea.location,
dea.population,
MAX(dea.total_cases) as TotalCases,
SUM(cast(vac.new_vaccinations as int)) as TotalVac
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Africa' 
and vac.new_vaccinations is not null
Group by dea.location, dea.population


