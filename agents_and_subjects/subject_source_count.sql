#Get count of each extent type

SELECT ev.value as source
	, COUNT(ev.value) as count
FROM subject
LEFT JOIN enumeration_value ev on ev.id = subject.source_id
GROUP BY ev.value
ORDER BY count DESC