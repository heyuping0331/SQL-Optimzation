
/*

Session table:
|Date, sessionid, userid, action (login/exit/logout) | -- can be duplicated

Time table:
|Date, Sessionid, time_spent (s)|  --date,session_id primary keys.

*/


-- Q1: Average sessions/user per day within the last 30 days

-- # sessions, # users <-- user_id, session_id, date



-- Q2: generate number of user per n seconds. in order to measure how many user is spending certain amount of time.


-- user_id, time_spend, time_interval --> group by time_interval --> count distinct(user_id)



-- Q3: Average time spent on session per user within the last 30 days

-- user_id, # time spent, # sessions


-- Q4. Plot the histogram of avg(time_spent). 

-- user_id, # time spent, # sessions, avg =# time spent/# sessions

-- How do you know within certain time period, how many people are in there?

-- Q5 :Problem with previous results (Not all users are included)?

-- Q6: daily active user for the past 30 days

-- active meaning 10s, 30s???
-- user_id, active days --> count()

with base as (

    select 
        s.user_id
        ,count(distinct s.date) as days_active
    from SESSION s left join time t 
    on s.session_id = t.session_id
    where t.time_spend >10
        and s.date between curdate()-30 and curdate()
    group by 1
)

select 
    count(user_id) as actives_daily
from base
where days_active>30