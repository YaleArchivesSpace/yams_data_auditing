select CONCAT('https://archivesspace.library.yale.edu/subjects/', subject.id) as uri
	, subject.title
	, subject.authority_id
	, ev.value as source
	, ev2.value as term_type
	, term.term as term
	, subject.created_by
from subject
left join enumeration_value ev on ev.id = subject.source_id
left join subject_term on subject_term.subject_id = subject.id
left join term on subject_term.term_id = term.id
left join enumeration_value ev2 on ev2.id = term.term_type_id
#left join subject_rlshp on subject.id = subject_rlshp.subject_id
order by subject.title
