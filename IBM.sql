
--/ in this analysis i'm going to answer an important questions

--/ Q: WHY DOES THE EMPLOYEES LEAVE THE COMPANY??
--/	to answer this question we first need to understand and breakdown our employees


--1 no. of employees, avg. age and gender
select
		Gender,
		COUNT([Employee ID]) as total_employees,
		round(AVG(Age),2)as avg_age
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Gender
--# the avg age is 36.5 years which is considerd good.

--2 departments and job role
select
		Department,
		JobRole,
		count(JobRole) as total_employees
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Department,JobRole
order by
		1,3 desc
--# we have 3 departments and 8 job role and 3 Manager role.
--# Research & Development have the highest employee count.

--3 avg. distance from home
select
		avg(DistanceFromHome) as avg_distance
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
--# 9.19km is the avg. distance from employee's home to work which is considerd low distance.

--4 educational level
select
		Education ,
		count(Education) as total_employees
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Education
--# nice spread of educational level

--5 total monthly income for each department with and without salary hike
select
		Department,
		SUM(old_salary) as total_old_monthly_income,
		SUM(new_salary) as total_new_monthly_income,
		round(100-(SUM(old_salary)/SUM(new_salary)*100),2) as salary_hike_percentage
from
(
select
		[Employee ID],
		Department,
		cast(MonthlyIncome as int) as old_salary,
		round(MonthlyIncome*(1+PercentSalaryHike),0) as new_salary
from	
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
) as salary
group by
		Department

--6 avg. working exp. for employees
select
		round(avg(TotalWorkingYears),2) as avg_working_exp
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]



--/ after I laid out the basis I will try to answer the important question

--/ i think the answer to the question will be reveled by comparing between the employees that stayed and the ones who left.

--1 total employees that left
select
		Attrition,
		COUNT(Attrition) as total_employees,
		count(*) * 100.0 / sum(count(*)) over() as Percent_of_total
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Attrition
--# 16.12% of our employees have left the company so lets find why??

--2 salary per year of exp for each role
select
		Attrition,
		round(avg(TotalWorkingYears),2) as avg_exp_year,
		cast(avg(MonthlyIncome) as int) as avg_MonthlyIncome ,
		round(cast(avg(MonthlyIncome) as int)/avg(TotalWorkingYears),2) as avg_salary_per_exp_year
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Attrition
--# the most obvious reason that mau cause an employee to leave is the salary but from this analysis we can see that avg_salary_per_exp_year
--# are nearly the same (slightly higher within people who left the company).
--# the thing to note here is that salary may be not the only reason why employees leave.


--3 EnvironmentSatisfaction, JobSatisfaction, JobInvolvement and RelationshipSatisfaction
select
		Attrition,
		avg_EnvironmentSatisfaction_score,
		case 
			when avg_EnvironmentSatisfaction_score = 2 then 'medium'
			when avg_EnvironmentSatisfaction_score = 3 then 'high'
			else 'low'
		end as EnvironmentSatisfaction_status,
		avg_JobSatisfaction_score,
		case 
			when avg_JobSatisfaction_score = 2 then 'medium'
			when avg_JobSatisfaction_score = 3 then 'high'
			else 'low'
		end as JobSatisfaction_status,
		avg_JobInvolvement_score,
		case 
			when avg_JobInvolvement_score = 2 then 'medium'
			when avg_JobInvolvement_score = 3 then 'high'
			else 'low'
		end as JobInvolvement_status,
		avg_RelationshipSatisfaction_score,
		case 
			when avg_RelationshipSatisfaction_score = 2 then 'medium'
			when avg_RelationshipSatisfaction_score = 3 then 'high'
			else 'low'
		end as RelationshipSatisfaction_status,
		avg_WorkLifeBalance_score,
		case 
			when avg_WorkLifeBalance_score = 2 then 'medium'
			when avg_WorkLifeBalance_score = 3 then 'high'
			else 'low'
		end as WorkLifeBalance_status
from
(
select
		Attrition,
		round(avg(EnvironmentSatisfaction),0) as avg_EnvironmentSatisfaction_score,
		round(avg(JobSatisfaction),0) as avg_JobSatisfaction_score,
		round(avg(JobInvolvement),0) as avg_JobInvolvement_score,
		round(avg(RelationshipSatisfaction),0) as avg_RelationshipSatisfaction_score,
		round(avg(WorkLifeBalance),0) as avg_WorkLifeBalance_score
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Attrition
) as score
--# we notice that left employees have lower (EnvironmentSatisfaction) and (JobSatisfaction) than the remained employees 
--# which support my theory than salary is not the only factor for employees to leave.
--# (JobInvolvement) and (RelationshipSatisfaction) as we can see in the data that JobInvolvement_status is the same in both groups.
--# there's a decrease in WorkLifeBalance status which affect all the employees and may be a contributing factore in leaving .
--# WorkLifeBalance should be foucsed on and dealed with immediately.

--4 YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager
select
		Attrition,
		round(avg(YearsInCurrentRole),2) as avg_YearsInCurrentRole,
		round(avg(YearsSinceLastPromotion),2) as avg_YearsSinceLastPromotion,
		round(avg(YearsWithCurrManager),2)as avg_YearsWithCurrManager
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Attrition
--# YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager are definitely not a causing factor for employees to leave.

--6 NumCompaniesWorked
select
		Attrition,
		avg(NumCompaniesWorked) as avg_NumCompaniesWorked
from
		[IBM HR Analytics]..[WA_Fn-UseC_-HR-Employee-Attriti]
group by
		Attrition	
--# we see that the employees who left the company have higher tendancy to leave as the avg number of companies they worked in is higher than the employees that stayed.


--## in conclusion I can see that there's no major factor causing people to leave but (worklife balance) have big impact on all employees 
--## and (EnvironmentSatisfaction), (JobSatisfaction) and (NumCompaniesWorked) are leading factor to the problem.