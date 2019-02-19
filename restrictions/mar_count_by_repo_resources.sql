SELECT r.repo_id
	, COUNT(r.repo_id) as count
FROM rights_restriction rr
JOIN rights_restriction_type rrt on rr.id = rrt.rights_restriction_id
JOIN resource r on r.id = rr.resource_id
LEFT JOIN enumeration_value ev on ev.id = rrt.restriction_type_id
GROUP BY r.repo_id
ORDER BY count desc
