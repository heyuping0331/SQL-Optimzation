


-- composer: userid | date | action (enter,post,cancel) -- per post?
-- user:    userid | date | country | DAU(0, 1)


-- 1）rate of success posts each day last week

-- day, success posts, total posts

with base as (
    SELECT
        date
        ,count(*) as posts_total
        ,sum(case when action = 'post' then 1 else 0 end) as posts_success
    from composer
    where 
        and date between curdate()-7  and curdate()
    group by 1
    order by 1
)

select 
    date
    ,posts_success/posts_total as rate_success
from base


-- 2）avg # success posts of daly-active user per contry today

-- post, user_id, country, date --> group by country --> count(posts) / count(user)

select 
    u.country
    ,count(*) / count(distinct uer_id) as avg_posts

from composer c left join user u on c.user_id = u.user_id
where date = curdate() 
    and DAU=1
    and c.action = 'post'
group by 1



-----------------------------------------------------------------------------------------------------------------------

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

