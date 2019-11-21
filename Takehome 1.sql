

-- Query 6

-- data: user_id | created_at | country

-- The country with the largest and smallest number of users

-- country, user_count
with base as (
    select 
        country
        ,count(user_id) as user_count
        ,rank() over(partition by country order by user_count asc) as rank_asc
        ,rank() over(partition by country order by user_count desc) as rank_desc
    from data
    group by 1
)

select 
    country
from base
where rank_asc=1 or rank_desc=1

-- for each country, find the first and the last user who signed up (if that country has just one user, 
-- it should just return that single user)

with base as (
    select 
        user_id
        ,country
        ,rank() over(partition by country order by created_at asc) as rank_asc
        ,rank() over(partition by country order by created_at desc) as rank_desc
    from data
    group by 1
)

select 
    country
    ,user_id
    ,created_at
from base
where rank_asc=1 or rank_desc=1

--Query 5

-- Find the average and median transaction amount 
-- only considering those transactions that happen on the same date as that user signed-up.

-- signup: user_id | date_signup
-- transaction: user_id | date_transaction | amount

-- user_id, date_signup, date_transaction, amount --> group by 1,2,3 avg(), mod()

select 
    ,avg(amount) as mean
    ,mod(amount) as median ??

from signup s inner join transaction t 
    on s.user_id = t.user_id 
    and s.date_signup = to_date(t.date_transaction)


-- Query 4

-- We have two tables. One table has all $ transactions from users during the month of March and one for the month of April.
-- return the total amount of money spent by each user. That is, the sum of the column transaction_amount for each user over both tables.
-- return day by day the cumulative sum of money spent by each user until current date

-- table_march: | user_id | date | transaction_amount
-- table_april: | user_id | date | transaction_amount

-- user_id, date, total_spend, cumulative_daily_spend

with base as (
    select * from table_march
    union ALL
    select * from table_april
)

SELECT
    user_id
    ,date 
    ,sum(transaction_amount) as total_daily
    ,sum(total_daily) over(partition by user_id rows between unbounded preceding and unbounded following) as total_spend
    ,sum(total_daily) over(partition by user_id, date order by user_id, date asc) as cumulative_daily_spend
from base
group by 1,2
order by 1,2


-- Query 3
-- find power users: people became power users on the day they bought 10+ items


-- table: user_id | date

-- user_id, date, item_count --> item_count = 10

with base as (
    select 
        user_id
        ,date
        ,row_number() over (partition by user_id order by date asc) as item_count
    from table
)

select 
    user_id
    ,date
from base
where item_count = 10




-- Query 2

-- We have two tables. One table has all mobile actions, i.e. all pages visited by the users on mobile. 
-- The other table has all web actions, i.e. all pages visited on web by the users.
-- Write a query that returns the percentage of users who only visited mobile, only web and both. 
-- That is, the percentage of users who are only in the mobile table, only in the web table and in both tables. 
-- The sum of the percentages should return 1.


-- table_mobile: user_id | page
-- table_web: user_id | page

-- perc of mobile vs web vs both

-- user_id, mobile_visits, web_visits, mobile_web_visits --> count(case when user_id) / count(user_id)

with base as (
    select 
        case when m.user_id is null then w.user_id else m.user_id end as user_id
        ,ifnull(count(m.page),0) as mobile_visits
        ,ifnull(count(w.page),0) as web_visits

    from table_mobile m outer join table_web w 
        on m.user_id = w.user_id
    group by 1
)

select 
    count(case when mobile_visits>0 and web_visits=0 then user_id else null end) / count(user_id) as mobile
    ,count(case when mobile_visits>0 and mobile_visits=0 then user_id else null end) / count(user_id) as web
    ,count(case when mobile_visits>0 and mobile_visits>0 then user_id else null end) / count(user_id) as both

from base

--- Query 1
-- for each user, find the difference between last action and 2nd last
-- remove user with <2 actions or keep as null



-- logicall easier
-- produce rank based on timestamp
with base as (
    select 
        user_id
        --,page 
        ,unix_timestamp
        ,row_number() over (partition by user_id order by unix_timestamp desc) as action_order
    from action
)
-- userid, last action, 2nd last action --> take difference
select 
    user_id
    ,max(unix_timestamp) as timestamp_action_last
    ,min(unix_timestamp) as timestamp_action_2nd_last
    ,timestamp_action_last-timestamp_action_2nd_last as difference
from base
group by 1
where rank <=2
having count(*)>1 -- filter out users with fewer than 2 actionss



-- computationally better

-- produce rank based on timestamp
with base as (
    SELECT user_id
            ,unix_timestamp
            ,LAG(unix_timestamp, 1) OVER (PARTITION BY user_id ORDER BY unix_timestamp) AS previous_time
            ,ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY unix_timestamp DESC) AS order_desc
     FROM table
)

SELECT user_id
    ,unix_timestamp - previous_time AS Delta_SecondLast0ne_LastOne
FROM base
WHERE order_desc = 1

-- user_id, last_action, 2nd last action



