#Get a count of top containers associated with each container profile

SELECT cp.name as container_profile
	, COUNT(cp.name) as count
FROM top_container tc
LEFT JOIN top_container_profile_rlshp tcpr on tcpr.top_container_id = tc.id
LEFT JOIN container_profile cp on tcpr.container_profile_id = cp.id
GROUP BY cp.name