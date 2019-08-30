-- leetcode databse 176 Second Highest Salary

-- difficulties:
-- 1) return multiple salaries all rank 2nd highest
-- 2) possible that there's only 1 rank in the dataset 


-- solution 1
select ifnull(
    (select 
        distinct Salary
    from Employee
    order by Salary desc
    limit 1 offset 1)
    ,null
) as SecondHighestSalary

-- solution 2: won't work due to 2)
with salary_rank as (
    select 
        Salary
        ,rank() over(order by Salary desc) as rank
    from Employee
)
select ifnull(
    (select 
        distinct Salary as SecondHighestSalary
    from salary_rank
    where rank=2)
    ,NULL
) as SecondHighestSalary





