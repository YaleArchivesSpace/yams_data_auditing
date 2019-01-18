##get count of name_corporate_entity sources

SELECT ev.value as source
	, COUNT(ev.value) as count
FROM name_person
LEFT JOIN enumeration_value ev on ev.id = name_person.source_id
GROUP BY ev.value
ORDER BY count DESC
