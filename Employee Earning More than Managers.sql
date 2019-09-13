
-- leetcode 181. employee earning more than their managers

-- 1 employee could have multiple managers or none at all
-- 1 manager could have multiple employees


-- get manager's salary
SELECT
e.Name as Employee
from employee as e 
    left join employee as m on e.ManagerId = m.Id
where e.Salary>m.Salary
    