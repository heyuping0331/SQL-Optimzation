-- Facebook Data Scientist, Analytics 
-- SQL questions


-- 1. a table that tracks every time a user turns a feature on or off, 
-- with columnsuser_id, action ("on" or "off), date, and time.
-- USER_ID | ACTION | DATE| TIME

-- default: on

-- 1.1 how many users turned the feature on today?

select 
    COUNT(DISTINCT USER_ID)  
FROM TABLE
WHERE DATE = CURDATE()
    AND ACTION = 'on';

-- 1.2 Create a table that tracks the user last status every day.



-- user_id, date, last_status （on, off): most recent action

-- users who have action today (last action today) + users who have action today (most recent action)

with action_today as (
    select
        user_id
        ,date
        ,action
        ,row_number() over(partition by user_id order by time desc) as rank
    from action_table
    where date = curdate()
)
, action_all as (
    select 
        user_id
        --,date
        ,action
        ,row_number() over(partition by user_id order by date, time desc) as rank
    from action_table
)

select 
    user_id
    ,date
    ,action
from action_today
where rank=1

union 

select 
    user_id
    ,curdate() as date
    ,action
from action_all
where rank=1


-- 1.3 In a table that tracks the status of every user every day, how would you add today's data to it?  
/*ASSUMING ACCOUNTS KEY ARE UNIQUE IN TABLE_TODAY */
/*OTHERWISE WE CAN PICK THE LAST ACTION IN TODAY AS THE STATUS*/

SELECT A.*
FROM EVERYDAY_SATUS
UNION
(
    SELECT  
        COALESCE(A.USER_ID,B.USER_ID) AS USER_ID
        ,CASE WHEN A.USER_ID IS NULL THEN B.STATUS
            WHEN A.USER_ID IS NOT NULL AND B.USER_ID IS NULL THEN A.ACTION
            WHEN A.USER_ID IS NOT NULL AND B.USER_ID IS NOT NULL THEN A.ACTION
            END ASSTATUS
        ,CURDATE()AS DATE
    FROM TABLE_TODAY A FULL OUTER JOIN TABLE_EVERYDAY B
    WHERE A.USER_ID = B.USER_ID
        AND B.DATE= CURDATE()-1

);

-- 1.3 returns users who has the feature on all day (given table_status and table_action).
-- logic: whose last status by the end of yestersay is on, no action today
-- assuming we are talking about today

select 
    distinct a.user_id
from table_status s left join table_action a
    on a.user_id = b.user_id 
        and a.date = curdate()
where s.status = 'on' 
    and s.date= curdate()-1
    and s.user_id is null
