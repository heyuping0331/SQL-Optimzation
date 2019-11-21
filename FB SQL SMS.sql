
/*
sms_message (fb to users)
|    date     |     country    |  cell_numer     | carrier    |      type
|2018-12-06   |        US      |  xxxxxxxxxx     | verizon    | confirmation (ask user to confirm)
|2018-12-05   |         UK     |  xxxxxxxxxx     | t-mobile   |  notification

confirmation (users confirmed their phone number)
|date  |   cell_number |

(User can only confirm during the same day FB sent the confirmation message)

*/


-- 1）Find # confirmations by country, carrier


-- 2) Number of users who received notification every single day during the last 7 days

-- user_id, date, type='notification' --> count(user_id)

with base as(
    select 
        user_id
        ,count(distinct date) as num_days 
    from sms_message
    where 
        date between dateadd(day, -7, curdate()) and curdate()
        and type = 'notification'
    group by 1
    having count(distinct date)=7
)

select count(user_id)
from base

-- 3）confirmation rate past 30 days


-- user_id, date, type{ | } --> count(user_confirmation) / count(all_confirmation)



-- 4）On dec 06th, overall confirmation rate.
