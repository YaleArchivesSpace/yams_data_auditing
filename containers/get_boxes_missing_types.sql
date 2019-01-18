select CONCAT('/repositories/', tc.repo_id, '/top_containers/', tc.id) as tc_uri
	, 'Box' as updated_type_value
	, tc.indicator
	, tc.barcode
	, ev.value
	, cp.name
from top_container tc
left join enumeration_value ev on ev.id = tc.type_id
left join top_container_profile_rlshp tcpr on tcpr.top_container_id = tc.id
left join container_profile cp on tcpr.container_profile_id = cp.id
where type_id is null
and tc.repo_id != 11
#Should leave these as-is, since the volume is in the indicator - this should be fixed though...by the repos
and tc.indicator not like '%Vol%'
#run a separate update for this - with container type 'folder'
and cp.name not like '%folder%'
#run a separate update for this - with container type 'reel'
and cp.name not like '%microfilm%'
and cp.name not like '%envelope%'
and cp.name not like '%audiotape%'
order by cp.name
#film can? maybe keep this one in? It is a box of some kind??
