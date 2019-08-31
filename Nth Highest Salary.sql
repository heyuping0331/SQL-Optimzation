
-- leetcode 177 Nth Highest Salary

-- unresolved

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN

set N=N-1;
  RETURN (
      select IFNULL(  
      (select distinct Salary
      from Employee
      order by Salary desc
      limit 1 offset N), null) 
  );
END