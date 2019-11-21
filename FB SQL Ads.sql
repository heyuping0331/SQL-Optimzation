
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
        ,sum(a.spend) as spend_total_by_adv -- biased towards advertisers with more ads
    from ad_info a left join adv_info b on a.ad_id = b.ad_id
    group by 1) as base
group by 1
order by 1

-- 5.3 what fraction of advertisers has at least one conversion?



-- advertiser_id, ad_id, conversion (price>0) --> count(ad_id)


select 
    count(distinct a.advertiser_id) as total_advertisers
    ,count(distinct case when price not null then a.advertiser_id else null end) as conversion_advertisers
    , conversion_advertisers / total_advertisers as fraction
from advertiser a left join ads b 
    on a.ad_id = b.ad_id

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
    
-- 5.4 rentention rate， (find advertisers who bought type c, and did the same the day after)

-- ad_id, ad_yeterday, ad_today, ratio

-- 5.5 ROI per ad

-- ad_id, advertiser_id, total_price, total_spend <-- sum(price) group by ad_id


select
    a.ad_id
    ,a.advertiser_id
    ,a.spend
    ,sum(b.price) as total_price
    ,total_price \ a.spend as ROI
from advertiser a left join ads b 
    on a.ad_id = b.ad_id

group by 1,2,3

-- potential advertisers
ad4ad: date, user_id, event {impression, click, create_ad}, unit_id, cost, spend
记得还有一列，可能是ad_id，event是create_ad对应的行才有数值 

介绍：event有三个值，其中impression就是FB为user创造的广告space，click代表user点进去了，create_ad代表user点进去之后正式create了ad。
然后cost就是FB为这个user的这个item创造广告space所花费的cost，
spend就是在user create_ad之后pay给FB的，所以只有create_ad那一行的spend不是null

users: user_id, country, age

-- how many impressions before users create an ad given an unit?

-- user_id, unit_id, -- users who created 1+ ads, impressions+create ads --> count(impressions)



-- user_id, unit_id, date_created_ad

with createad as (
    select 
        user_id
        ,unit_id
        ,date as date_create_ad
    from table a 
    where event = 'create_ad'
)

select 
    a.user_id
    ,a.unit_id
    ,count(*) as num_impressions
from table a left join createad c 
    on a.user_id = c.user_id
    and a.unit_id = c.unit_id
where a.event = 'impressions' and a.date<c.date
group by 1