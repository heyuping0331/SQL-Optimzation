
-- leetcode 184 Department Highest Salary

with department_highest as (
    select 
        DepartmentId
        ,max(Salary) as highest_sal
    from  Employee
    group by DepartmentId
)
select 
    d.Name as Department
    ,e.Name as Employee
    ,e.Salary
from Employee e 
    inner join Department d on e.DepartmentId= d.Id
    inner join department_highest h on d.Id= h.DepartmentId and e.Salary= h.highest_sal
    