use relitix;
go

-- ,'AN4283','AN4284'

with cte as (
	select c.County
			,censusplace
			,sum(volume_credit) as total_closings
	from Listings_Combined_For_Volume l
		join listings_combined_geo g
		 on l.sourcesystemid = g.sourcesystemid
			and l.listingkey = g.ListingKey
		join Census_County_Names c
			on g.CountyFP = c.CountyFP
				and g.StateFP = c.State_Num
	where l.sourcesystemid = 11
		and l.office_key in ('AN4282','AN4283','AN4284')
		and closeprice is not null
	group by county, censusplace
--	order by total_closings desc
			),
total as (
	select sum(total_closings) as total from cte 
		)

select coalesce(CensusPlace,concat('Unincorporated ',county,' County')) as Locale
	,total_closings/total.total
from cte, total
order by total_closings desc;




with cte as (
	select c.County
			,censusplace
			,ZNeighborhood
			,sum(volume_credit) as total_closings
	from Listings_Combined_For_Volume l
		join listings_combined_geo g
		 on l.sourcesystemid = g.sourcesystemid
			and l.listingkey = g.ListingKey
		join Census_County_Names c
			on g.CountyFP = c.CountyFP
				and g.StateFP = c.State_Num
	where l.sourcesystemid = 11
		and l.office_key in ('AN4282','AN4283','AN4284')
		and closeprice is not null
	group by county, censusplace, ZNeighborhood
--	order by total_closings desc
			),
total as (
	select sum(total_closings) as total from cte 
		)

select coalesce(CensusPlace,concat('Unincorporated ',county,' County')) as Locale
	,coalesce(ZNeighborhood,'N/A')
	,total_closings/total.total
from cte, total
where ZNeighborhood is not null
order by total_closings desc

