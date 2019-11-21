


-- 4. Interactions: i.e., messaging
-- a table of interaction between 2 users
-- | user_a | user_b | day | interaction type
-- assuming only 1 interaction between a pair of users on a given date


-- 4.1


-- 4.2 # of users who had more than 5 interactions yesterday


-- user_id (interacting or interacted) --> groupby user_id --> having count() >5

with base as (
    (select user_a as user
    from table 
    where day = curdate()-1)

    union all

    (select user_b as user
    from table 
    where day = curdate()-1)
)

SELECT
    user
    ,count(*) as interactions
from base
group by 1
having count(*)>5

-- 4.3 # of top 5 users by # interactions

with base as (
    (select 
        user_a as user
    from table 
    where day = curdate()-1) 
        and interaction_type = 'c'

    union all

    (select user_b as user
    from table 
    where day = curdate()-1)
         and interaction_type = 'c'
)

select 
    user_id
    count(*) as interactions
    ,rank() over (order by interactions desc) as rank
from base
group by 1