SELECT CONCAT('/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
FROM subject
left join enumeration_value ev on ev.id = subject.source_id
where (ev.value like 'Library of Congress Subject Headings' or ev.value like 'Art and Architecture Thesaurus')