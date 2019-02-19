SELECT ev.value as rrt_type
	, COUNT(ev.value) as count
FROM rights_restriction_type rrt
LEFT JOIN enumeration_value ev on ev.id = rrt.restriction_type_id
GROUP BY ev.value
ORDER BY count DESC

#5 - Other - ColdStorageBrbl
#4 - Restricted in-process - InProcessSpecColl
#3 - Restricted fragile - RestrictedFragileSpecColl
#2 - Repository imposed access restriction - RestrictedCurApprSpecColl
#1 - Donor/University imposed access restriction - RestrictedSpecColl
#NoRequest - NoRequest
#UseSurrogate - UseSurrogate