




Table: user_actions

ds (STRING) | user_id (BIGINT) |post_id (BIGINT) |action (STRING) | extra (STRING)
'2018-07-01'| 1209283021       | 329482048384792 | 'view'         |
'2018-07-01'| 1209283021       | 329482048384792 | 'like'         | 
'2018-07-01'| 1938409273       | 349573908750923 | 'reaction'     | 'LOVE'
'2018-07-01'| 1209283021       | 329482048384792 | 'comment'      | 'Such nice Raybans'
'2018-07-01'| 1238472931       | 329482048384792 | 'report'       | 'SPAM'
'2018-07-01'| 1298349287       | 328472938472087 | 'report'       | 'NUDITY'
'2018-07-01'| 1238712388       | 329482048384792 | 'reshare'      | 'I wanted to share with you all'


Table: reviewer_removals （real SPAM）

ds (STRING) | reviewer_id (BIGINT) | post_id (BIGINT) |  
'2018-07-01'| 3894729384729078     | 329482048384792  |                
'2018-07-01'| 8477594743909585     | 388573002873499  | 

-- Q1: How many posts were reported yesterday for each report Reason?

--post_id, action=='report', extra --> group by extra --> count(post_id)

select 
    extra as report_reason
    ,count(distinct post_id)
from user_actions
where ds = dateadd(dat, -1, curdate()) and action='report'
group by 1


-- Q2: What percent of daily content that users view on Facebook is actually Spam? 

-- each date, # total posts, # spams <-- each date, post_id, tag_spam

select  
    a.ds
    ,count(distinct case when then else end) as content_total
    ,count(distinct case when then else end) as content_spam

from user_actions a left join reviewer_removel r
    on a.post_id = r.post_id
where a.action = 'view'
group by 1

-- Q3: How to find the user who abuses this spam system?
-- abuser: users who report many times, whose reports not really spams after inspection
-- user_id, # reports_total, # spams

-- user_id, post_id (reported), spam_tag --> group by user_id, count(distinct)

select 
    a.user_id
    ,count(distinct a.post_id) as reports
    ,count(distinct b.post_id) as spams
    ,spams/reports as true_positive_rate
from user_actions a left join reviewer_removel r
    on a.post_id = r.post_id
where a.action = 'reports'
group by 1
order by 4 asc



-- Q4: What percent of yesterday's content views were on content reported for spam?


