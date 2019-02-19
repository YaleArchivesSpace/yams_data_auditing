SELECT ao.repo_id
	, COUNT(ao.repo_id) as count
FROM rights_restriction rr
JOIN rights_restriction_type rrt on rr.id = rrt.rights_restriction_id
JOIN archival_object ao on ao.id = rr.archival_object_id
JOIN resource r2 on r2.id = ao.root_record_id
LEFT JOIN enumeration_value ev on ev.id = rrt.restriction_type_id
GROUP BY ao.repo_id
ORDER BY count desc
