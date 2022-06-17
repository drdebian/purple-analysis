with ctea1 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.runningdate),
            cast(
                cast(strftime('%M', a.runningdate) * 4 / 60 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as runningdate15m,
        1 as phase,
        a.GridDraw
    from result1 a
	where a.runningdate between '2022-03-07' and '2022-03-14'
	  and a.period = 0
),ctea2 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.runningdate),
            cast(
                cast(strftime('%M', a.runningdate) * 4 / 60 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as runningdate15m,
        2 as phase,
        a.GridDraw
    from result1_rule a
	where a.runningdate between '2022-03-14' and '2022-03-21'
	  and a.period = 0
),ctea3 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.runningdate),
            cast(
                cast(strftime('%M', a.runningdate) * 4 / 60 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as runningdate15m,
        3 as phase,
        a.GridDraw
    from result1_pred a
	where a.runningdate between '2022-03-21' and '2022-03-28'
	  and a.period = 0
),ctea4 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.runningdate),
            cast(
                cast(strftime('%M', a.runningdate) * 4 / 60 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as runningdate15m,
        4 as phase,
        a.GridDrawExpectedValue as GridDraw
    from result1_stoch a
	where a.runningdate between '2022-03-28' and '2022-04-04'
	  and a.period = 0
),cte1 as
(select a.*
 from ctea1 a
 UNION
 select a.*
 from ctea2 a
 UNION
 select a.*
 from ctea3 a
 UNION
 select a.*
 from ctea4 a
)
select a.runningdate15m as runningdate
	, max(a.phase) as phase
	, avg(a.GridDraw) as GridDraw
from cte1 a
group by a.runningdate15m