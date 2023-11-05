CREATE DATABASE projects;
use projects;
SELECT * FROM hr;

-- changing name of column ï»¿id to emp_id
alter table hr
change column ï»¿id emp_id varchar(20) Null;

DESCRIBE HR;

-- changing the birthdate column so that it aligns with date and time
SELECT birthdate FROM hr;
UPDATE hr
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%y'), '%Y-%m-%d')
else NULL 
end;
# setting brithdate to date
ALTER TABLE hr
modify column birthdate DATE;

# changing hire_date
UPDATE hr
SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%y'), '%Y-%m-%d')
else NULL 
end;
SELECT hire_date FROM hr;
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

# correcting termdate

SELECT termdate from hr;


UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


ALTER TABLE hr add column age INT;
SELECT  * FROM hr;

update hr
set age = timestampdiff(YEAR,birthdate, CURDATE());
select birthdate, age from hr;

SELECT 
MIN(AGE) as youngest, max(age) as oldest
from hr;


SELECT COUNT(*) FROM HR WHERE AGE<18;


# ########DATA ANALYSIS############
# What is the gender breakdown for the company?
SELECT gender, count(*)
 as count
 from hr
 where age>=18 and termdate='0000-00-00'
 group by gender;
 
# what is the race and ethnicituy breakdown of the employees in the company?
select race, count(*) as count
from hr
 where age>=18 and termdate='0000-00-00'
group by rACE
ORDER BY COUNT(*) DESC;

## WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES IN THE COMPANY
select 
min(age) as youngest,
max(age) as oldest
from hr
 where age>=18 and termdate='0000-00-00';
 
select 
case
when age>=18 and age<= 24 then '18-24'
when age>=25 and age<= 34 then '25-34'
when age>=35 and age<= 44 then '35-64'
when age>=45 and age<= 54 then '45-54'
when age>=55 and age<= 64 then '55-64'
else '65+'
end as age_group,
count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by age_group
order by age_group;

select 
case
when age>=18 and age<= 24 then '18-24'
when age>=25 and age<= 34 then '25-34'
when age>=35 and age<= 44 then '35-64'
when age>=45 and age<= 54 then '45-54'
when age>=55 and age<= 64 then '55-64'
else '65+'
end as age_group, gender,
count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by age_group, gender
order by age_group, gender;


###HOW MANY EMPLOYEES WORK AT HEADQUARTERS VERSUS REMOTE LOCATIONS?

SELECT location , count(*) as count from hr
where age>=18 and termdate='0000-00-00'
group by location;

# whatt is the average length of employment who has been termindated?
SELECT 
round(avg(datediff(termdate, hire_date))/365) as avg_length_employment
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age>=18;

####Gender distribution of job titles across the company?
select department, gender, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by department, gender
order by department;

# what is the distribution of job titles across the company
select jobtitle, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by jobtitle
order by jobtitle desc;

###which department has highest turnover rate?
select department,
total_count, terminated_count, terminated_count/total_count as termination_rate
from (
select department,
count(*) as total_count,
sum(case when termdate <>'0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age >= 18
group by department
) as subquery
order by termination_rate desc;


#### what is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr
where age>=18 and termdate='0000-00-00'
group by location_state
order by count desc;


##### how has company emplyee oount changed overtime based on hire and and term date?
select 
year, hires, terminations, hires - terminations as net_change,
round((hires - terminations)/hires * 100,2) as net_change_percentage
from (
select year(hire_date) as year, count(*) as hires, sum(case when termdate<>"0000-00-00" and curdate() then 1 else 0 end) as terminations
from hr
where age >=18
group by year(hire_date)
) as subquery
order by year asc;

###what is the tenure distribution for each department?
select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate  <> '0000-00-00' and age>=18
group by department;





