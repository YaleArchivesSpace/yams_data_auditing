SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, subject.scope_note
	, subject.created_by
	, subject.last_modified_by
	, subject.create_time
	, subject.user_mtime
FROM subject
LEFT JOIN subject_rlshp sr on sr.subject_id = subject.id
LEFT JOIN enumeration_value ev on ev.id = subject.source_id
WHERE (sr.accession_id is null 
		and sr.archival_object_id is null 
		and sr.resource_id is null 
		and sr.digital_object_id is null 
		and sr.digital_object_component_id is null)