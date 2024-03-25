select *
from public.encounters
where encounterclass = 'outpatient'
or encounterclass = 'ambulatory'
/* can also use where encounterclass in ('outpatient','ambulatory')*/


select description,
	count(*) as count_of_cond
from public.conditions
where description != 'Body Mass Index 30.0-30.9, adult'
group by description
having count(*) > 5000
order by count(*)desc

/* write a query that selects all the patients
from boston*/

Select * from public.patients
where city = 'Boston'

select * from public.conditions
where code in ('585.1','585.2','585.3','585.4')

/* write a query that does the following:
1. Lists out number of patients per city in desc order
2. does not include boston
3. must have at least 100 patients from that city */

select city, count(*) as num_patients
from public.patients
where city != 'Boston'
group by city
having count(*) >= 100
order by count(*) desc



/*
Objectives
Come up with flu shots dashboard for 2022 that does the following

1. Total % of patients getting flu shots stratified by 
a) Age
b) Race
c) County on a map
d) Overall
2. Running total of flu shots over the course of 2022
3. Total number of flu shots given in 2022
4. Alist of Patients that show whether or not they received the flu shots

Requirements:

Patients must have been "Active at our hospital"
*/


with active_patients as
(
	select distinct patient
	from encounters as e
	join patients as pat
	   on e.patient = pat.id
	where start between '2020-01-01 00:00' and '2022-12-31 23:59'
	  and pat.deathdate is null
	  and extract (month from age('2022-12-31',pat.birthdate)) >=6
),	

flu_shot_2022 as
(
select patient, min(date) as earliest_flu_shot_2022
from immunizations
where code = '5302'
and date between '2022-01-01 00:00' and '2022-12-31 23:59'
group by patient 
)
	
select distinct
	extract(YEAR FROM age('12-31-2022',pat.birthdate)) as age,
       pat.ethnicity,
	   pat.gender,
	   pat.race,
       pat.county,
       pat.id,
       pat.first,
       pat.last,
	   flu.patient,
	   flu.earliest_flu_shot_2022,
	   case when flu.patient is not null then 1
	   else 0
	   end as flu_shot_2022
from patients as pat
left join flu_shot_2022	 as flu
on pat.id = flu.patient
where 1=1
and pat.id in (select patient from active_patients)


       
