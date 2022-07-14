SELECT ev.value as rights_restriction_type
	 , replace(replace(replace(replace(replace(identifier, ',', ''), '"', ''), ']', ''), '[', ''), 'null', '') AS call_number
	 , replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(ao.display_string, '<', ''), '>', ''), '/', ''), '=', ''), '"', ''), 'emph', ''), 'render', ''), 'title', ''), ' xlink:typesimple italic', ''), 'italic', ''), 'underline', ''), 'smcaps', '') as child_title
	 , r2.title as parent_title
	 , CONCAT('/repositories/', ao.repo_id, '/archival_objects/', ao.id) as uri
	 , ao.repo_id
	, replace(replace(replace(CONVERT(note.notes using 'utf8'), '"', "'"), '{', ''), '}', '') as free_text_note
FROM rights_restriction rr
JOIN rights_restriction_type rrt on rr.id = rrt.rights_restriction_id
JOIN archival_object ao on ao.id = rr.archival_object_id
JOIN resource r2 on r2.id = ao.root_record_id
LEFT JOIN enumeration_value ev on ev.id = rrt.restriction_type_id
JOIN note on note.archival_object_id = ao.id
WHERE note.notes like '%accessrestrict%'
UNION ALL
SELECT ev.value as rights_restriction_type
	, replace(replace(replace(replace(replace(identifier, ',', ''), '"', ''), ']', ''), '[', ''), 'null', '') AS call_number
	, NULL as child_title
	, r.title as parent_title
	, CONCAT('/repositories/', r.repo_id, '/resources/', r.id) as uri
	, r.repo_id
	, replace(replace(replace(CONVERT(note.notes using 'utf8'), '"', "'"), '{', ''), '}', '') as free_text_note
FROM rights_restriction rr
JOIN rights_restriction_type rrt on rr.id = rrt.rights_restriction_id
JOIN resource r on r.id = rr.resource_id
LEFT JOIN enumeration_value ev on ev.id = rrt.restriction_type_id
JOIN note on note.resource_id = r.id
WHERE note.notes like '%accessrestrict%'