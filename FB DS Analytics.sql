-- Facebook Data Scientist, Analytics 
-- SQL questions

-- 5. Ecommerce Ads
-- adv_info: | advertiser_id| ad_id| spend|        
-- ad_info: |ad_id | user_id | price

-- assuming all prices>0 

-- 5.1 what would an avg advertiser spend on FB?


-- each ad conversion (per user) with spend and revenue

select 
    avg(base.spend_total_by_ad) as spend_avg_by_adv
from 
    (select 
        b.advertise_id
        ,sum(a.spend) as spend_total_by_adv
    from ad_info a left join adv_info b on a.ad_id = b.ad_id
    group by 1) as base

-- 5.2 what will the distribution of ad spend by advertiser look like?

-- $$ ad spend by advertiser, count(*)
-- advertiser, $$ ad spend

select
    base.spend_total_by_adv
    ,count(base.advertiser_id) as count
from 
    (select 
        b.advertise_id
        ,sum(a.spend) as spend_total_by_adv
    from ad_info a left join adv_info b on a.ad_id = b.ad_id
    group by 1) as base
group by 1
order by 1

-- 5.3 what faction of advertisers has at least one conversion?

select
    sum(case when conversions>0 then 1 else 0 end) / count(advertiser_id) as answer
from 
    (
    -- advertiser, # conversion
    select 
        a.advertiser_id
        ,ifnull(count(b.user_id),0) as conversions
    from adv_info a left join ad_info b on a.ad_id = b.ad_id
    group by 1
    ) base
    

-- 4. Interactions: i.e., messaging
-- a table of interaction between 2 users
-- | user_a | user_b | day |
-- assuming only 1 interaction between a pair of users on a given date


-- 4.1


-- 4.2 # of users who had more than 5 interactions yesterday

-- scenario 1
with base1 as (
    select 
        user_a as user
        ,count(*) as nbr_interaction
    from table
    where day='2019-09-29'
    group by 1
    having count(*)>5
)
, base2 as (
    select 
        user_b as user
        ,count(*) as nbr_interaction
    from table
    where day='2019-09-29'
    group by 1
    having count(*)>5
)

select 
    base1.user
    ,base2.user
    ,case when then else end as user_all
    ,ifnull(base1.nbr_interaction,0) + ifnull(base2.nbr_interaction,0) as nbr_interaction_total

from base1 outer join base2 on base1.user = base2.user


-- 3. Ads

-- 3.1 click-thru-rate: # clicks / # impressions

select 
    sum(case when event='click'then 1 else 0 end) as clicks
    ,sum(case when event='click' then 1 else 0 end) as impressions
    , clicks/impressions as ctr
from log_table


-- 3.2 CTR > 1, why?

-- data quality issue
-- 1 impression generates multiple clicks



-- 3.3 an impression could have several clicks --> how to filter out the correct click


-- 3.4 group1 CTR 10%, group2 CTR 15% --> why such difference?






-- 2. Facebook / instagram posts

-- 2.1 comment distribution per post


-- content_id, content type: post, content_id:{null, content_id1, content_id2, ....}

with base as (
    select 
        post.content_id as id_post
        ,ifnull(count(comment.content_id), 0) as nbr_comments
    from table as post
        left join table as comment on post.content_id = comment.target_id
    where post.content_type = 'post'
    group by 1
    )

-- calculate distribution
select
    nbr_comments
    ,count(id_post) as count
from base
group by 1
order by 1 asc

-- 2.2 comment distribution by each content type: post, video, photo, article

with base as (
    select 
        post.content_id as id_post
        ,post.content_type
        ,ifnull(count(comment.content_id), 0) as nbr_comments
    from table as post
        left join table as comment on post.content_id = comment.target_id
    where post.content_type in ('post','video','photo','article')
    group by 1,2
    )

-- calculate distribution
select
    content_type
    ,nbr_comments
    ,count(id_post) as count
from base
group by 1,2
order by 1,2 asc

-- 2.3 comment distribution for stories; story is either a post or video. 


with base as (
    select 
        post.content_id as id_post
        ,ifnull(count(comment.content_id), 0) as nbr_comments
    from table as post
        left join table as comment on post.content_id = comment.target_id
    where post.content_type ('post', 'video')
    group by 1
    )

-- calculate distribution
select
    nbr_comments
    ,count(id_post) as count
from base
group by 1
order by 1 asc

-- 2.4 how do you determine if a comment is meaningful and conversational?

--ideation/intuition
--metrics


-- 1. a table that tracks every time a user turns a feature on or off, 
-- with columnsuser_id, action ("on" or "off), date, and time.
-- USER_ID | ACTION | DATE| TIME

-- 1.1 how many users turned the feature on today?

select 
    COUNT(DISTINCT USER_ID)  
FROM TABLE
WHERE DATE = CURDATE()
    AND ACTION = 'on';

-- 1.2 Create a table that tracks the user last status every day.

-- table b: calendar look up table

-- table a: each date, user_id, status

--  each date, user_id, last_status


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

-- 1.4 returns users who has the feature on all day (given table_status and table_action).
-- whose last status by the end of yestersay is on, no action today
-- assuming we are talking about today


select 
    date
    ,counta.user_id


from table_action a left join table_status s 
    on a.user_id = b.user_id 
        and s.date = curdate()-1

where s.status = 'on' 
    and a.date = curdate()

group by 1
having