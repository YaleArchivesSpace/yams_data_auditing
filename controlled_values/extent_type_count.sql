#Get count of each extent type

SELECT ev.value as extent_type
	, COUNT(ev.value) as count
FROM extent
LEFT JOIN enumeration_value ev on ev.id = extent.extent_type_id
GROUP BY ev.value
ORDER BY count DESC