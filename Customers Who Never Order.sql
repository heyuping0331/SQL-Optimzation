
-- leetcode 183 customer who never order anything

-- 0 order

select 
    c.Name as Customers
from Customers c left join Orders o on c.Id = o.CustomerId
where o.CustomerId is null