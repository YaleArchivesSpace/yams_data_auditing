#get count of name_family sources

SELECT ev.value as source
	, COUNT(ev.value) as count
FROM name_family
LEFT JOIN enumeration_value ev on ev.id = name_family.source_id
GROUP BY ev.value
ORDER BY count DESC