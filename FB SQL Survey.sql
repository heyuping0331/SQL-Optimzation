



-- 3. Survey Log

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
