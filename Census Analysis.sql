create database census;
use census;
select * from pop;
select * from lit;
# Number of rows in dataset 
select count(*) from lit;
select count(*) from pop;

# Total population
select sum(population) as total_population from pop;

# Average Sex Ratio by States
select state ,round(avg(Sex_Ratio),0) as avg_sex_ratio from lit group by state;

# Top 3 States having highest average Growth rate 
select state ,round(avg(growth) * 100,2) as avg_growth from lit group by state order by round(avg(growth) * 100,2) desc limit 3;

# Bottom 3 States having lowest average Growth rate 
select state ,round(avg(growth) * 100,2) as avg_growth from lit group by state order by round(avg(growth) * 100,2) limit 3;

# Top 3 States having highest average Sex Ratio 
select state ,round(avg(Sex_Ratio),0) as avg_sex_ratio from lit group by state order by round(avg(Sex_Ratio),0) desc limit 3;

# Bottom 3 States having lowest average Sex Ratio
select state ,round(avg(Sex_Ratio),0) as avg_sex_ratio from lit group by state order by round(avg(Sex_Ratio),0)  limit 3;

# Top 3 States having highest average literacy rate
select state ,round(avg(Literacy),0) as avg_literacy_ratio from lit group by state order by round(avg(Literacy),0) desc limit 3;

# Bottom 3 States having lowest average literacy rate 
select state ,round(avg(Literacy),0) as avg_literacy_ratio from lit group by state order by round(avg(Literacy),0) limit 3;

# States having average literacy rate > 90
select state ,round(avg(Literacy),0) as avg_literacy_ratio from lit group by state having round(avg(Literacy),0)>90;

# Top And Bottom 3 States with highest and lowest literacy rate
(select state ,round(avg(Literacy),0) as avg_literacy_ratio from lit group by state order by round(avg(Literacy),0) desc limit 3)
union 
(select state ,round(avg(Literacy),0) as avg_literacy_ratio from lit group by state order by round(avg(Literacy),0) limit 3);

# Calculating number of Males & Females for each State 
Select b.state, sum(b.Males) as total_males, sum(b.Females) as total_females from(select district, state, population,Sex_Ratio,round(population/(Sex_Ratio +1),0) as Males, 
round(population-population/(Sex_Ratio +1),0) as Females 
from (select l.district, l.state, l.Sex_Ratio/1000 as Sex_Ratio, p.population from lit l inner join pop p on l.district=p.district) a) b 
group by state; 

# Calculating number of Males & Females for each District
select a.district, a.state, round(a.population/(a.Sex_Ratio +1),0) as Males, round(a.population-a.population/(a.Sex_Ratio +1),0) as Females 
from (select l.district, l.state, l.Sex_Ratio/1000 as Sex_Ratio, p.population from lit l inner join pop p on l.district=p.district) a; 


# Calculating total literate and illiterate population by district
select a.district, a.state, round(a.Literacy_rate * a.population,0) as Total_literate, round((1-a.Literacy_rate) * a.population,0) as Total_illiterate 
from (select l.district, l.state, l.Literacy/100 as Literacy_rate, p.population from lit l inner join pop p on 
l.district=p.district) a; 

# Calculating total literate and illiterate population by state
select b.state, sum(b.total_literate) as Total_literate, sum(b.total_illiterate) as Total_illiterate from (select district, state, round(Literacy_rate * population,0) as Total_literate, 
round((1-Literacy_rate) * population,0) as total_illiterate from (select l.district, l.state, l.Literacy/100 as Literacy_rate, 
p.population from lit l inner join pop p on l.district=p.district) a) b group by state;

# Calculating population of previous year by district
select a.district, a.state, a.growth, a.population, round(a.population/(1+ a.growth),0) as prev_yr_population from 
(Select l.district, l.state, l.growth, p.population from lit l inner join pop p on l.district=p.district) a;

# Calculating population of previous year by state
select b.state, sum(b.population) as curr_yr_population, sum(b.prev_yr_population) as prev_yr_population from 
(select a.district, a.state, a.growth, a.population, round(a.population/(1+ a.growth),0) as prev_yr_population from 
(Select l.district, l.state, l.growth, p.population from lit l inner join pop p on l.district=p.district) a) b group by state;

# Top 3 districts for every state having highest literacy rate
select a.* from (Select state, district, literacy, rank() over(partition by state order by literacy desc) rnk from lit) a 
where rnk <=3 ;