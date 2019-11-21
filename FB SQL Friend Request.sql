

-- 1. friend request accepetance rate


-- # acceptances / # requests
-- assume each request is unique

-- request, acceptance/no


select 
    count(distinct sender_id, send_to_id) as total_requests
    ,count(distinct requester_id, accepter_id) as total_acceptance
    ,round(total_acceptance / total_requests,2) as acceptance_rate

from friend_request r outer join request_accepted a
    on r.sender_id=a.requester_id and r.send_to_id = a.accepter_id


-- 2. return users with the most friends


-- user_id (requester | accepter) --> groupby user_id --> count() --> return 1st

with base as (

    select  
        requester_id as user_id
        ,accept_date
    from request_accepted

    union all 

    select  
        accepter_id as user_id
        ,accept_date
    from request_accepted

)

select 
    user_id
    ,count(accept_date) as num_friends
    ,rank() over(partition by user_id order by num_friends desc) as rank
from base
group by 1

-- where rank=1

