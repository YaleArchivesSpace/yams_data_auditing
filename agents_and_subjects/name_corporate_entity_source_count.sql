#get count of name_corporate_entity sources

SELECT ev.value as source
	, COUNT(ev.value) as count
FROM name_corporate_entity
LEFT JOIN enumeration_value ev on ev.id = name_corporate_entity.source_id
GROUP BY ev.value
ORDER BY count DESC