

-- leetcode 596. classes more than 5 students

-- students must not be counted distinct

select 
    class
    --,count(student) as headcount
from courses
group by class
having count(distinct student) >=5