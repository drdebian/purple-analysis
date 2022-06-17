with ctea1 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'car1' as vehicle,
        a.*
    from car1 a
),
ctea2 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'car2' as vehicle,
        a.*
    from car2 a
),
ctea3 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'car3' as vehicle,
        a.*
    from car3 a
),
ctea4 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'car4' as vehicle,
        a.*
    from car4 a
),
ctea5 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'car5' as vehicle,
        a.*
    from car5 a
),
cteb1 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'station1' as station,
        a.*
    from charger1 a
),
cteb2 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'station2' as station,
        a.*
    from charger2 a
),
cteb3 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'station3' as station,
        a.*
    from charger3 a
),
cteb4 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'station4' as station,
        a.*
    from charger4 a
),
cteb5 as (
    select datetime(
            strftime('%Y-%m-%d %H:00:00', a.TimeDate),
            cast(
                cast(strftime('%M', a.TimeDate) * 4 / 60 + 1 as int) * 60 / 4 as string
            ) || ' minutes'
        ) as TimeDate15m,
        'station5' as station,
        a.*
    from charger5 a
),
cte0 as (
    select a.vehicle, 
        a.TimeDate15m as [timestamp],
        max([id]) as [id],
        max([status]) as [status],
        round(avg(coalesce([stateOfCharge], 0)), 0) as [stateOfCharge],
        count(*) as cntMeasurements
    from ctea1 a
    group by a.TimeDate15m
    union
    select a.vehicle, 
        a.TimeDate15m as [timestamp],
        max([id]) as [id],
        max([status]) as [status],
        round(avg(coalesce([stateOfCharge], 0)), 0) as [stateOfCharge],
        count(*) as cntMeasurements
    from ctea2 a
    group by a.TimeDate15m
    union
    select a.vehicle, 
        a.TimeDate15m as [timestamp],
        max([id]) as [id],
        max([status]) as [status],
        round(avg(coalesce([stateOfCharge], 0)), 0) as [stateOfCharge],
        count(*) as cntMeasurements
    from ctea3 a
    group by a.TimeDate15m
    union
    select a.vehicle,
        a.TimeDate15m as [timestamp],
        max([id]) as [id],
        max([status]) as [status],
        round(avg(coalesce([stateOfCharge], 0)), 0) as [stateOfCharge],
        count(*) as cntMeasurements
    from ctea4 a
    group by a.TimeDate15m
    union
    select a.vehicle, 
        a.TimeDate15m as [timestamp],
        max([id]) as [id],
        max([status]) as [status],
        round(avg(coalesce([stateOfCharge], 0)), 0) as [stateOfCharge],
        count(*) as cntMeasurements
    from ctea5 a
    group by a.TimeDate15m
),
cte1 as (
    select a.station,
        a.TimeDate15m as [timestamp],
        round(avg(coalesce([activePower-W], 0)), 0) as [activePower-W],
        max(coalesce([state], 0)) as [state],
        count(*) as cntMeasurements
    from cteb1 a
    group by a.TimeDate15m
    union
    select a.station,
        a.TimeDate15m as [timestamp],
        round(avg(coalesce([activePower-W], 0)), 0) as [activePower-W],
        max(coalesce([state], 0)) as [state],
        count(*) as cntMeasurements
    from cteb2 a
    group by a.TimeDate15m
    union
    select a.station,
        a.TimeDate15m as [timestamp],
        round(avg(coalesce([activePower-W], 0)), 0) as [activePower-W],
        max(coalesce([state], 0)) as [state],
        count(*) as cntMeasurements
    from cteb3 a
    group by a.TimeDate15m
    union
    select a.station,
        a.TimeDate15m as [timestamp],
        round(avg(coalesce([activePower-W], 0)), 0) as [activePower-W],
        max(coalesce([state], 0)) as [state],
        count(*) as cntMeasurements
    from cteb4 a
    group by a.TimeDate15m
    union
    select a.station,
        a.TimeDate15m as [timestamp],
        round(avg(coalesce([activePower-W], 0)), 0) as [activePower-W],
        max(coalesce([state], 0)) as [state],
        count(*) as cntMeasurements
    from cteb5 a
    group by a.TimeDate15m
), cte2 as
(select b.*,
    b.stateOfCharge - LAG(b.stateOfCharge, 1, b.stateOfCharge) over (
        partition by b.vehicle
        order by b.vehicle,
            b.timestamp
    ) as chgSOC,
    coalesce(c.[activePower-W], 0) as [activePower-W],
    coalesce(c.[state], 0) as [state]
from cte0 b
    left join cte1 c on c.timestamp = b.timestamp
    and substr(c.station, length(c.station), 1) = substr(b.vehicle, length(b.vehicle), 1)
)
select 
 a.vehicle
,a.timestamp
,a.status
,a.state
,a.[activePower-W]
,a.stateOfCharge
,a.chgSOC
,case when (a.state = 7 
			or a.[activePower-W] > 0 
			or a.chgSOC > 0) 
	   and not a.status in ('moving', 'ride')
      then 1
	  else 0
 end as 'charging'
,case when (a.state > 0 
			or a.[activePower-W] > 0 
    		)
	   and not (a.status in ('moving', 'ride') or a.chgSOC < 0 )
      then 1
	  else 0
 end as 'loadable'
,case when (a.status in ('moving', 'ride') or a.chgSOC < 0 ) and a.state < 7
      then 1
	  else 0
 end as 'driving'
from cte2 a

  