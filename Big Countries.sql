

-- leetcode 595 Big Countries


-- A country is big if it has an area of bigger than 3 million square km 
-- or a population of more than 25 million.

-- big countries' name, population and area.

select 
    name
    ,population
    ,area
from world
where area > 3000000 or population >25000000