use project_hr_analytics;

# checking number of records in the table HR
select count(*) from HR;

# Description of HR table
desc HR;

#Viewing some rows entry
select * from HR LIMIT 10;

#Finding Null Values
select count(*) from HR where department IS NULL;
select count(*) from HR where jobtitle IS NULL;
select count(*) from HR where age IS NULL;
select count(*) from HR where HIRE_DATE IS NULL;
select count(*) from HR where termdate IS NULL;
select count(*) from HR where location IS NULL;

# finding duplicate records
SELECT id, COUNT(*) FROM HR 
GROUP by id 
HAVING COUNT(*) > 1;

# finding outliers
select * from HR where age < 18 and age >100;


# Create 3 KPI’s that list the number of employees, percent of workers working remotely and in HQ and the average age.
# Number of employees 
select count(*) from HR;
# percent of workers working remotely and in HQ and the average age.

select 
(sum(case when location = "Remote" then 1 else 0 end) * 100 )/ count(*) as per_remote_emp,
(sum(case when location = "Headquarters" then 1 else 0 end) *100) /count(*) as per_headquarters_emp
from HR;

#average age of employees 
SELECT ROUND(AVG(age), 2) AS Average_Age 
FROM HR;

# Retention / Attrition analysis
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate != '' THEN 1 ELSE 0 END) AS total_terminated,
    SUM(CASE WHEN termdate IS NULL OR termdate = '' THEN 1 ELSE 0 END) AS total_active,
    ROUND(
        (SUM(CASE WHEN termdate IS NOT NULL AND termdate != '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2
    ) AS attrition_rate_percentage
FROM HR;

#Retention / attrition rate by department and jobtitle
SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate != '' AND termdate != '0000-00-00' THEN 1 ELSE 0 END) AS terminated_count,
    SUM(CASE WHEN termdate IS NULL OR termdate = '' OR termdate = '0000-00-00' THEN 1 ELSE 0 END) AS active_count,
    ROUND(
        (SUM(CASE WHEN termdate IS NOT NULL AND termdate != '' AND termdate != '0000-00-00' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2
    ) AS attrition_rate_percentage
FROM HR
GROUP BY department
ORDER BY department;

#Gender & Diversity Breakdown
#This query simply counts active employees by department, gender.
SELECT 
    department,
    gender,
    COUNT(*) AS headcount
FROM HR
WHERE termdate IS NULL OR termdate = '' -- Active employees only
GROUP BY department, gender
ORDER BY department, gender;

#query to analyze the workforce distribution across states and cities for your active employees.
SELECT 
    location_state,
    location_city,
    COUNT(*) AS employee_count,
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM HR WHERE termdate IS NULL OR termdate = ''), 2
    ) AS percentage_of_workforce
FROM HR
WHERE termdate IS NULL OR termdate = '' -- Active employees only
GROUP BY location_state, location_city
ORDER BY employee_count DESC;

#Total Count and Percentage of Employees per Department and Job Title
SELECT 
    department,
    jobtitle,
    COUNT(*) AS employee_count,
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM HR WHERE termdate IS NULL OR termdate = ''), 2
    ) AS percentage_of_workforce
FROM HR
WHERE termdate IS NULL OR termdate = '' -- Active employees only
GROUP BY department, jobtitle
ORDER BY department, jobtitle;


#Average tenure of active employees 
SELECT 
    COUNT(*) AS active_employee_count,
    ROUND(AVG(DATEDIFF(CURDATE(), STR_TO_DATE(LEFT(hire_date, 10), '%Y-%m-%d'))), 1) AS avg_tenure_days,
    ROUND(AVG(DATEDIFF(CURDATE(), STR_TO_DATE(LEFT(hire_date, 10), '%Y-%m-%d'))) / 365.25, 1) AS avg_tenure_years
FROM HR
WHERE termdate IS NULL OR termdate = '';


