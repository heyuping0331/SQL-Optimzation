

-- 197. rising temperature

select 
    w.Id
from Weather w left join 
    (select 
        dateadd(day, 1, RecordDate) as RecordDate2
        ,Temperature as Temperature_yesterday
    from Weather 
    ) a
    on w.RecordDate = a.RecordDate2
where w.Temperature > a.Temperature_yesterday