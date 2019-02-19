SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, subject.scope_note
	, ev.value as source
	, subject.created_by
	, subject.last_modified_by
	, subject.create_time
	, subject.user_mtime
FROM subject
LEFT JOIN enumeration_value ev on ev.id = subject.source_id