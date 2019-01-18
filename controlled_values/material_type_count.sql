#Get count of each extent type

SELECT ev.value as instance_type
	, COUNT(ev.value) as count
FROM instance
LEFT JOIN enumeration_value ev on ev.id = instance.instance_type_id
GROUP BY ev.value
ORDER BY count DESC