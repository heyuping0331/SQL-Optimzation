
/*
content_action:
    Date,
    User_id (content_creator_id),
    Content_id (this is the primary key),
    Content_type (with 4 types: status_update, photo, video, comment),
    Target_id (it’s the original content_id associated with the comment, if the content type is not comment, this will be null)
*/


-- 1.find the distribution of stories（photo+video）based on comment count? -- each story has multiple comments

-- comment count per story, frequency <-- content_id, content_type(story), # comments


with base as (
    select 
        a.content_id
        ,ifnull(count(b.target_id), 0) as count_comment
    from content_action a left join content_action b
        on a.content_id = b.Target_id
    where a.content_type in ('photo','video')
    group by 1
)

select 
    count_comment
    ,count(*)
from base
group by 1
order by 1 asc

-- 2.what if content_type becomes (comment/ post), what is the distribution of comments?

with base as (
    select 
        a.content_id
        ,ifnull(count(b.target_id), 0) as count_comment
    from content_action a left join content_action b
        on a.content_id = b.Target_id
    where a.content_type in ('photo','video', 'comment')
    group by 1
)

select 
    count_comment
    ,count(*)
from base
group by 1
order by 1 asc

-- 3.Now what if content_type becomes {comment, post, video, photo, article}，what is the comment distribution for each content type?

with base as (
    select 
        a.content_id
        ,a.content_type
        ,ifnull(count(b.target_id), 0) as count_comment
    from content_action a left join content_action b
        on a.content_id = b.Target_id
    where a.content_type in ('photo','video', 'comment')
    group by 1,2
)

select 
    content_type
    ,count_comment
    ,count(*)
from base
group by 1,2
order by 1,2 asc

-- 4.Compute a distribution of number of comments per post, broken up by post type