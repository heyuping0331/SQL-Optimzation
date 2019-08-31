
-- leetcode 620 Not Boring Movies

SELECT
    *
from cinema
where 
    description <> 'boring'
    and id%2 <> 0
order by rating desc
